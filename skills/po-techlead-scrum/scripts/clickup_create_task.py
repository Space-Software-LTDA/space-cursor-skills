#!/usr/bin/env python3
"""
Cria uma task no ClickUp a partir de um markdown local (po-techlead-scrum).

Modos:
  esteira   — SuperAgente/Scrum → lista Esteira PBI e Tasks
              tipo Task padrao (sem custom_item_id), status PBI da lista,
              assignee Ricardo (default), campo Projeto
  imediatas — Direto pro dev → lista Tarefas IMEDIATAS
              tipo custom 0-IMEDIATA, assignee informado no onboard
              checklist NATIVO (--checklist-name + --checklist-item) na tarefa de cada dev

Imagens (igual ao Estruturador de Tarefas):
  Escrever no campo markdown_content (NAO markdown_description).
  Sintaxe: ![](attachment-url) em linha isolada.
  markdown_description e o campo de LEITURA. Se gravar nele, HTML <img>
  aparece cru na UI e ![]() nao vira bloco nativo de imagem.
  URLs externas (mermaid.ink, raw.githubusercontent) sao stripadas;
  anexe o PNG e reescreva para URL de attachment da propria task.

Uso:
  python clickup_create_task.py --mode esteira --file task.md --project BATEU --dry-run
  python clickup_create_task.py --mode esteira --file task.md --project BATEU \\
      --attach task.md --attach diagram.png --attach print.png
  python clickup_create_task.py --mode esteira --file task/cms-backend.md --project BATEU \\
      --parent 86abc123 --layer back
  python clickup_create_task.py --mode esteira --file task/cms-frontend.md --project BATEU \\
      --parent 86abc123 --layer front
  python clickup_create_task.py --mode imediatas --file x.md --assignee 72158089 \\
      --attach x.md --checklist-name Execução --checklist-item "P-BACK-1"
  python clickup_create_task.py --update-description --task-id 86abc123 \\
      --file task.md --no-banner

Credenciais: clickup.env nesta skill (ver clickup.env.example).
"""

from __future__ import annotations

import argparse
import json
import mimetypes
import os
import re
import sys
import tempfile
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Any

SKILL_DIR = Path(__file__).resolve().parent.parent
API_V2 = "https://api.clickup.com/api/v2"

H1_RE = re.compile(r"^#\s+(.+)$", re.MULTILINE)
EMOJI_PREFIX_RE = re.compile(r"^[\W_🔗📌🎯]+", re.UNICODE)
LEADING_LAYER_RE = re.compile(r"^\[(?:BACKEND|FRONTEND|BACK|FRONT)\]\s*", re.IGNORECASE)
TRAILING_LAYER_RE = re.compile(
    r"\s*[—\-–]\s*(?:Backend|Frontend|Back|Front)\s*$",
    re.IGNORECASE,
)
LAYER_PREFIX = {"back": "[BACK]", "front": "[FRONT]"}
# ![alt](url) — captura alt e url
MD_IMAGE_RE = re.compile(r"!\[([^\]]*)\]\(([^)]+)\)")
# <img src="url" ...>
HTML_IMG_RE = re.compile(
    r'<img\s+[^>]*src=["\']([^"\']+)["\'][^>]*/?>',
    re.IGNORECASE,
)
# <p> aninhado em volta de <img> (o que a API antiga gerava e o ClickUp mostra cru)
NESTED_P_IMG_RE = re.compile(
    r"(?:<p>\s*)+<img\b([^>]*?)/?>\s*(?:</p>\s*)+",
    re.IGNORECASE,
)
ATTR_SRC_RE = re.compile(r"""src=["']([^"']+)["']""", re.IGNORECASE)
ATTR_ALT_RE = re.compile(r"""alt=["']([^"']*)["']""", re.IGNORECASE)
# ClickUp autolinka URL dentro de atributo HTML: src="[https://x](https://x)"
AUTOLINK_SRC_RE = re.compile(r"^\[(https?://[^\]]+)\]\(\1\)$")
LEAKED_P_HEADING_RE = re.compile(r"^(#{1,6})\s*</p>", re.MULTILINE)
IMAGE_EXTS = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg"}


def load_env_file(path: Path) -> None:
    if not path.is_file():
        return
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, val = line.split("=", 1)
        key = key.strip()
        val = val.strip().strip('"').strip("'")
        os.environ.setdefault(key, val)


