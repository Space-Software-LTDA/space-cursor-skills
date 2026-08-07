"""
Utilitarios genericos para montagem de documentacao multipagina (project-context-doc).

Reutilizavel por scripts de build locais do projeto (ex.: .docs/build_contexto_*.py).
Conteudo de produto (FL/RN/G, TB catalog, Tier 1 expandido) permanece no projeto.
"""

from __future__ import annotations

import base64
import json
import re
from pathlib import Path
from typing import Any, Protocol, Sequence

RouteTuple = tuple[str, str, str, str, str, str]

DEFAULT_SUBPAGES: list[tuple[str, str, str]] = [
    ("01-contexto.md", "contexto", "Contexto, mapa e glossario"),
    ("02-fluxos.md", "fluxos", "Fluxos end-to-end (FL)"),
    ("03-regras.md", "regras", "Regras de negocio (RN)"),
    ("04-guardrails.md", "guardrails", "Guardrails (G)"),
    ("05-banco-dados.md", "banco", "Banco de dados (TB)"),
    ("06-rotas.md", "rotas", "Catalogo de rotas (RT)"),
    ("07-dominios.md", "dominios", "Auth, tenant, INT, WH, ENV, setup"),
    ("08-apendice.md", "apendice", "Apendice — indices, DBML, RT Tier 1"),
]

REPO_ORDER = ("core", "integration", "front", "dashboard")

DEFAULT_RT_REPO_THRESHOLDS: tuple[tuple[str, int], ...] = (
    ("core", 115),
    ("integration", 146),
    ("front", 224),
    ("dashboard", 99999),
)

HTTP_METHODS = frozenset({"GET", "POST", "PUT", "DELETE", "PATCH", "PAGE"})

ROUTE_BULLET_RE = re.compile(
    r'^-\s+(?:<a id="rt-\d{3}"></a>)?'
    r'\[(RT-\d{3})\]\(#rt-\d{3}\)\s+'
    r'(GET|POST|PUT|DELETE|PATCH|PAGE)\s+'
    r'(?:`([^`]+)`|(\S+))'
    r'(?:\s+`([^`]*)`)?'
    r'(?:\s+—\s+(.+))?$'
)

ROUTE_ARTIFACT_RE = re.compile(
    r"^\|\s*(RT-\d{3})\s*\|\s*(GET|POST|PUT|DELETE|PATCH|PAGE)\s*`?([^`|]+?)`?\s*\|"
)

REPO_MODULE_HEADING_RE = re.compile(
    r"^#### `(?P<repo>[\w-]+)` — Modulo "
)


class TableDocLike(Protocol):
    tb_id: str
    table_name: str
    repo: str
    para_que: str
    por_que_existe: str
    columns: list[Any]
    json_keys: list[tuple[str, list[Any]]]
    ver_tambem: str


def mermaid_url(code: str) -> str:
    enc = base64.urlsafe_b64encode(code.encode("utf-8")).decode("ascii").rstrip("=")
    return f"https://mermaid.ink/img/{enc}?type=png&bgColor=!white"


def link_ref(text: str) -> str:
    """Converte refs RN-008, FL-001, G-001, RT-071, TB-002 em links markdown."""
    if not text or text.strip() in ("—", "-", ""):
        return text

    parts = re.split(r"(\s*,\s*|\s+·\s+|\s+)", text)
    out: list[str] = []
    for part in parts:
        if re.fullmatch(r"[A-Z]{2}-\d{3}", part.strip()):
            p, n = part.split("-")
            out.append(f"[{part}](#{p.lower()}-{n})")
        elif re.fullmatch(r"TB-\d{3}", part.strip()):
            p, n = part.split("-")
            out.append(f"[{part} player](#{p.lower()}-{n})")
        else:
            out.append(part)
    return "".join(out)


def link_fluxo_cell(value: str) -> str:
    value = value.strip()
    if not value:
        return ""
    if value.startswith("["):
        return value
    m = re.fullmatch(r"(FL-\d{3})", value)
    if m:
        fl = m.group(1)
        return f"[{fl}](#{fl.lower()})"
    return link_ref(value)


def add_tb_anchors(tail: str) -> str:
    def repl(m: re.Match[str]) -> str:
        tb_id = m.group(1).lower()
        return f'<a id="{tb_id}"></a>\n#### {m.group(1)}: {m.group(2)}'

    return re.sub(r"(?m)^#### (TB-\d+): (.+)$", repl, tail)


