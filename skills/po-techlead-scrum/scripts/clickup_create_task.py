#!/usr/bin/env python3
"""
Cria uma task no ClickUp a partir de um markdown local (po-techlead-scrum).

Modos:
  esteira   — SuperAgente/Scrum → lista Esteira PBI e Tasks
              tipo Task padrao (sem custom_item_id), status PBI da lista,
              assignee Ricardo (default), campo Projeto
  imediatas — Direto pro dev → lista Tarefas IMEDIATAS
              tipo custom 0-IMEDIATA, assignee informado no onboard

Uso:
  python clickup_create_task.py --mode esteira --file task/cms-central-ajuda.md --dry-run
  python clickup_create_task.py --mode esteira --file task/cms-central-ajuda.md --project BATEU
  python clickup_create_task.py --mode imediatas --file task/x.md --assignee 72158089 \\
      --attach task/x.md

Credenciais: clickup.env nesta skill (ver clickup.env.example).
"""

from __future__ import annotations

import argparse
import json
import mimetypes
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Any

SKILL_DIR = Path(__file__).resolve().parent.parent
API_V2 = "https://api.clickup.com/api/v2"

H1_RE = re.compile(r"^#\s+(.+)$", re.MULTILINE)
EMOJI_PREFIX_RE = re.compile(r"^[\W_🔗📌🎯]+", re.UNICODE)


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


def build_payload(
    *,
    mode: str,
    title: str,
    markdown: str,
    assignee_ids: list[int],
    project_key: str | None,
) -> dict[str, Any]:
    payload: dict[str, Any] = {
        "name": title,
        "markdown_description": markdown,
        "assignees": assignee_ids,
    }

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
    parser.add_argument("--mode", choices=["esteira", "imediatas"], required=True)
    parser.add_argument("--file", required=True, help="Markdown da task local")
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
        help="Arquivo para anexar apos criar (pode repetir). Use o .md da task.",
    )
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    md_path = Path(args.file).resolve()
    if not md_path.is_file():
        raise SystemExit(f"Arquivo nao encontrado: {md_path}")
    markdown = md_path.read_text(encoding="utf-8")
    title = extract_title(markdown, args.title)
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
    )

    plan = {
        "mode": args.mode,
        "list_id": list_id,
        "title": title,
        "assignees": assignees,
        "project": args.project,
        "attachments": args.attach or [str(md_path)],
        "payload_preview": {
            k: v for k, v in payload.items() if k != "markdown_description"
        },
        "markdown_chars": len(markdown),
    }
    print(json.dumps(plan, ensure_ascii=False, indent=2))

    if args.dry_run:
        print("\nDRY-RUN — nada criado no ClickUp.")
        return

    created = api_request("POST", f"/list/{list_id}/task", data=payload)
    task_id = created.get("id")
    task_url = created.get("url")
    print(f"\nCreated task id={task_id}")
    print(f"URL: {task_url}")

    attach_paths = args.attach if args.attach else [str(md_path)]
    for ap in attach_paths:
        p = Path(ap).resolve()
        if not p.is_file():
            print(f"WARN skip missing attachment: {p}", file=sys.stderr)
            continue
        att = attach_file(task_id, p)
        print(f"Attached: {p.name} -> {att.get('id') or att.get('title') or 'ok'}")

    print(json.dumps({"id": task_id, "url": task_url}, ensure_ascii=False))


if __name__ == "__main__":
    main()
