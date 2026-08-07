#!/usr/bin/env python3
"""
Valida tom pedagogico em docs/*.md antes do sync ClickUp.

Uso:
  python3 validate_pedagogy.py /path/projeto/docs/
  python3 validate_pedagogy.py /path/.docs/contexto-produto.md
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

RN_BLOCK_RE = re.compile(
    r"^### (RN-\d{3}):[^\n]*\n(.*?)(?=\n---|\n### RN-|\Z)",
    re.MULTILINE | re.DOTALL,
)
FL_BLOCK_RE = re.compile(
    r"^### (FL-\d{3}):[^\n]*\n(.*?)(?=\n---|\n### FL-|\Z)",
    re.MULTILINE | re.DOTALL,
)
G_BLOCK_RE = re.compile(
    r"^### (G-\d{3}):[^\n]*\n(.*?)(?=\n---|\n### G-|\Z)",
    re.MULTILINE | re.DOTALL,
)
RT_MODULE_RE = re.compile(
    r"^#### ([\w-]+ — Modulo .+)\n(.*?)(?=\n#### |\Z)",
    re.MULTILINE | re.DOTALL,
)
SENTENCE_RE = re.compile(r"[.!?]+(?:\s|$)")
ARROW_FRAGMENT_RE = re.compile(r"^[A-Za-z0-9_/`]+ → [A-Za-z0-9_/`]+$")


def count_sentences(text: str) -> int:
    text = text.strip()
    if not text:
        return 0
    return len(SENTENCE_RE.findall(text + " "))


def extract_field(block: str, label: str) -> str:
    m = re.search(
        rf"\*\*{re.escape(label)}\*\*(?:\s*—\s*|\s*\n)(.*?)(?=\n\*\*|\n#### |\n---|\Z)",
        block,
        re.DOTALL,
    )
    return m.group(1).strip() if m else ""


def extract_h4_section(block: str, title: str) -> str:
    m = re.search(
        rf"^#### {re.escape(title)}\s*\n(.*?)(?=\n#### |\n\*\*|\n\| |\n---|\Z)",
        block,
        re.MULTILINE | re.DOTALL,
    )
    return m.group(1).strip() if m else ""


def extract_bullets(block: str, after_label: str) -> list[str]:
    section = extract_field(block, after_label)
    if not section:
        # RN uses **O que o sistema faz** without dash
        m = re.search(
            rf"\*\*{re.escape(after_label)}\*\*\s*\n(.*?)(?=\n\*\*|\n---|\Z)",
            block,
            re.DOTALL,
        )
        section = m.group(1).strip() if m else ""
    bullets = []
    for line in section.splitlines():
        line = line.strip()
        if line.startswith("- "):
            bullets.append(line[2:].strip())
    return bullets


class Issue:
    def __init__(self, file: str, artifact: str, message: str) -> None:
        self.file = file
        self.artifact = artifact
        self.message = message


def validate_rn(path: Path, content: str) -> list[Issue]:
    issues: list[Issue] = []
    for m in RN_BLOCK_RE.finditer(content):
        rn_id = m.group(1)
        block = m.group(2)
        cenario = extract_field(block, "Cenario (caso de uso)")
        porque = extract_field(block, "Por que existe assim")
        exemplo = extract_field(block, "Exemplo concreto")
        bullets = extract_bullets(block, "O que o sistema faz")

        if count_sentences(cenario) < 4 and len(cenario) < 280:
            issues.append(
                Issue(str(path), rn_id, f"Cenario curto ({count_sentences(cenario)} frases, {len(cenario)} chars)")
            )
        if count_sentences(porque) < 2:
            issues.append(Issue(str(path), rn_id, "Por que existe assim com menos de 2 frases"))
        if len(exemplo) < 40:
            issues.append(Issue(str(path), rn_id, "Exemplo concreto ausente ou muito curto"))
        for b in bullets:
            if ARROW_FRAGMENT_RE.match(b):
                issues.append(Issue(str(path), rn_id, f"Bullet telegrafico (seta): {b[:60]}"))
            elif len(b.split()) < 5:
                issues.append(Issue(str(path), rn_id, f"Bullet muito curto: {b[:60]}"))
    return issues


def validate_fl(path: Path, content: str) -> list[Issue]:
    issues: list[Issue] = []
    for m in FL_BLOCK_RE.finditer(content):
        fl_id = m.group(1)
        block = m.group(2)
        porque = extract_h4_section(block, "Por que este fluxo importa")
        cenario = extract_h4_section(block, "Cenario")
        if not porque:
            porque = extract_field(block, "Por que este fluxo importa")
        if not cenario:
            cenario = extract_field(block, "Cenario")

        if count_sentences(porque) < 2:
            issues.append(Issue(str(path), fl_id, "Por que este fluxo importa com menos de 2 frases"))
        if count_sentences(cenario) < 4:
            issues.append(Issue(str(path), fl_id, f"Cenario com menos de 4 frases ({count_sentences(cenario)})"))
    return issues


def validate_g(path: Path, content: str) -> list[Issue]:
    issues: list[Issue] = []
    for m in G_BLOCK_RE.finditer(content):
        g_id = m.group(1)
        block = m.group(2)
        violacao = extract_field(block, "Cenario de violacao")
        if count_sentences(violacao) < 4 and len(violacao) < 200:
            issues.append(Issue(str(path), g_id, f"Cenario de violacao curto ({count_sentences(violacao)} frases)"))
    return issues


def validate_rt_modules(path: Path, content: str) -> list[Issue]:
    issues: list[Issue] = []
    for m in RT_MODULE_RE.finditer(content):
        title = m.group(1)
        body = m.group(2).strip()
        lines = body.splitlines()
        intro_lines: list[str] = []
        for line in lines:
            if line.strip().startswith("- "):
                break
            if line.strip():
                intro_lines.append(line.strip())
        intro = " ".join(intro_lines)
        if count_sentences(intro) < 2 and len(intro) < 120:
            issues.append(
                Issue(str(path), title, "Modulo RT sem paragrafo intro (min 2 frases)")
            )
    return issues


def validate_file(path: Path) -> list[Issue]:
    content = path.read_text(encoding="utf-8")
    issues: list[Issue] = []
    name = path.name
    if "regras" in name or "contexto" in name or name.endswith(".md") and "RN-" in content:
        issues.extend(validate_rn(path, content))
    if "fluxos" in name:
        issues.extend(validate_fl(path, content))
    if "guardrails" in name:
        issues.extend(validate_g(path, content))
    if "rotas" in name:
        issues.extend(validate_rt_modules(path, content))
    return issues


def main() -> int:
    parser = argparse.ArgumentParser(description="Valida tom pedagogico do contexto")
    parser.add_argument("path", type=Path, help="Arquivo .md ou diretorio docs/")
    args = parser.parse_args()
    target = args.path.resolve()
    files: list[Path] = []
    if target.is_dir():
        files = sorted(target.glob("*.md"))
    elif target.is_file():
        files = [target]
    else:
        print(f"Caminho nao encontrado: {target}", file=sys.stderr)
        return 2

    all_issues: list[Issue] = []
    for f in files:
        all_issues.extend(validate_file(f))

    if not all_issues:
        print(f"OK — {len(files)} arquivo(s) validado(s), sem violacoes pedagogicas.")
        return 0

    print(f"FALHA — {len(all_issues)} violacao(oes) pedagogica(s):\n")
    for i in all_issues:
        print(f"  [{i.artifact}] {Path(i.file).name}: {i.message}")
    return 1


if __name__ == "__main__":
    sys.exit(main())