def add_rt_tier2_anchors(tail: str) -> str:
    def repl(m: re.Match[str]) -> str:
        rt_id = m.group(1)
        anchor = rt_id.lower()
        rest = m.group(2)
        return f'| <a id="{anchor}"></a>[{rt_id}](#{anchor}) |{rest}'

    return re.sub(r"^\| (RT-\d{3}) \|(.*)$", repl, tail, flags=re.MULTILINE)


def add_rt_repo_section_anchors(tail: str) -> str:
    """Insere anchor rt-{repo} antes de headings ### `repo` — N rotas/paginas."""

    def repl(m: re.Match[str]) -> str:
        line = m.group(0)
        repo_match = re.search(r"`([\w-]+)`", line)
        if not repo_match:
            return line
        repo = repo_match.group(1)
        anchor = f"rt-{repo}"
        prefix = tail[: m.start()]
        if f'id="{anchor}"' in prefix.split("\n")[-3:]:
            return line
        return f'<a id="{anchor}"></a>\n{line}'

    return re.sub(r"^### `[\w-]+` — .+$", repl, tail, flags=re.MULTILINE)


def fix_rt_tier2_fluxo(tail: str, *, section_marker: str = "## 🛣️ Catalogo de Rotas") -> str:
    rt_start = tail.find(section_marker)
    if rt_start == -1:
        return tail

    before = tail[:rt_start]
    rt_section = tail[rt_start:]
    lines = rt_section.splitlines()
    out: list[str] = []
    in_table = False
    header_cols: list[str] = []

    for line in lines:
        if line.strip().startswith("|") and "Fluxo" in line and "---" not in line:
            in_table = True
            header_cols = [c.strip() for c in line.strip().strip("|").split("|")]
            out.append(line)
            continue
        if in_table and line.strip().startswith("|") and "---" in line:
            out.append(line)
            continue
        if in_table and line.strip().startswith("|"):
            cols = [c.strip() for c in line.strip().strip("|").split("|")]
            if "Fluxo" in header_cols:
                idx = header_cols.index("Fluxo")
                if idx < len(cols):
                    cols[idx] = link_fluxo_cell(cols[idx])
            out.append("| " + " | ".join(cols) + " |")
            continue
        if in_table and not line.strip().startswith("|"):
            in_table = False
            header_cols = []
        out.append(line)

    return before + "\n".join(out)


def dedupe_tier1_before_core_table(
    tail: str,
    *,
    tier1_marker: str = "### Tier 1 — Rotas criticas",
    core_heading_pattern: str = r"^### `core` — \d+ rotas",
) -> str:
    core_match = re.search(core_heading_pattern, tail, flags=re.MULTILINE)
    if not core_match:
        return tail
    core_idx = core_match.start()
    tier1_idx = tail.find(tier1_marker)
    if tier1_idx == -1 or tier1_idx > core_idx:
        return tail
    prefix = tail[:tier1_idx].rstrip()
    suffix = tail[core_idx:]
    return prefix + "\n\n---\n\n\n" + suffix


def infer_repo_from_rt(
    rt_id: str,
    thresholds: Sequence[tuple[str, int]] | None = None,
) -> str:
    n = int(rt_id.split("-")[1])
    bounds = thresholds or DEFAULT_RT_REPO_THRESHOLDS
    for repo, upper in bounds:
        if n <= upper:
            return repo
    return bounds[-1][0]


def parse_routes_for_index(tail: str) -> list[RouteTuple]:
    items: list[RouteTuple] = []
    current_repo = "core"
    for line in tail.splitlines():
        stripped = line.strip()
        repo_match = re.match(r"^### `([\w-]+)` —", stripped)
        if repo_match:
            current_repo = repo_match.group(1)
            continue
        if not stripped.startswith("|") or "---" in stripped:
            continue
        if stripped.startswith("| RT") and "Path" in stripped:
            continue
        cols = [c.strip() for c in stripped.strip("|").split("|")]
        if len(cols) < 4:
            continue
        rt_match = re.search(r"(RT-\d{3})", cols[0])
        if not rt_match:
            continue
        rt_id = rt_match.group(1)
        if current_repo in ("front", "dashboard"):
            method, path, para_que = "PAGE", cols[1].strip("`"), cols[2]
            fluxo = cols[4] if len(cols) > 4 else ""
        else:
            if len(cols) < 5:
                continue
            method, path, para_que = cols[1], cols[2].strip("`"), cols[3]
            fluxo = cols[5] if len(cols) > 5 else (
                cols[4] if len(cols) > 4 and cols[4].startswith("[FL") else ""
            )
        items.append((rt_id, method, path, para_que, current_repo, fluxo))
    return items