def env(name: str, default: str | None = None) -> str:
    val = os.environ.get(name, default)
    if val is None or val == "":
        raise SystemExit(f"Missing env {name}. Configure clickup.env (see clickup.env.example).")
    return val


def api_request(
    method: str,
    path: str,
    *,
    data: dict[str, Any] | None = None,
    raw_body: bytes | None = None,
    content_type: str | None = "application/json",
) -> Any:
    token = env("CLICKUP_API_TOKEN")
    url = path if path.startswith("http") else f"{API_V2}{path}"
    body = raw_body
    headers = {"Authorization": token}
    if data is not None:
        body = json.dumps(data).encode("utf-8")
        headers["Content-Type"] = "application/json"
    elif content_type and raw_body is not None:
        headers["Content-Type"] = content_type
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            raw = resp.read().decode("utf-8")
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as e:
        err = e.read().decode("utf-8", errors="replace")
        raise SystemExit(f"ClickUp API {method} {url} → HTTP {e.code}\n{err}") from e


def extract_title(markdown: str, override: str | None) -> str:
    if override:
        return override.strip()
    m = H1_RE.search(markdown)
    if not m:
        raise SystemExit("Nao achei H1 (# titulo) no markdown. Use --title.")
    title = m.group(1).strip()
    title = EMOJI_PREFIX_RE.sub("", title).strip()
    # remove leading link emoji leftovers
    title = title.lstrip("🔗 ").strip()
    return title


def apply_layer_prefix(title: str, layer: str | None) -> str:
    """[BACK] / [FRONT] no INICIO. Nao truncar. Nao repetir sufixo '— Backend'."""
    if not layer:
        return title
    prefix = LAYER_PREFIX[layer]
    cleaned = LEADING_LAYER_RE.sub("", title).strip()
    cleaned = TRAILING_LAYER_RE.sub("", cleaned).strip()
    return f"{prefix} {cleaned}"


def resolve_project_option(project_key: str) -> tuple[str, int | None]:
    """Return (option_uuid, orderindex?) for custom field Projeto."""
    key = project_key.strip().upper()
    mapping_raw = os.environ.get("CLICKUP_PROJECT_OPTIONS", "").strip()
    mapping: dict[str, str] = {}
    if mapping_raw:
        mapping = json.loads(mapping_raw)
    defaults = {
        "BATEU": os.environ.get("CLICKUP_CF_PROJETO_OPTION_BATEU", ""),
        "BATEUBET": os.environ.get("CLICKUP_CF_PROJETO_OPTION_BATEU", ""),
        "DATALAKE": os.environ.get("CLICKUP_CF_PROJETO_OPTION_BATEU", ""),
    }
    option = mapping.get(key) or mapping.get(project_key) or defaults.get(key)
    if not option:
        raise SystemExit(
            f"Projeto '{project_key}' sem option UUID. "
            "Defina CLICKUP_PROJECT_OPTIONS ou use BATEU."
        )
    order = None
    if key in {"BATEU", "BATEUBET", "DATALAKE"}:
        order_s = os.environ.get("CLICKUP_CF_PROJETO_ORDERINDEX_BATEU")
        if order_s:
            order = int(order_s)
    return option, order


def apply_clickup_banners(markdown: str) -> str:
    """Converte aviso de IA em banner ClickUp; adiciona banner de anexos se houver imagens."""
    banner_ai = (
        '<banner background-color="yellow" icon="⚠️">Esta tarefa foi estruturada com '
        "auxílio de Inteligência Artificial com base nas informações fornecidas. Embora o "
        "conteúdo tenha sido organizado para facilitar o entendimento, podem existir "
        "interpretações incorretas ou incompletas. Em caso de dúvida, valide com o "
        "solicitante antes de iniciar o desenvolvimento.</banner>\n\n"
    )
    text = markdown
    text2, n = re.subn(
        r"^>\s*⚠️?\s*Esta tarefa foi estruturada com auxílio de Inteligência Artificial"
        r".*?(?:\n>.*)*\n*",
        "",
        text,
        count=1,
        flags=re.MULTILINE,
    )
    if n:
        text = banner_ai + text2.lstrip()
    elif not text.lstrip().startswith("<banner"):
        text = banner_ai + text

    if MD_IMAGE_RE.search(text) or HTML_IMG_RE.search(text):
        banner_att = (
            '<banner background-color="blue" icon="📎">Esta tarefa contém imagens e/ou '
            "anexos que fazem parte do requisito e devem ser analisados com atenção.</banner>\n\n"
        )
        parts = text.split("</banner>", 1)
        if len(parts) == 2:
            text = parts[0] + "</banner>\n\n" + banner_att + parts[1].lstrip()
    return text


