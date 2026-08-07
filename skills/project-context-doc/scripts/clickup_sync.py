#!/usr/bin/env python3
"""
Publica README.md + docs/NN-*.md no ClickUp como UM Doc (pagina principal + subpaginas).

Script generico da skill project-context-doc — funciona em qualquer workspace que siga
a convencao de arquivos numerados (01-contexto.md, 02-fluxos.md, ...).

Uso:
  python3 ~/.cursor/skills/project-context-doc/scripts/clickup_sync.py --dry-run
  python3 ~/.cursor/skills/project-context-doc/scripts/clickup_sync.py --workspace /path/projeto

Credenciais: `clickup.env` na skill (global) + `.docs/clickup.env` no projeto (overrides).
Env vars da sessao tem prioridade. Ver clickup-sync-guide.md na skill.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any

SKILL_DIR = Path(__file__).resolve().parent.parent

API_BASE = "https://api.clickup.com/api/v3"
SUBPAGE_PATTERN = re.compile(r"^(\d{2})-(.+)\.md$")
ANCHOR_RE = re.compile(r'<a\s+id="[^"]+"></a>\s*', re.IGNORECASE)
SUBPAGE_HEADER_RE = re.compile(r"^> Subpagina \*\*.+\*\* — .+\n\n", re.MULTILINE)
NAV_FOOTER_RE = re.compile(r"\n\n---\n\n\n\*\*Navegacao:\*\* .+$", re.DOTALL)
CLICKUP_PUBLISH_FOOTER_RE = re.compile(
    r"\n\n---\n\n\n## Publicar no ClickUp\n\n.+$", re.DOTALL
)
CROSS_PAGE_LINK_RE = re.compile(
    r"\[([^\]]+)\]\((?:docs/)?(\d{2}-[^)]+\.md)#([^)]+)\)"
)
HASH_LINK_RE = re.compile(r"\[([^\]]+)\]\(#[^)]+\)")
MULTI_HR_RE = re.compile(r"(\n---\s*\n\s*){2,}")
LEADING_HR_RE = re.compile(r"^(?:\s*---\s*\n)+")
FIRST_H2_RE = re.compile(r"^##[^\n]+\n+", re.MULTILINE)
H4_BLOCK_RE = re.compile(
    r"^#### ([^\n]+)\n+(.*?)(?=\n(?:#### |### |---|\Z))",
    re.MULTILINE | re.DOTALL,
)
TABLE_ROW_RE = re.compile(r"^\|.+\|\s*$")

# Secoes narrativas — preservar #### no ClickUp (outline H4)
H4_PRESERVE_EXACT = frozenset({
    "Indice deste modulo — Fluxos",
    "Indice deste modulo — Regras de Negocio",
    "Indice deste modulo — Guardrails",
    "Indice deste modulo — Tabelas (TB)",
    "Indice deste modulo — Rotas — Tier 1 resumo",
    "Por que este fluxo importa",
    "Cenario",
    "Pre-condicoes",
    "O que acontece passo a passo",
    "Quando o dev usa esta rota",
    "Exemplo de request",
    "Ver tambem",
})
H4_PRESERVE_PREFIXES = ("Indice deste modulo —",)
H4_RT_MODULE_RE = re.compile(r"^[\w-]+ — Modulo ")


def should_preserve_h4(title: str) -> bool:
    t = title.strip()
    if t in H4_PRESERVE_EXACT:
        return True
    if H4_RT_MODULE_RE.match(t):
        return True
    return any(t.startswith(p) for p in H4_PRESERVE_PREFIXES)


def collapse_excessive_blank_lines(text: str, *, max_consecutive: int = 1) -> str:
    """Remove 2+ linhas vazias consecutivas e --- orfaos entre blank lines."""

    lines = text.splitlines()
    out: list[str] = []
    blank_run = 0
    for line in lines:
        stripped = line.strip()
        if stripped == "":
            blank_run += 1
            if blank_run <= max_consecutive:
                out.append("")
            continue
        if stripped == "---" and blank_run >= max_consecutive and out and out[-1] == "":
            blank_run = 0
            continue
        blank_run = 0
        out.append(line)
    while out and out[-1] == "":
        out.pop()
    return "\n".join(out)


def is_table_row(line: str) -> bool:
    return bool(TABLE_ROW_RE.match(line.strip()))


def ensure_blank_line_after_tables(text: str) -> str:
    """ClickUp interpreta linha pos-tabela como nova linha da tabela se nao houver linha vazia."""

    lines = text.splitlines()
    out: list[str] = []
    prev_was_table = False
    for line in lines:
        is_table = is_table_row(line)
        if prev_was_table and not is_table and line.strip() and out and out[-1].strip():
            out.append("")
        out.append(line)
        prev_was_table = is_table
    return "\n".join(out)


def flatten_h4_for_clickup(text: str) -> str:
    """Achata #### em **Label** — texto, exceto secoes narrativas FL/WH/RT."""

    def repl(m: re.Match[str]) -> str:
        title, body = m.group(1).strip(), m.group(2).strip()
        if should_preserve_h4(title):
            # Remove linha vazia imediata apos titulo (anti placeholder ClickUp)
            body = re.sub(r"^\s*\n", "", body, count=1)
            return f"#### {title}\n{body}"
        if body.startswith("-") or body.startswith("|"):
            return f"**{title}**\n{body}"
        if "\n\n" in body:
            return f"**{title}**\n\n{body}"
        return f"**{title}** — {body}"

    return H4_BLOCK_RE.sub(repl, text)


