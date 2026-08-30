#!/usr/bin/env python3
"""
Importa um OpenAPI (YAML/JSON) no projeto Apidog (merge).

Project ID e moduleId são SEMPRE passados na linha de comando (produto atual).
Não lê IDs de produto do env — só o token da conta.

Uso:
  python apidog_import_openapi.py --file spec.yaml --project-id {ID} --module-id {ID}
  python apidog_import_openapi.py --file spec.yaml --project-id {ID} --module-id {ID} --dry-run

Credenciais: apidog.env (APIDOG_ACCESS_TOKEN). Doc: https://openapi.apidog.io/
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent

ASK = (
    "Faltou {what}. Pergunte ao PO: Project ID (Settings → Basic) e "
    "moduleId (módulo). Não invente. Não reuse ID de outro produto. "
    "Não grave esses IDs no .env do pack."
)


def load_env_file(path: Path) -> None:
    if not path.is_file():
        return
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, val = line.split("=", 1)
        os.environ.setdefault(key.strip(), val.strip().strip('"').strip("'"))


def env(name: str, default: str | None = None) -> str:
    val = os.environ.get(name, default)
    if val is None or val == "":
        raise SystemExit(f"Missing env {name}. Configure apidog.env (see apidog.env.example).")
    return val


def spec_as_string(path: Path) -> str:
    text = path.read_text(encoding="utf-8")
    if path.suffix.lower() in {".yaml", ".yml"}:
        try:
            import yaml  # type: ignore
        except ImportError:
            raise SystemExit("PyYAML ausente. pip install pyyaml  (ou passe um .json)")
        spec = yaml.safe_load(text)
        return json.dumps(spec, ensure_ascii=False)
    json.loads(text)
    return text


def main() -> None:
    load_env_file(SKILL_DIR / "apidog.env")

    parser = argparse.ArgumentParser(
        description="Import OpenAPI into Apidog (AUTO_MERGE). Exige --project-id e --module-id."
    )
    parser.add_argument("--file", required=True, type=Path)
    parser.add_argument("--project-id", dest="project_id", required=True)
    parser.add_argument("--module-id", dest="module_id", required=True)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    spec_path = args.file.expanduser().resolve()
    if not spec_path.is_file():
        raise SystemExit(f"Arquivo não encontrado: {spec_path}")

    project_id = (args.project_id or "").strip()
    module_id = (args.module_id or "").strip()
    missing: list[str] = []
    if not project_id:
        missing.append("projectId")
    if not module_id:
        missing.append("moduleId")
    if missing:
        raise SystemExit(ASK.format(what=" e ".join(missing)))

    options: dict = {
        "endpointOverwriteBehavior": "AUTO_MERGE",
        "schemaOverwriteBehavior": "AUTO_MERGE",
        "updateFolderOfChangedEndpoint": True,
        "prependBasePath": False,
        "deleteUnmatchedResources": False,
        "moduleId": int(module_id),
    }

    payload = {"input": spec_as_string(spec_path), "options": options}

    if args.dry_run:
        print(
            f"dry-run project={project_id} module={module_id} "
            f"file={spec_path.name} bytes={len(payload['input'])}"
        )
        print("options:", json.dumps(options))
        return

    token = env("APIDOG_ACCESS_TOKEN")
    base = os.environ.get("APIDOG_API_BASE", "https://api.apidog.com").rstrip("/")
    version = os.environ.get("APIDOG_API_VERSION", "2024-03-28")
    url = f"{base}/v1/projects/{project_id}/import-openapi"
    body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=body,
        method="POST",
        headers={
            "Authorization": f"Bearer {token}",
            "X-Apidog-Api-Version": version,
            "Accept": "application/json",
            "Content-Type": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            print(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as exc:
        err = exc.read().decode("utf-8", errors="replace")
        raise SystemExit(f"HTTP {exc.code}: {err}") from exc


if __name__ == "__main__":
    main()
    sys.exit(0)
