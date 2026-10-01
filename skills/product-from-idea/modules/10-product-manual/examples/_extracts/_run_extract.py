#!/usr/bin/env python3
"""One-off extraction script for product-manual anexos."""
import re
import subprocess
import sys
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent / "anexos"
OUT = Path(__file__).resolve().parent


def pdf_to_text_pypdf(path: Path) -> str:
    from pypdf import PdfReader

    reader = PdfReader(str(path))
    parts = []
    for i, page in enumerate(reader.pages):
        t = page.extract_text() or ""
        parts.append(f"\n--- Page {i + 1} ---\n{t}")
    return "\n".join(parts)


def pdf_airbnb():
    path = BASE / "airbnb-pitch-deck.pdf"
    out = OUT / "airbnb-pitch-deck.txt"
    # try pdftotext first
    try:
        r = subprocess.run(
            ["pdftotext", "-layout", str(path), "-"],
            capture_output=True,
            text=True,
            timeout=120,
        )
        if r.returncode == 0 and r.stdout.strip():
            out.write_text(r.stdout, encoding="utf-8")
            return
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    out.write_text(pdf_to_text_pypdf(path), encoding="utf-8")


def pdf_stripe_letter():
    path = BASE / "stripe-2021-update.pdf"
    out = OUT / "stripe-2021-update.txt"
    try:
        r = subprocess.run(
            ["pdftotext", "-layout", str(path), "-"],
            capture_output=True,
            text=True,
            timeout=180,
        )
        if r.returncode == 0 and r.stdout.strip():
            out.write_text(r.stdout, encoding="utf-8")
            return
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    out.write_text(pdf_to_text_pypdf(path), encoding="utf-8")


def pdf_shape_up():
    """TOC + Introduction + first 2-3 chapters, max ~80KB."""
    path = BASE / "shape-up.pdf"
    out = OUT / "shape-up-toc-and-intro.txt"
    full = pdf_to_text_pypdf(path)

    # Heuristic chapter markers (Shape Up book)
    markers = [
        r"\nIntroduction\b",
        r"\nChapter\s+1\b",
        r"\nChapter\s+2\b",
        r"\nChapter\s+3\b",
        r"\nChapter\s+4\b",
    ]
    # Always include from start through end of chapter 3 (or 4 if short)
    cut_at = len(full)
    m4 = re.search(markers[4], full, re.IGNORECASE)
    m3 = re.search(markers[3], full, re.IGNORECASE)
    if m4:
        cut_at = m4.start()
    elif m3:
        # include through ~70% after ch3 start if no ch4
        rest = full[m3.start() :]
        cut_at = m3.start() + min(len(rest), 50000)

    excerpt = full[:cut_at].strip()
    max_bytes = 80 * 1024
    if len(excerpt.encode("utf-8")) > max_bytes:
        excerpt = excerpt.encode("utf-8")[:max_bytes].decode("utf-8", errors="ignore")
        excerpt += "\n\n[... truncated at ~80KB ...]"

    header = (
        "EXTRACT: Table of Contents (if present in pages) + Introduction + "
        "first chapters from shape-up.pdf\n\n"
    )
    out.write_text(header + excerpt, encoding="utf-8")


def html_to_text(path: Path, max_bytes: int | None = None) -> str:
    from bs4 import BeautifulSoup

    raw = path.read_text(encoding="utf-8", errors="replace")
    soup = BeautifulSoup(raw, "lxml")

    for tag in soup(["script", "style", "noscript", "svg", "path"]):
        tag.decompose()

    lines: list[str] = []
    block_tags = {
        "h1",
        "h2",
        "h3",
        "h4",
        "h5",
        "h6",
        "p",
        "li",
        "blockquote",
        "figcaption",
        "dt",
        "dd",
    }

    def text_of(el) -> str:
        return " ".join(el.get_text(separator=" ", strip=True).split())

    for el in soup.find_all(True):
        name = el.name.lower() if el.name else ""
        if name in block_tags:
            t = text_of(el)
            if not t or len(t) < 2:
                continue
            if name.startswith("h"):
                level = int(name[1])
                lines.append("\n" + "#" * level + " " + t + "\n")
            else:
                lines.append(t + "\n")

    if not lines:
        body = soup.find("body") or soup
        t = text_of(body)
        lines = [t] if t else []

    text = "\n".join(lines)
    text = re.sub(r"\n{3,}", "\n\n", text).strip()

    if max_bytes and len(text.encode("utf-8")) > max_bytes:
        text = text.encode("utf-8")[:max_bytes].decode("utf-8", errors="ignore")
        text += "\n\n[... truncated ...]"

    return text


def html_apple():
    t = html_to_text(BASE / "apple-airpods-pro.html", 60 * 1024)
    (OUT / "apple-airpods-pro.txt").write_text(t, encoding="utf-8")


def html_stripe_payments():
    t = html_to_text(BASE / "stripe-payments.html", 40 * 1024)
    (OUT / "stripe-payments.txt").write_text(t, encoding="utf-8")


def html_linear_home():
    t = html_to_text(BASE / "linear-homepage.html", 40 * 1024)
    (OUT / "linear-homepage.txt").write_text(t, encoding="utf-8")


def html_linear_method():
    t = html_to_text(BASE / "linear-method-introduction.html", None)
    (OUT / "linear-method-introduction.txt").write_text(t, encoding="utf-8")


def html_notion():
    path = BASE / "notion-product.html"
    t = html_to_text(path, 60 * 1024)
    note = ""
    if len(t.strip()) < 200:
        note = (
            "NOTE: Page may be SPA — extracted HTML has very little visible text; "
            "content likely rendered client-side.\n\n"
        )
    (OUT / "notion-product.txt").write_text(note + t, encoding="utf-8")


def main():
    pdf_airbnb()
    pdf_stripe_letter()
    pdf_shape_up()
    html_apple()
    html_stripe_payments()
    html_linear_home()
    html_linear_method()
    html_notion()
    print("done")


if __name__ == "__main__":
    main()