class ClickUpError(RuntimeError):
    pass


def load_dotenv_file(path: Path) -> None:
    """Carrega KEY=VALUE de arquivo .env sem sobrescrever env ja definido."""
    if not path.is_file():
        return
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if "=" not in line:
            continue
        key, _, value = line.partition("=")
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


def load_dotenv_files(workspace: Path) -> None:
    load_dotenv_file(SKILL_DIR / "clickup.env")
    load_dotenv_file(workspace / ".docs" / "clickup.env")


def env(name: str, *, required: bool = False, default: str | None = None) -> str | None:
    value = os.environ.get(name, default)
    if required and not value:
        raise ClickUpError(f"Variavel obrigatoria ausente: {name}")
    return value


def slug_to_title(slug: str) -> str:
    return slug.replace("-", " ").strip().title()


def clickup_page_name(order: str, slug: str) -> str:
    return f"{order} — {slug_to_title(slug)}"


def _anchor_to_id(anchor: str) -> str:
    parts = anchor.lower().split("-", 1)
    if len(parts) == 2 and parts[0] in ("fl", "rn", "g", "tb", "rt", "wh", "int", "da"):
        return f"{parts[0].upper()}-{parts[1]}"
    return anchor.upper()


def _page_ref_from_fname(fname: str) -> str:
    order = fname[:2]
    slug_part = fname[3:-3]
    return f"{order} {slug_part.replace('-', ' ').title()}"


def demote_cross_page_link(m: re.Match[str]) -> str:
    text, fname, anchor = m.group(1), m.group(2), m.group(3)
    page_ref = _page_ref_from_fname(fname)
    if text.startswith("#"):
        text = _anchor_to_id(anchor)
    if page_ref not in text:
        text = f"{text} · {page_ref}"
    return text