def parse_routes_from_grouped_index(
    content: str,
    *,
    repo_thresholds: Sequence[tuple[str, int]] | None = None,
) -> list[RouteTuple]:
    items: list[RouteTuple] = []
    current_repo = "core"
    in_rt_index = False
    for line in content.splitlines():
        stripped = line.strip()
        if stripped.startswith("### Indice RT ("):
            in_rt_index = True
            continue
        if in_rt_index and stripped.startswith("### ") and not stripped.startswith("#### "):
            in_rt_index = False
        if stripped.startswith("### Tier 2 — Referencia por modulo"):
            in_rt_index = True
            continue
        if in_rt_index and stripped == "---":
            in_rt_index = False
        repo_match = REPO_MODULE_HEADING_RE.match(stripped)
        if not repo_match:
            repo_match = re.match(r"^#### (?P<repo>[\w-]+) — Modulo ", stripped)
        if repo_match:
            current_repo = repo_match.group("repo")
            continue
        m = ROUTE_BULLET_RE.match(stripped)
        if not m:
            continue
        rt_id = m.group(1)
        method = m.group(2)
        path = (m.group(3) or m.group(4) or "").strip()
        para_que = (m.group(5) or "").strip()
        fluxo = (m.group(6) or "").strip()
        if not path:
            continue
        if not para_que and fluxo and not fluxo.startswith("["):
            para_que, fluxo = fluxo, ""
        repo = current_repo if in_rt_index else infer_repo_from_rt(rt_id, repo_thresholds)
        items.append((rt_id, method, path, para_que, repo, fluxo))
    return items


def parse_routes_from_artifact_table(
    content: str,
    *,
    repo_thresholds: Sequence[tuple[str, int]] | None = None,
) -> list[RouteTuple]:
    items: list[RouteTuple] = []
    for line in content.splitlines():
        m = ROUTE_ARTIFACT_RE.match(line.strip())
        if not m:
            continue
        rt_id, method, path = m.group(1), m.group(2), m.group(3).strip()
        repo = infer_repo_from_rt(rt_id, repo_thresholds)
        items.append((rt_id, method, path, "", repo, ""))
    return items


def dedupe_routes(items: list[RouteTuple]) -> list[RouteTuple]:
    def score(item: RouteTuple) -> int:
        _, _, _, para_que, _, fluxo = item
        return (4 if fluxo else 0) + (2 if para_que else 0)

    best: dict[str, RouteTuple] = {}
    for item in items:
        rt_id = item[0]
        if rt_id not in best or score(item) > score(best[rt_id]):
            best[rt_id] = item
    return sorted(best.values(), key=lambda x: int(x[0].split("-")[1]))


def normalize_route_tuple(item: RouteTuple) -> RouteTuple:
    rt_id, method, path, para_que, repo, fluxo = item
    method = (method or "").strip()
    path = (path or "").strip().strip("`")
    para_que = (para_que or "").strip()
    fluxo = (fluxo or "").strip()

    if method and method.split()[0] in HTTP_METHODS:
        bits = method.split(None, 1)
        if len(bits) == 2 and (bits[1].startswith("/") or bits[1].startswith("(")):
            method = bits[0]
            merged_path = bits[1]
            if path and "/" not in path and not path.startswith("("):
                if para_que.startswith("[") and not fluxo:
                    fluxo = para_que
                if not para_que or para_que.startswith("["):
                    para_que = path
                path = merged_path
            else:
                path = merged_path

    if fluxo.startswith("["):
        fl_m = re.search(r"(FL-\d{3})", fluxo)
        if fl_m:
            fluxo = fl_m.group(1)

    return (rt_id, method, path, para_que, repo, fluxo)


def normalize_routes_catalog(items: list[RouteTuple]) -> list[RouteTuple]:
    return [normalize_route_tuple(item) for item in items]