def unwrap_autolinked_url(url: str) -> str:
    """Desfaz src='[https://x](https://x)' que o GET do ClickUp inventa."""
    raw = (url or "").strip()
    m = AUTOLINK_SRC_RE.match(raw)
    return m.group(1) if m else raw


def md_image_tag(alt: str, url: str) -> str:
    """
    Estruturador: ![](attachment-url). Sem \\n extra — o .md local já tem
    a linha em branco do parágrafo; \\n\\n aqui vira o vão enorme na UI.
    """
    del alt
    clean = unwrap_autolinked_url(url)
    return f"![]({clean})"


def html_img_blocks_to_markdown(text: str) -> str:
    """
    Converte <p><img> / <img> legado em ![](url).
    Também limpa `### </p>Título` de publicações antigas.
    """

    def repl(m: re.Match[str]) -> str:
        attrs = m.group(1)
        src_m = ATTR_SRC_RE.search(attrs)
        if not src_m:
            return m.group(0)
        alt_m = ATTR_ALT_RE.search(attrs)
        alt = alt_m.group(1) if alt_m else ""
        return md_image_tag(alt, src_m.group(1))

    text = NESTED_P_IMG_RE.sub(repl, text)
    text = LEAKED_P_HEADING_RE.sub(r"\1 ", text)
    return text


def collect_image_urls(markdown: str) -> list[tuple[str, str]]:
    """Lista (alt_or_empty, url) na ordem do documento."""
    found: list[tuple[str, str]] = []
    seen: set[str] = set()
    normalized = html_img_blocks_to_markdown(markdown)
    for m in MD_IMAGE_RE.finditer(normalized):
        url = unwrap_autolinked_url(m.group(2).strip())
        if url not in seen:
            seen.add(url)
            found.append((m.group(1), url))
    for m in HTML_IMG_RE.finditer(normalized):
        url = unwrap_autolinked_url(m.group(1).strip())
        if url not in seen:
            seen.add(url)
            found.append(("", url))
    return found


def is_clickup_attachment_url(url: str) -> bool:
    return "clickup-attachments.com" in url or "attachments.clickup.com" in url


def download_url_to_temp(url: str) -> Path:
    req = urllib.request.Request(url, headers={"User-Agent": "po-techlead-scrum/1.0"})
    with urllib.request.urlopen(req, timeout=120) as resp:
        data = resp.read()
        ctype = resp.headers.get("Content-Type", "application/octet-stream")
    suffix = ".png"
    path_part = urllib.parse.urlparse(url).path
    ext = Path(path_part).suffix.lower()
    if ext in IMAGE_EXTS:
        suffix = ext
    elif "jpeg" in ctype or "jpg" in ctype:
        suffix = ".jpg"
    elif "gif" in ctype:
        suffix = ".gif"
    elif "webp" in ctype:
        suffix = ".webp"
    name = Path(path_part).name or f"image{suffix}"
    if not name.lower().endswith(suffix):
        name = name + suffix
    name = re.sub(r"[^\w.\-]+", "_", name)[:120]
    tmp = Path(tempfile.gettempdir()) / f"cu-img-{os.getpid()}-{name}"
    tmp.write_bytes(data)
    return tmp


def attachment_public_url(att: dict[str, Any]) -> str:
    for key in ("url", "url_w_query", "url_w_host"):
        val = att.get(key)
        if isinstance(val, str) and val.startswith("http"):
            return val
    for key in ("attachment", "data"):
        nested = att.get(key)
        if isinstance(nested, dict):
            u = attachment_public_url(nested)
            if u:
                return u
    return ""