def prepare_for_clickup(
    content: str,
    *,
    strip_publish_footer: bool = False,
    is_subpage: bool = False,
) -> str:
    text = ANCHOR_RE.sub("", content)
    text = SUBPAGE_HEADER_RE.sub("", text)
    text = NAV_FOOTER_RE.sub("", text)
    if strip_publish_footer:
        text = CLICKUP_PUBLISH_FOOTER_RE.sub("", text)

    if is_subpage:
        text = LEADING_HR_RE.sub("", text)
        text = FIRST_H2_RE.sub("", text, count=1)
        text = LEADING_HR_RE.sub("", text)

    # Links cross-page nao clicam entre subpaginas — texto pesquisavel
    text = CROSS_PAGE_LINK_RE.sub(demote_cross_page_link, text)
    # ClickUp transforma (#ancora) em http://#ancora — link quebrado
    text = HASH_LINK_RE.sub(r"\1", text)
    text = flatten_h4_for_clickup(text)
    text = ensure_blank_line_after_tables(text)
    text = collapse_excessive_blank_lines(text)
    text = MULTI_HR_RE.sub("\n\n---\n\n", text)
    text = collapse_excessive_blank_lines(text)

    return text.strip()


def discover_subpages(docs_dir: Path) -> list[tuple[str, str, str, Path]]:
    """Retorna (display_name, fname, slug, path) ordenado por prefixo numerico."""
    found: list[tuple[str, str, str, Path]] = []
    for path in sorted(docs_dir.glob("*.md")):
        m = SUBPAGE_PATTERN.match(path.name)
        if not m:
            continue
        order, slug = m.group(1), m.group(2)
        found.append((clickup_page_name(order, slug), path.name, slug, path))
    if not found:
        raise ClickUpError(
            f"Nenhuma subpagina em {docs_dir}/ — esperado docs/01-*.md, 02-*.md, ..."
        )
    return found