def load_routes_catalog(
    content: str,
    routes_tail: str,
    *,
    catalog_path: Path | None = None,
    repo_thresholds: Sequence[tuple[str, int]] | None = None,
    persist_min: int = 100,
) -> list[RouteTuple]:
    kwargs = {"repo_thresholds": repo_thresholds}
    candidates = [
        parse_routes_for_index(routes_tail),
        parse_routes_from_grouped_index(content, **kwargs),
        parse_routes_from_artifact_table(content, **kwargs),
    ]
    if catalog_path and catalog_path.is_file():
        raw = json.loads(catalog_path.read_text(encoding="utf-8"))
        candidates.append([tuple(row) for row in raw])
    merged = dedupe_routes([item for group in candidates for item in group])
    merged = normalize_routes_catalog(merged)
    if catalog_path and len(merged) >= persist_min:
        catalog_path.write_text(
            json.dumps([list(row) for row in merged], ensure_ascii=False, indent=2),
            encoding="utf-8",
        )
    return merged


def route_module(path: str, repo: str) -> str:
    clean = path.strip("`").strip("/")
    if not clean:
        return "root"
    parts = clean.split("/")
    if repo in ("front", "dashboard"):
        return parts[0]
    if parts[0] == "dashboards" and len(parts) >= 2:
        return f"{parts[0]}/{parts[1]}"
    return parts[0]


def group_routes_by_module(
    items: list[RouteTuple],
) -> dict[str, dict[str, list[RouteTuple]]]:
    grouped: dict[str, dict[str, list[RouteTuple]]] = {}
    for item in items:
        repo = item[4]
        module = route_module(item[2], repo)
        grouped.setdefault(repo, {}).setdefault(module, []).append(item)
    for repo in grouped:
        for module in grouped[repo]:
            grouped[repo][module].sort(key=lambda x: int(x[0].split("-")[1]))
    return grouped


def md_table(headers: list[str], rows: list[list[str]]) -> str:
    lines = [
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join("---" for _ in headers) + " |",
    ]
    for row in rows:
        lines.append("| " + " | ".join(row) + " |")
    return "\n".join(lines)


def render_tb_section(table: TableDocLike) -> str:
    anchor = table.tb_id.lower()
    rows = [
        [
            f"`{c.name}`" + (" *(virtual)*" if getattr(c, "virtual", False) else ""),
            c.para_que,
            c.por_que,
        ]
        for c in table.columns
    ]
    parts = [
        f'<a id="{anchor}"></a>',
        f"#### {table.tb_id}: `{table.table_name}`",
        "",
        f"**Repo:** `{table.repo}`",
        "",
        f"**Para que:** {table.para_que}",
        f"**Por que existe:** {table.por_que_existe}",
        "",
        md_table(["Coluna", "Para que", "Por que"], rows),
    ]
    for parent, keys in table.json_keys:
        key_rows = [[f"`{k.key}`", k.para_que, k.por_que] for k in keys]
        parts.extend(
            [
                "",
                f"**Chaves JSON `{parent}`:**",
                "",
                md_table(["Chave JSON", "Para que", "Por que"], key_rows),
            ]
        )
    if table.ver_tambem:
        parts.extend(["", f"**Ver tambem:** {table.ver_tambem}"])
    return "\n".join(parts)


def dbml_type(col: str, virtual: bool) -> str:
    if virtual:
        return "varchar"
    lower = col.lower()
    if lower.endswith("id") or lower in ("linkid",):
        return "uuid" if "application" in lower or "player" in lower or lower == "id" else "varchar"
    if lower in ("config", "webhooks", "plugins", "data", "options", "payload", "targetquery", "strategy", "prices"):
        return "json"
    if lower.startswith("is") or lower in (
        "ftd", "home", "signup", "login", "app", "website", "featured", "ispro", "isplan",
        "isenabled", "isactive", "isprocessed", "sendnotification", "ispaid", "firstdeposit",
    ):
        return "boolean"
    if lower in ("balance", "amount", "grossamount", "feeamount", "netamount", "amountbrl", "amounttoken", "rate", "value", "meta"):
        return "decimal"
    if lower in ("logincount", "accesscount", "networkid", "authid", "index", "position", "depositsnapshotcount"):
        return "int"
    if lower.endswith("at") or lower.endswith("date"):
        return "timestamp"
    if lower in ("qrcode", "copypaste", "content", "body", "description", "url", "iframevideo"):
        return "text"
    return "varchar"