def attach_file(task_id: str, file_path: Path) -> Any:
    """Upload attachment via multipart (stdlib)."""
    boundary = "----CursorClickUpBoundary7MA4YWxkTrZu0gW"
    filename = file_path.name
    mime = mimetypes.guess_type(filename)[0] or "application/octet-stream"
    file_bytes = file_path.read_bytes()
    parts: list[bytes] = []
    parts.append(f"--{boundary}\r\n".encode())
    parts.append(
        (
            f'Content-Disposition: form-data; name="attachment"; filename="{filename}"\r\n'
            f"Content-Type: {mime}\r\n\r\n"
        ).encode()
    )
    parts.append(file_bytes)
    parts.append(b"\r\n")
    parts.append(f"--{boundary}--\r\n".encode())
    body = b"".join(parts)
    return api_request(
        "POST",
        f"/task/{task_id}/attachment",
        raw_body=body,
        content_type=f"multipart/form-data; boundary={boundary}",
    )


def attachment_url_from_meta(att: dict[str, Any]) -> str:
    direct = attachment_public_url(att)
    if direct:
        return direct
    att_id = str(att.get("id") or "")
    title = str(att.get("title") or att.get("name") or "")
    if not att_id or not title:
        return ""
    uuid = Path(att_id).stem
    ws = os.environ.get("CLICKUP_WORKSPACE_ID") or ""
    if not ws:
        return ""
    return f"https://t{ws}.p.clickup-attachments.com/t{ws}/{uuid}/{title}"


def list_task_attachments(task_id: str) -> dict[str, str]:
    """filename → URL pública. Reusa anexos já na task (update-description)."""
    data = api_request("GET", f"/task/{task_id}")
    out: dict[str, str] = {}
    for att in data.get("attachments") or []:
        if not isinstance(att, dict):
            continue
        url = attachment_url_from_meta(att)
        title = str(att.get("title") or att.get("name") or "")
        name = Path(title).name
        if url and name:
            out[name] = url
            alias = re.sub(r"^cu-img-\d+-", "", name)
            if alias != name:
                out.setdefault(alias, url)
    return out


def rewrite_images_to_attachments(
    markdown: str,
    url_map: dict[str, str],
) -> str:
    """
    Substitui URLs de imagem por ![](attachment-url) — formato do Estruturador.

    Gravado em markdown_content. Proibido <img> / <p><img>: no campo errado
    (markdown_description) isso aparece como HTML cru. Blocos ```mermaid
    não são tocados.
    """

    def mapped(url: str) -> str:
        clean = unwrap_autolinked_url(url)
        return unwrap_autolinked_url(url_map.get(clean, url_map.get(url, clean)))

    def repl_md(m: re.Match[str]) -> str:
        return md_image_tag(m.group(1), mapped(m.group(2).strip()))

    def repl_html(m: re.Match[str]) -> str:
        alt_m = ATTR_ALT_RE.search(m.group(0))
        alt = alt_m.group(1) if alt_m else ""
        return md_image_tag(alt, mapped(m.group(1).strip()))

    text = html_img_blocks_to_markdown(markdown)
    text = MD_IMAGE_RE.sub(repl_md, text)
    text = HTML_IMG_RE.sub(repl_html, text)
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text


def embed_images_after_attach(
    task_id: str,
    markdown: str,
    attached_by_name: dict[str, str],
) -> str:
    """
    Garante que cada imagem do markdown vire URL de attachment ClickUp.
    Baixa URLs remotos se ainda nao anexadas; reusa attachment por nome de arquivo.
    """
    url_map: dict[str, str] = {}
    temps: list[Path] = []

    try:
        for _alt, url in collect_image_urls(markdown):
            url = unwrap_autolinked_url(url)
            if is_clickup_attachment_url(url):
                url_map[url] = url
                continue

            filename = Path(urllib.parse.urlparse(url).path).name
            if filename and filename in attached_by_name:
                url_map[url] = attached_by_name[filename]
                continue

            try:
                if url.startswith("http://") or url.startswith("https://"):
                    tmp = download_url_to_temp(url)
                    temps.append(tmp)
                    att = attach_file(task_id, tmp)
                    att_url = attachment_url_from_meta(att) or attachment_public_url(att)
                    if not att_url:
                        print(f"WARN attachment sem URL: {filename}", file=sys.stderr)
                        continue
                    attached_by_name[tmp.name] = att_url
                    url_map[url] = att_url
                    print(f"Image attached: {tmp.name} -> {att_url[:80]}...")
                else:
                    local = Path(url)
                    if local.is_file():
                        att = attach_file(task_id, local)
                        att_url = attachment_url_from_meta(att) or attachment_public_url(att)
                        if att_url:
                            attached_by_name[local.name] = att_url
                            url_map[url] = att_url
                            print(f"Image attached: {local.name}")
            except Exception as exc:  # noqa: BLE001
                print(f"WARN falha ao anexar imagem {url}: {exc}", file=sys.stderr)

        return rewrite_images_to_attachments(markdown, url_map)
    finally:
        for t in temps:
            try:
                t.unlink(missing_ok=True)
            except OSError:
                pass