def api_request(
    method: str,
    path: str,
    token: str,
    body: dict[str, Any] | None = None,
) -> Any:
    url = f"{API_BASE}{path}"
    data = json.dumps(body).encode("utf-8") if body is not None else None
    req = urllib.request.Request(
        url,
        data=data,
        method=method,
        headers={
            "Authorization": token,
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            raw = resp.read().decode("utf-8")
            if not raw.strip():
                return None
            return json.loads(raw)
    except urllib.error.HTTPError as exc:
        detail = exc.read().decode("utf-8", errors="replace")
        raise ClickUpError(f"{method} {path} -> HTTP {exc.code}: {detail}") from exc


def search_docs(token: str, workspace_id: str, name: str) -> list[dict[str, Any]]:
    result = api_request("GET", f"/workspaces/{workspace_id}/docs?limit=100", token)
    if not isinstance(result, dict):
        return []
    docs = result.get("docs") or result.get("data") or result
    if not isinstance(docs, list):
        return []
    return [d for d in docs if isinstance(d, dict) and d.get("name") == name]


def resolve_doc_parent(
    workspace_id: str, parent_id: str | None, parent_type: int
) -> tuple[str, int]:
    """Sem parent explicito → Doc na pagina global Documentos do workspace (type 12)."""
    if parent_id:
        return str(parent_id), parent_type
    return str(workspace_id), 12


def create_doc(
    token: str,
    workspace_id: str,
    name: str,
    parent_id: str | None,
    parent_type: int,
    visibility: str,
) -> dict[str, Any]:
    pid, ptype = resolve_doc_parent(workspace_id, parent_id, parent_type)
    body: dict[str, Any] = {
        "name": name,
        "create_page": True,
        "visibility": visibility,
        "parent": {"id": pid, "type": ptype},
    }
    result = api_request("POST", f"/workspaces/{workspace_id}/docs", token, body)
    if not isinstance(result, dict) or "id" not in result:
        raise ClickUpError(f"Resposta inesperada ao criar Doc: {result!r}")
    return result


def fetch_page_listing(token: str, workspace_id: str, doc_id: str) -> list[dict[str, Any]]:
    result = api_request(
        "GET",
        f"/workspaces/{workspace_id}/docs/{doc_id}/page_listing?max_page_depth=-1",
        token,
    )
    if not isinstance(result, list):
        raise ClickUpError(f"Page listing invalido: {result!r}")
    return result


def find_root_page(pages: list[dict[str, Any]]) -> dict[str, Any]:
    for page in pages:
        if not page.get("parent_page_id"):
            return page
    if pages:
        return pages[0]
    raise ClickUpError("Doc criado sem paginas — page_listing vazio")


def flatten_pages(pages: list[dict[str, Any]]) -> dict[str, str]:
    out: dict[str, str] = {}

    def walk(items: list[dict[str, Any]]) -> None:
        for item in items:
            name = item.get("name") or ""
            pid = item.get("id")
            if name and pid and name not in out:
                out[name] = str(pid)
            for child in item.get("pages") or []:
                if isinstance(child, dict):
                    walk([child])

    walk(pages)
    return out


def edit_page(
    token: str,
    workspace_id: str,
    doc_id: str,
    page_id: str,
    *,
    name: str | None = None,
    content: str,
) -> None:
    body: dict[str, Any] = {
        "content": content,
        "content_format": "text/md",
        "content_edit_mode": "replace",
    }
    if name:
        body["name"] = name
    api_request(
        "PUT",
        f"/workspaces/{workspace_id}/docs/{doc_id}/pages/{page_id}",
        token,
        body,
    )


def create_subpage(
    token: str,
    workspace_id: str,
    doc_id: str,
    *,
    name: str,
    content: str,
    parent_page_id: str,
) -> dict[str, Any]:
    body = {
        "name": name,
        "content": content,
        "content_format": "text/md",
        "parent_page_id": parent_page_id,
    }
    result = api_request(
        "POST",
        f"/workspaces/{workspace_id}/docs/{doc_id}/pages",
        token,
        body,
    )
    if not isinstance(result, dict):
        raise ClickUpError(f"Resposta inesperada ao criar pagina '{name}': {result!r}")
    return result


def load_local_pages(workspace: Path) -> tuple[str, list[tuple[str, str, str]]]:
    readme_path = workspace / "README.md"
    docs_dir = workspace / "docs"
    if not readme_path.is_file():
        raise ClickUpError(f"README nao encontrado: {readme_path}")
    if not docs_dir.is_dir():
        raise ClickUpError(f"Pasta docs/ nao encontrada: {docs_dir}")
    readme = prepare_for_clickup(
        readme_path.read_text(encoding="utf-8"),
        strip_publish_footer=True,
        is_subpage=False,
    )
    subpages: list[tuple[str, str, str]] = []
    for display_name, fname, _slug, path in discover_subpages(docs_dir):
        content = prepare_for_clickup(path.read_text(encoding="utf-8"), is_subpage=True)
        subpages.append((display_name, fname, content))
    return readme, subpages


def sync(args: argparse.Namespace) -> None:
    workspace = Path(args.workspace).resolve()
    load_dotenv_files(workspace)
    state_path = workspace / ".docs" / "clickup_sync_state.json"
    readme, subpages = load_local_pages(workspace)

    if args.dry_run:
        workspace_id = env("CLICKUP_WORKSPACE_ID") or "(nao definido)"
        doc_name = env("CLICKUP_DOC_NAME", default="[Produto] — Contexto")
        parent_id = env("CLICKUP_DOC_PARENT_ID")
        parent_type = int(env("CLICKUP_DOC_PARENT_TYPE", default="12") or "12")
        pid, ptype = resolve_doc_parent(workspace_id or "", parent_id, parent_type)
        print("=== DRY RUN — nada sera enviado ao ClickUp ===\n")
        print(f"Workspace path: {workspace}")
        print(f"ClickUp workspace_id: {workspace_id}")
        print(f"Doc: {doc_name}")
        print(f"Parent: id={pid} type={ptype} ({'WORKSPACE global' if ptype == 12 else 'custom'})")
        print(f"\nPagina principal (~{len(readme)} chars): README.md")
        for display_name, fname, content in subpages:
            print(f"  Subpagina '{display_name}' (~{len(content)} chars): docs/{fname}")
        print("\n=== Credenciais — pedir ao usuario na Fase 5 ===")
        print("  CLICKUP_API_TOKEN      (pk_...) — Settings > Apps > API Token")
        print("  CLICKUP_WORKSPACE_ID   (numerico)")
        print("Opcionais:")
        print("  CLICKUP_DOC_PARENT_ID + CLICKUP_DOC_PARENT_TYPE (default: workspace global, type 12)")
        return

    token = env("CLICKUP_API_TOKEN", required=True)
    workspace_id = env("CLICKUP_WORKSPACE_ID", required=True)
    doc_name = env("CLICKUP_DOC_NAME", default="[Produto] — Contexto")
    parent_id = env("CLICKUP_DOC_PARENT_ID")
    parent_type = int(env("CLICKUP_DOC_PARENT_TYPE", default="12") or "12")
    visibility = env("CLICKUP_DOC_VISIBILITY", default="PRIVATE") or "PRIVATE"

    doc_id = args.doc_id or env("CLICKUP_DOC_ID")
    if not doc_id:
        existing = search_docs(token, workspace_id, doc_name or "")
        if existing and not args.force:
            ids = ", ".join(str(d.get("id")) for d in existing[:3])
            raise ClickUpError(
                f"Doc '{doc_name}' ja existe (id: {ids}). "
                "Use --doc-id para atualizar ou --force para criar outro."
            )
        created = create_doc(
            token, workspace_id, doc_name or "Contexto", parent_id, parent_type, visibility
        )
        doc_id = str(created["id"])
        parent = created.get("parent") or {}
        print(f"Doc criado: {doc_id} (parent type={parent.get('type')}, id={parent.get('id')})")

    pages = fetch_page_listing(token, workspace_id, doc_id)
    root = find_root_page(pages)
    root_id = str(root["id"])
    print(f"Pagina principal: {root_id} ({root.get('name', '?')})")

    edit_page(
        token,
        workspace_id,
        doc_id,
        root_id,
        name=doc_name or root.get("name") or "Indice principal",
        content=readme,
    )
    print("Pagina principal atualizada.")

    existing_by_name = flatten_pages(pages)
    subpage_ids: dict[str, str] = {}

    for display_name, _fname, content in subpages:
        if display_name in existing_by_name and args.update_existing:
            pid = existing_by_name[display_name]
            edit_page(token, workspace_id, doc_id, pid, name=display_name, content=content)
            subpage_ids[display_name] = pid
            print(f"  Atualizada subpagina: {display_name} ({pid})")
        else:
            created = create_subpage(
                token,
                workspace_id,
                doc_id,
                name=display_name,
                content=content,
                parent_page_id=root_id,
            )
            pid = str(created.get("id") or created.get("page_id") or "?")
            subpage_ids[display_name] = pid
            print(f"  Criada subpagina: {display_name} ({pid})")

    state_path.parent.mkdir(parents=True, exist_ok=True)
    state_path.write_text(
        json.dumps(
            {
                "doc_id": doc_id,
                "root_page_id": root_id,
                "subpage_ids": subpage_ids,
                "workspace_id": workspace_id,
            },
            indent=2,
            ensure_ascii=False,
        )
        + "\n",
        encoding="utf-8",
    )
    print(f"\nConcluido. Doc ID: {doc_id}")
    print(f"Estado salvo em: {state_path}")
    print(f"Abra no ClickUp: https://app.clickup.com/{workspace_id}/docs/{doc_id}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Publica README + docs/NN-*.md no ClickUp (skill project-context-doc)"
    )
    parser.add_argument(
        "--workspace",
        default=".",
        help="Raiz do projeto (contem README.md e docs/)",
    )
    parser.add_argument("--dry-run", action="store_true", help="Mostra plano sem chamar API")
    parser.add_argument("--doc-id", help="ID de Doc existente")
    parser.add_argument("--force", action="store_true", help="Cria Doc mesmo se nome duplicado")
    parser.add_argument(
        "--update-existing",
        action="store_true",
        help="Atualiza subpaginas existentes (match por nome)",
    )
    args = parser.parse_args()
    try:
        sync(args)
    except ClickUpError as exc:
        print(f"Erro: {exc}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