def generate_dbml_block(repo: str, product_name: str, tables: list[TableDocLike]) -> str:
    lines = [
        f"// Repo: {repo}",
        f"// Produto: {product_name}",
        "// Gerado por project-context-doc",
        "",
        f"Project {repo.replace('-', '_')} {{",
        "  database_type: 'PostgreSQL'",
        "}",
        "",
    ]
    refs: list[str] = []
    for table in tables:
        note_para = table.para_que.replace("'", "\\'")
        note_porque = table.por_que_existe.replace("'", "\\'")
        lines.append(f"Table {table.table_name} {{")
        for col in table.columns:
            if getattr(col, "virtual", False):
                continue
            dtype = dbml_type(col.name, getattr(col, "virtual", False))
            note = f"Para que: {col.para_que}. Por que: {col.por_que}".replace("'", "\\'")
            extras = ""
            if col.name == "id":
                extras = " [pk"
            elif col.name in ("domain", "linkId"):
                extras = " [unique"
            if extras:
                lines.append(f"  {col.name} {dtype}{extras}, note: '{note}']")
            else:
                lines.append(f"  {col.name} {dtype} [note: '{note}']")
        lines.append(f"  Note: '''Para que: {note_para}. Por que existe: {note_porque}'''")
        lines.append("}")
        lines.append("")
        if table.table_name == "player":
            refs.extend(["Ref: deposit.playerId > player.id", "Ref: withdrawal.player_id > player.id"])
        if table.table_name == "application":
            refs.append("Ref: player.applicationId > application.id")
        if table.table_name == "payment_link":
            refs.extend(["Ref: payment_link.playerId > player.id", "Ref: payment_link.planId > plan.id"])
        if table.table_name == "players" and repo == "integration":
            refs.append("Ref: players.casinoId > casinos.id")
    for ref in refs:
        lines.append(ref)
    return "\n".join(lines)


def render_grouped_sections(
    sections: list[tuple[str, list[str], str | None] | tuple[str, list[str]]],
) -> str:
    parts: list[str] = []
    for entry in sections:
        if len(entry) == 3:
            heading, bullets, intro = entry
        else:
            heading, bullets = entry  # type: ignore[misc]
            intro = None
        if not bullets:
            continue
        block = heading
        if intro:
            block += f"\n{intro}"
        block += "\n\n" + "\n".join(bullets)
        parts.append(block)
    return "\n\n".join(parts)


def module_has_crud(routes: list[RouteTuple]) -> bool:
    methods = {r[1] for r in routes}
    return bool({"GET", "POST"}.issubset(methods) and ({"PUT", "DELETE"} & methods or len(routes) >= 4))


def build_module_intro(
    repo: str,
    module: str,
    routes: list[RouteTuple],
    module_intros: dict[tuple[str, str], str] | None = None,
) -> str:
    key = (repo, module)
    if module_intros and key in module_intros:
        return module_intros[key]
    fl_links = sorted({r[5] for r in routes if r[5] and re.match(r"FL-\d{3}", r[5])})
    if module_has_crud(routes):
        base = (
            f"Conjunto **CRUD** do recurso `{module}` no `{repo}` — listagem, criacao, atualizacao "
            f"e remocao conforme permissoes do modulo."
        )
    else:
        base = (
            f"Rotas agrupadas pelo segmento `{module}` no `{repo}` — referencia rapida; "
            f"narrativa completa nos fluxos FL relacionados."
        )
    if fl_links:
        links = " · ".join(f"[{f}](#{f.lower()})" for f in fl_links[:4])
        base += f" Ver: {links}."
    base += f" ({len(routes)} rota(s) neste grupo.)"
    return base


def format_route_line(item: RouteTuple, *, with_anchor: bool = True) -> str:
    rt_id, method, path, _, _, fluxo = item
    slug = rt_id.lower()
    fluxo_part = f" — {fluxo}" if fluxo.strip() else ""
    anchor_tag = f'<a id="{slug}"></a>' if with_anchor else ""
    return f"- {anchor_tag}[{rt_id}](#{slug}) {method} `{path}`{fluxo_part}"