def build_payload(
    *,
    mode: str,
    title: str,
    markdown: str,
    assignee_ids: list[int],
    project_key: str | None,
    parent: str | None = None,
) -> dict[str, Any]:
    payload: dict[str, Any] = {
        "name": title,
        "markdown_content": markdown,
        "assignees": assignee_ids,
    }
    if parent:
        payload["parent"] = parent

    if mode == "esteira":
        # Tipo = Task padrao do ClickUp (NAO usar custom 3-PBI).
        payload["status"] = env("CLICKUP_STATUS_ESTEIRA_PBI")
        if not project_key:
            raise SystemExit("--project e obrigatorio no modo esteira (ex.: BATEU).")
        option_uuid, orderindex = resolve_project_option(project_key)
        # API aceita orderindex numerico (como nas tasks existentes) ou UUID
        value: Any = orderindex if orderindex is not None else option_uuid
        payload["custom_fields"] = [
            {"id": env("CLICKUP_CF_PROJETO"), "value": value}
        ]
    elif mode == "imediatas":
        payload["custom_item_id"] = int(env("CLICKUP_CUSTOM_TYPE_IMEDIATA"))
        if project_key:
            option_uuid, orderindex = resolve_project_option(project_key)
            value = orderindex if orderindex is not None else option_uuid
            payload["custom_fields"] = [
                {"id": env("CLICKUP_CF_PROJETO"), "value": value}
            ]
    else:
        raise SystemExit("--mode deve ser esteira|imediatas")

    return payload


def add_native_checklist(task_id: str, name: str, items: list[str]) -> str:
    """Cria checklist nativo do ClickUp (nao e markdown). Imediatas."""
    if not items:
        raise SystemExit("Checklist nativo exige pelo menos um --checklist-item.")
    created = api_request("POST", f"/task/{task_id}/checklist", data={"name": name})
    checklist = created.get("checklist") or created
    cid = checklist.get("id")
    if not cid:
        raise SystemExit(f"ClickUp nao devolveu id do checklist: {created}")
    for item in items:
        text = str(item).strip()
        if not text:
            continue
        api_request("POST", f"/checklist/{cid}/checklist_item", data={"name": text})
    return str(cid)


def parse_assignees(args: argparse.Namespace, mode: str) -> list[int]:
    ids: list[int] = []
    if args.assignee:
        for part in args.assignee:
            ids.extend(int(x) for x in str(part).split(",") if x.strip())
    elif mode == "esteira":
        ids.append(int(env("CLICKUP_ASSIGNEE_RICARDO")))
    else:
        raise SystemExit("Modo imediatas exige --assignee <user_id> (pergunte no onboard).")
    return ids


