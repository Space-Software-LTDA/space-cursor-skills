#!/usr/bin/env python3
"""
Descobre Project ID, moduleId e id da pasta de endpoints no Apidog pelo NOME (só leitura).

Usa o apidog-cli (npx -y apidog-cli@latest) com o token da conta (apidog.env).
Nenhum ID de produto fica gravado: tudo é buscado na hora.

Uso:
  python apidog_resolve_ids.py                                   # lista os projetos da conta
  python apidog_resolve_ids.py --project "Nome"                  # lista os módulos do projeto
  python apidog_resolve_ids.py --project "Nome" --module "Mod"   # lista as pastas de endpoints do módulo
  python apidog_resolve_ids.py --project "Nome" --module "Mod" --folder "KYC"   # ids prontos para o import

--project e --module aceitam nome (exato ou trecho, sem diferenciar maiúsculas) ou o id numérico.
--folder é o caminho da pasta como aparece no Apidog (ex.: "KYC" ou "KYC/Sessões").
Sem --folder, a última linha traz o id da pasta Root do módulo (raiz real, oculta na interface).

Saída: tabelas legíveis e, na última linha, um JSON com projectId / moduleId / folderId.
Código de saída 2 = nome ambíguo ou não encontrado (pergunte ao PO qual é).
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
CLI = ["npx", "-y", "apidog-cli@latest"]


def load_env_file(path: Path) -> None:
    if not path.is_file():
        return
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, val = line.split("=", 1)
        os.environ.setdefault(key.strip(), val.strip().strip('"').strip("'"))


def run_cli(args: list[str]) -> dict:
    """Roda o apidog-cli e devolve o JSON. A saída vai para arquivo (o pipe corta listas grandes)."""
    token = os.environ.get("APIDOG_ACCESS_TOKEN", "")
    if not token:
        raise SystemExit("Missing env APIDOG_ACCESS_TOKEN. Configure apidog.env (see apidog.env.example).")
    with tempfile.TemporaryFile(mode="w+", encoding="utf-8") as out:
        result = subprocess.run(
            CLI + args + ["--access-token", token],
            stdout=out,
            stderr=subprocess.PIPE,
            text=True,
            timeout=300,
            check=False,
        )
        out.seek(0)
        text = out.read()
    start = text.find("{")
    if result.returncode != 0 or start < 0:
        # stderr pode ter aviso do npm; nunca imprimir o token
        detail = (result.stderr or text).replace(token, "***")[-800:]
        raise SystemExit(f"apidog-cli falhou ({' '.join(args[:2])}): {detail}")
    data = json.loads(text[start:])
    if not data.get("success", True):
        raise SystemExit(f"apidog-cli devolveu erro: {json.dumps(data, ensure_ascii=False)[:800]}")
    return data


def as_list(data: dict) -> list[dict]:
    payload = data.get("data")
    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        return payload.get("list") or payload.get("items") or []
    return []


def pick(items: list[dict], wanted: str, label: str, key: str = "name") -> dict:
    """Acha um item por id, nome exato ou trecho do nome. Ambíguo/ausente → sai com código 2."""
    wanted = wanted.strip()
    if wanted.isdigit():
        hit = [i for i in items if str(i.get("id")) == wanted]
    else:
        low = wanted.lower()
        hit = [i for i in items if str(i.get(key, "")).strip().lower() == low]
        if not hit:
            hit = [i for i in items if low in str(i.get(key, "")).lower()]
    if len(hit) == 1:
        return hit[0]
    options = "\n".join(f"  {i.get('id')}  {i.get(key)}" for i in (hit or items))
    reason = "ambíguo" if hit else "não encontrado"
    print(f"{label} {reason}: '{wanted}'. Opções:\n{options}", file=sys.stderr)
    raise SystemExit(2)


def main() -> None:
    load_env_file(SKILL_DIR / "apidog.env")

    parser = argparse.ArgumentParser(description="Descobre projectId / moduleId / folderId no Apidog pelo nome.")
    parser.add_argument("--project", help="Nome (ou id) do projeto Apidog")
    parser.add_argument("--module", help="Nome (ou id) do módulo")
    parser.add_argument("--folder", help='Caminho da pasta de endpoints (ex.: "KYC" ou "KYC/Sessões")')
    args = parser.parse_args()

    projects = as_list(run_cli(["project", "list"]))
    if not args.project:
        for p in projects:
            print(f"{p.get('id')}  {p.get('name')}")
        return

    project = pick(projects, args.project, "Projeto")
    project_id = str(project["id"])

    modules = as_list(run_cli(["module", "list", "--project", project_id]))
    if not args.module:
        print(f"Projeto {project_id}  {project.get('name')}")
        for m in modules:
            print(f"  módulo {m.get('id')}  {m.get('name')}")
        return

    module = pick(modules, args.module, "Módulo")
    module_id = int(module["id"])

    folders = [
        f
        for f in as_list(run_cli(["folder", "list", "--project", project_id, "--type", "endpoint"]))
        if f.get("moduleId") == module_id
    ]
    print(f"Projeto {project_id}  {project.get('name')}  ·  módulo {module_id}  {module.get('name')}")
    for f in sorted(folders, key=lambda x: str(x.get("path"))):
        print(f"  pasta {f.get('id')}  {f.get('path')}")

    if args.folder:
        target = args.folder.strip().strip("/")
        exact = [f for f in folders if str(f.get("path", "")).lower() == target.lower()]
        if len(exact) != 1:
            print(
                f"Pasta '{target}' não existe no módulo. Para criar (mostre ao PO antes):\n"
                f"  apidog folder create --project {project_id} --type endpoint --module-id {module_id} "
                f'--name "{target.split("/")[-1]}"   (subpasta: parentId no --file)',
                file=sys.stderr,
            )
            raise SystemExit(2)
        folder = exact[0]
    else:
        roots = [f for f in folders if f.get("parentId") == 0 and str(f.get("name")) == "Root"]
        folder = roots[0] if roots else None

    print(
        json.dumps(
            {
                "projectId": int(project_id),
                "moduleId": module_id,
                "folderId": folder.get("id") if folder else None,
                "folderPath": folder.get("path") if folder else None,
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