def build_rt_index_sections(
    grouped: dict[str, dict[str, list[RouteTuple]]],
    *,
    heading_prefix: str = "",
    with_anchors: bool = True,
    repo_order: Sequence[str] = REPO_ORDER,
    module_intros: dict[tuple[str, str], str] | None = None,
) -> list[tuple[str, list[str], str]]:
    sections: list[tuple[str, list[str], str]] = []
    for repo in repo_order:
        modules = grouped.get(repo, {})
        if not modules:
            continue
        for module in sorted(modules.keys()):
            routes = modules[module]
            title = f"{heading_prefix}{repo} — Modulo {module}".strip()
            heading = f"#### {title}"
            bullets = [format_route_line(item, with_anchor=with_anchors) for item in routes]
            intro = build_module_intro(repo, module, routes, module_intros)
            sections.append((heading, bullets, intro))
    return sections


def render_grouped_index(
    *,
    anchor: str | None,
    title: str | None,
    sections: list[tuple[str, list[str]]],
) -> str:
    lines: list[str] = []
    if anchor and title:
        lines.extend([f'<a id="{anchor}"></a>', f"#### Indice deste modulo — {title}", ""])
    elif title:
        lines.extend([f"### {title}", ""])
    body = render_grouped_sections(sections)
    if lines:
        return "\n".join(lines) + "\n\n" + body if body else "\n".join(lines)
    return body


def render_grouped_routes(
    grouped: dict[str, dict[str, list[RouteTuple]]],
    heading_prefix: str = "",
    *,
    with_anchors: bool = True,
    repo_order: Sequence[str] = REPO_ORDER,
    module_intros: dict[tuple[str, str], str] | None = None,
) -> str:
    sections = build_rt_index_sections(
        grouped,
        heading_prefix=heading_prefix,
        with_anchors=with_anchors,
        repo_order=repo_order,
        module_intros=module_intros,
    )
    return render_grouped_sections(sections)


def build_tb_index_sections(
    tables: Sequence[TableDocLike],
    *,
    repo_order: Sequence[str] = REPO_ORDER,
    repo_dirs: dict[str, str] | None = None,
) -> list[tuple[str, list[str]]]:
    grouped: dict[str, list[tuple[str, str]]] = {}
    for table in tables:
        grouped.setdefault(table.repo, []).append((table.tb_id, table.table_name))
    sections: list[tuple[str, list[str]]] = []
    dirs = repo_dirs or {}
    for repo in repo_order:
        items = grouped.get(repo, [])
        if not items:
            continue
        folder = dirs.get(repo, repo)
        tb_range = f"{items[0][0]}–{items[-1][0]}"
        heading = f"##### `{repo}` — {folder} ({tb_range})"
        bullets = [f"- [{fid} `{name}`](#{fid.lower()})" for fid, name in items]
        sections.append((heading, bullets))
    return sections


def target_page_for_anchor(
    anchor: str,
    subpages: Sequence[tuple[str, str, str]] = DEFAULT_SUBPAGES,
) -> str:
    a = anchor.lower()
    if a in ("referencia-rapida", "indice", "como-ler"):
        return "hub"
    if a in (
        "contexto", "erros-classicos", "por-que-n-repos", "referencias-apidog",
        "mapa-do-sistema", "glossario",
    ):
        return "contexto"
    if a.startswith("fl-") or a in ("fluxos-end-to-end", "indice-fluxos"):
        return "fluxos"
    if a.startswith("rn-") or a == "indice-regras" or a == "regras-de-negocio":
        return "regras"
    if a.startswith("g-") or a == "indice-guardrails" or a == "guardrails":
        return "guardrails"
    if a.startswith("tb-") or a in ("banco-de-dados", "indice-tb"):
        return "banco"
    if a.startswith("rt-") or a.startswith("indice-rotas") or a in (
        "catalogo-de-rotas", "indice-rotas-corpo", "rt-core", "rt-integration", "rt-front", "rt-dashboard",
    ):
        return "rotas"
    if a in ("apendice", "dbml-core", "dbml-integration", "rt-tier-1-expandido", "tier-1-rotas"):
        return "apendice"
    if a in (
        "autenticacao", "multi-tenant", "integracoes", "setup-rapido",
        "ambientes", "decisoes-arquiteturais", "referencia-por-repo",
    ) or a.startswith("int-") or a.startswith("da-") or a.startswith("wh-"):
        return "dominios"
    return "hub"


def page_label_for_slug(
    slug: str,
    subpages: Sequence[tuple[str, str, str]] = DEFAULT_SUBPAGES,
) -> str:
    if slug == "hub":
        return "Indice"
    for fname, page_slug, _ in subpages:
        if page_slug == slug:
            order = fname[:2]
            name = fname[3:-3].replace("-", " ").title()
            return f"{order} {name}"
    return slug