def main() -> None:
    load_env_file(SKILL_DIR / "clickup.env")

    parser = argparse.ArgumentParser(description="Cria task ClickUp a partir de markdown")
    parser.add_argument("--mode", choices=["esteira", "imediatas"], default=None)
    parser.add_argument("--file", default=None, help="Markdown da task local")
    parser.add_argument("--title", default=None, help="Override do titulo (default = H1)")
    parser.add_argument(
        "--project",
        default=None,
        help="Chave do projeto para o campo Projeto (ex.: BATEU). Obrigatorio na esteira.",
    )
    parser.add_argument(
        "--assignee",
        action="append",
        default=[],
        help="User id ClickUp (pode repetir). Esteira default = Ricardo.",
    )
    parser.add_argument(
        "--attach",
        action="append",
        default=[],
        help="Arquivo para anexar apos criar (pode repetir). Inclua PNGs + .md + OpenAPI/DBML.",
    )
    parser.add_argument(
        "--parent",
        default=None,
        help="Task ID pai: cria esta task como SUBTASK. Front+Back: MASTER sem --parent; Back/Front com --parent <id da MASTER>.",
    )
    parser.add_argument(
        "--layer",
        choices=["back", "front"],
        default=None,
        help="Prefixa o titulo com [BACK] ou [FRONT]. Obrigatorio com --parent.",
    )
    parser.add_argument(
        "--checklist-name",
        default="Execução",
        help="Nome do checklist NATIVO do ClickUp (Imediatas). Nao e markdown.",
    )
    parser.add_argument(
        "--checklist-item",
        action="append",
        default=[],
        help="Item do checklist nativo (repetir). Imediatas: obrigatorio na tarefa de cada dev.",
    )
    parser.add_argument(
        "--checklist-only",
        action="store_true",
        help="So adiciona checklist nativo em --task-id (task ja criada).",
    )
    parser.add_argument("--task-id", default=None, help="Task ID para --checklist-only.")
    parser.add_argument(
        "--no-banner",
        action="store_true",
        help="Nao converter aviso de IA / anexos em <banner> ClickUp.",
    )
    parser.add_argument(
        "--update-description",
        action="store_true",
        help="Nao cria task: PUT da descricao em --task-id a partir de --file (reescreve imagens).",
    )
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    checklist_items = [str(x).strip() for x in args.checklist_item if str(x).strip()]

    if args.checklist_only:
        if not args.task_id:
            raise SystemExit("--checklist-only exige --task-id.")
        if not checklist_items:
            raise SystemExit("--checklist-only exige --checklist-item.")
        plan = {
            "checklist_only": True,
            "task_id": args.task_id,
            "checklist_name": args.checklist_name,
            "checklist_items": checklist_items,
        }
        print(json.dumps(plan, ensure_ascii=False, indent=2))
        if args.dry_run:
            print("\nDRY-RUN — nada criado no ClickUp.")
            return
        cid = add_native_checklist(args.task_id, args.checklist_name, checklist_items)
        print(json.dumps({"task_id": args.task_id, "checklist_id": cid}, ensure_ascii=False))
        return

    if args.update_description:
        if not args.task_id:
            raise SystemExit("--update-description exige --task-id.")
        if not args.file:
            raise SystemExit("--update-description exige --file.")
        md_path = Path(args.file).resolve()
        if not md_path.is_file():
            raise SystemExit(f"Arquivo nao encontrado: {md_path}")
        markdown = md_path.read_text(encoding="utf-8")
        if not args.no_banner:
            markdown = apply_clickup_banners(markdown)
        attach_paths = args.attach or []
        plan = {
            "update_description": True,
            "task_id": args.task_id,
            "file": str(md_path),
            "attachments": attach_paths,
            "images_in_md": [u for _, u in collect_image_urls(markdown)],
            "no_banner": args.no_banner,
            "markdown_chars": len(markdown),
        }
        print(json.dumps(plan, ensure_ascii=False, indent=2))
        if args.dry_run:
            preview = rewrite_images_to_attachments(
                markdown,
                {
                    u: (
                        f"https://example.invalid/"
                        f"{Path(urllib.parse.urlparse(u).path).name or 'img.png'}"
                    )
                    for _, u in collect_image_urls(markdown)
                },
            )
            nested = len(NESTED_P_IMG_RE.findall(preview))
            html_img = len(HTML_IMG_RE.findall(preview))
            print(f"\nDRY-RUN rewrite: nested_p_img={nested} leftover_html_img={html_img}")
            print("DRY-RUN — nada alterado no ClickUp.")
            return
        attached_by_name = list_task_attachments(args.task_id)
        print(f"Existing attachments: {list(attached_by_name)}")
        for ap in attach_paths:
            p = Path(ap).resolve()
            if not p.is_file():
                print(f"WARN skip missing attachment: {p}", file=sys.stderr)
                continue
            if p.name in attached_by_name:
                print(f"Reuse attachment: {p.name}")
                continue
            att = attach_file(args.task_id, p)
            att_url = attachment_url_from_meta(att) if isinstance(att, dict) else ""
            if not att_url and isinstance(att, dict):
                att_url = attachment_public_url(att)
            if att_url:
                attached_by_name[p.name] = att_url
            print(f"Attached: {p.name} -> {att_url[:80] if att_url else 'ok'}")
        final_md = embed_images_after_attach(args.task_id, markdown, attached_by_name)
        api_request(
            "PUT",
            f"/task/{args.task_id}",
            data={"markdown_content": final_md},
        )
        print(json.dumps({
            "id": args.task_id,
            "updated": True,
            "nested_p_img": len(NESTED_P_IMG_RE.findall(final_md)),
            "html_img": len(HTML_IMG_RE.findall(final_md)),
            "md_images": len(MD_IMAGE_RE.findall(final_md)),
        }, ensure_ascii=False))
        return

    if args.mode is None or not args.file:
        raise SystemExit(
            "Criar task exige --mode e --file. "
            "Para so checklist: --checklist-only --task-id. "
            "Para republicar descricao: --update-description --task-id --file."
        )
    if args.mode == "esteira" and checklist_items:
        raise SystemExit("Checklist nativo e so Imediatas. Esteira: o Ritter vira PBI/Task.")

    md_path = Path(args.file).resolve()
    if not md_path.is_file():
        raise SystemExit(f"Arquivo nao encontrado: {md_path}")
    markdown = md_path.read_text(encoding="utf-8")
    if not args.no_banner:
        markdown = apply_clickup_banners(markdown)
    title = extract_title(markdown, args.title)
    if args.parent and not args.layer:
        raise SystemExit("Subtask (--parent) exige --layer back|front ([BACK]/[FRONT] no inicio do titulo).")
    if args.layer and not args.parent:
        print("WARN: --layer sem --parent. MAIN normalmente nao leva [BACK]/[FRONT].", file=sys.stderr)
    title = apply_layer_prefix(title, args.layer)
    assignees = parse_assignees(args, args.mode)
    list_id = env(
        "CLICKUP_LIST_ESTEIRA" if args.mode == "esteira" else "CLICKUP_LIST_IMEDIATAS"
    )

    payload = build_payload(
        mode=args.mode,
        title=title,
        markdown=markdown,
        assignee_ids=assignees,
        project_key=args.project,
        parent=args.parent,
    )

    attach_paths = args.attach if args.attach else [str(md_path)]
    plan = {
        "mode": args.mode,
        "list_id": list_id,
        "title": title,
        "assignees": assignees,
        "project": args.project,
        "parent": args.parent,
        "attachments": attach_paths,
        "images_in_md": [u for _, u in collect_image_urls(markdown)],
        "checklist_name": args.checklist_name if checklist_items else None,
        "checklist_items": checklist_items,
        "payload_preview": {
            k: v for k, v in payload.items() if k != "markdown_content"
        },
        "markdown_chars": len(markdown),
    }
    print(json.dumps(plan, ensure_ascii=False, indent=2))
    if args.mode == "imediatas" and not checklist_items:
        print(
            "WARN: Imediatas sem --checklist-item. "
            "Checklist nativo e obrigatorio na tarefa principal de cada dev "
            "(pai se uma camada; subtask Back/Front se as duas; MAIN sem checklist).",
            file=sys.stderr,
        )

    if args.dry_run:
        print("\nDRY-RUN — nada criado no ClickUp.")
        return

    created = api_request("POST", f"/list/{list_id}/task", data=payload)
    task_id = created.get("id")
    task_url = created.get("url")
    print(f"\nCreated task id={task_id}")
    print(f"URL: {task_url}")

    attached_by_name: dict[str, str] = {}
    for ap in attach_paths:
        p = Path(ap).resolve()
        if not p.is_file():
            print(f"WARN skip missing attachment: {p}", file=sys.stderr)
            continue
        att = attach_file(task_id, p)
        att_url = attachment_public_url(att)
        if att_url:
            attached_by_name[p.name] = att_url
        print(f"Attached: {p.name} -> {att_url[:80] if att_url else att.get('id') or 'ok'}")

    final_md = embed_images_after_attach(task_id, markdown, attached_by_name)
    api_request(
        "PUT",
        f"/task/{task_id}",
        data={"markdown_content": final_md},
    )
    if final_md != markdown:
        print("Updated description with ClickUp attachment image URLs.")
    else:
        print("Description refreshed.")

    if checklist_items:
        cid = add_native_checklist(task_id, args.checklist_name, checklist_items)
        print(f"Checklist nativo id={cid} itens={len(checklist_items)}")

    print(json.dumps({"id": task_id, "url": task_url}, ensure_ascii=False))


if __name__ == "__main__":
    main()