def relative_link(
    from_slug: str,
    target_slug: str,
    subpages: Sequence[tuple[str, str, str]] = DEFAULT_SUBPAGES,
) -> str:
    if target_slug == "hub":
        return "README.md" if from_slug == "hub" else "../README.md"
    for fname, page_slug, _ in subpages:
        if page_slug == target_slug:
            if from_slug == "hub":
                return f"docs/{fname}"
            return fname
    return "README.md" if from_slug == "hub" else "../README.md"


def rewrite_cross_page_links(
    content: str,
    current_slug: str,
    subpages: Sequence[tuple[str, str, str]] = DEFAULT_SUBPAGES,
) -> str:
    def repl(m: re.Match[str]) -> str:
        text, anchor = m.group(1), m.group(2).lower()
        target = target_page_for_anchor(anchor, subpages)
        if target == current_slug:
            return m.group(0)
        path = relative_link(current_slug, target, subpages)
        page_label = page_label_for_slug(target, subpages)
        label = text if page_label in text else f"{text} · {page_label}"
        return f"[{label}]({path}#{anchor})"

    return re.sub(r"\[([^\]]+)\]\(#([^)]+)\)", repl, content)


def page_nav(
    current_slug: str,
    subpages: Sequence[tuple[str, str, str]] = DEFAULT_SUBPAGES,
) -> str:
    slugs = [s for _, s, _ in subpages]
    idx = slugs.index(current_slug)
    parts: list[str] = []
    if idx > 0:
        prev_f = relative_link(current_slug, slugs[idx - 1], subpages)
        parts.append(f"[← {subpages[idx - 1][2]}]({prev_f})")
    parts.append(f"[Indice principal]({relative_link(current_slug, 'hub', subpages)})")
    if idx < len(slugs) - 1:
        nxt_f = relative_link(current_slug, slugs[idx + 1], subpages)
        parts.append(f"[{subpages[idx + 1][2]} →]({nxt_f})")
    return "\n\n---\n\n\n**Navegacao:** " + " · ".join(parts)


def write_multipage_docs(
    hub_body: str,
    pages: dict[str, str],
    *,
    docs_dir: Path,
    readme_path: Path,
    subpages: Sequence[tuple[str, str, str]] = DEFAULT_SUBPAGES,
) -> None:
    docs_dir.mkdir(parents=True, exist_ok=True)
    readme_path.write_text(rewrite_cross_page_links(hub_body, "hub", subpages), encoding="utf-8")
    for fname, slug, title in subpages:
        body = pages.get(slug, "")
        if not body.strip():
            continue
        body = rewrite_cross_page_links(body, slug, subpages)
        header = f"> Subpagina **{title}** — [`docs/{fname}`](docs/{fname})\n\n"
        footer = page_nav(slug, subpages)
        (docs_dir / fname).write_text(header + body + footer, encoding="utf-8")


def extract_routes_tail(content: str, *, marker: str = "## 🛣️ Catalogo de Rotas") -> str:
    idx = content.find(marker)
    if idx == -1:
        raise ValueError(f"Marcador '{marker}' nao encontrado")
    return content[idx:].lstrip("\n")


def extract_post_routes_sections(
    content: str,
    *,
    auth_marker: str = "## 🔐 Autenticacao",
) -> str:
    idx = content.find(auth_marker)
    if idx == -1:
        raise ValueError(f"Marcador '{auth_marker}' nao encontrado")
    tail = content[idx:].lstrip("\n")
    cut_at: list[int] = []
    for ap_marker in ("## 📎 Apendice", '<a id="apendice"></a>'):
        ap_idx = tail.find(ap_marker)
        if ap_idx != -1:
            cut_at.append(ap_idx)
    if cut_at:
        tail = tail[: min(cut_at)].rstrip()
    revisao_idx = tail.find("## Revisao pendente")
    if revisao_idx != -1:
        tail = tail[:revisao_idx].rstrip()
    tail = re.sub(
        r"(?:\n---\s*)+(?:\n*<a id=\"apendice\"></a>\s*)*$",
        "",
        tail,
    ).rstrip()
    return tail


def split_revisao_pendente(tail: str) -> tuple[str, str]:
    marker = "## Revisao pendente"
    idx = tail.find(marker)
    if idx == -1:
        return tail, ""
    return tail[:idx].rstrip(), tail[idx:].lstrip()
