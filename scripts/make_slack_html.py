#!/usr/bin/env python3
"""Render the Slack text as HTML for rich-text copy-paste.

Slack applies formatting to a paste only when the clipboard advertises text/html,
which it does when you copy from a rendered page.  Pasting the .txt gives literal
asterisks unless the reader has "Format messages with markup" switched on; copying
from this page gives real bold and real links, with no setting to change.

Generated from lean4-fall-2026.slack.txt so the two cannot drift.
Regenerate with `make slack`.
"""
import html
import pathlib
import re

SRC = pathlib.Path("lean4-fall-2026.slack.txt")
DST = pathlib.Path("src/lean4-fall-2026-slack.html")
BASE = "https://kevinsullivan.github.io/Lean4CS1/lean4-fall-2026-sources.html"


def linkify(s):
    s = html.escape(s)
    s = re.sub(r'\[(\d+)\]', lambda m: f'<a href="{BASE}#s{m.group(1)}">[{m.group(1)}]</a>', s)
    s = re.sub(r'(?<!")(https://\S+)', r'<a href="\1">\1</a>', s)
    return s


def main():
    lines = SRC.read_text(encoding="utf-8").splitlines()
    body, buf = [], []

    def flush():
        if buf:
            body.append("<ul>\n" + "\n".join(f"  <li>{b}</li>" for b in buf) + "\n</ul>")
            buf.clear()

    for i, line in enumerate(lines):
        if not line.strip():
            continue
        if line.startswith("• "):
            buf.append(linkify(line[2:]))
        elif i == 0:
            flush(); body.append(f"<h1>{html.escape(line)}</h1>")
        elif line.endswith(":") and not line.startswith("http"):
            flush(); body.append(f"<p><strong>{html.escape(line)}</strong></p>")
        else:
            flush(); body.append(f"<p>{linkify(line)}</p>")
    flush()

    DST.write_text(
        '<!DOCTYPE html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        "<title>Lean 4, Fall 2026 — Slack copy</title>\n<style>\n"
        "  body { margin: 0; background: #fff; color: #16181f;\n"
        "    font-family: system-ui, -apple-system, 'Segoe UI', sans-serif; line-height: 1.5; }\n"
        "  main { max-width: 46rem; margin: 0 auto; padding: 2rem 1.25rem 4rem; }\n"
        "  h1 { font-size: 1.5rem; margin: 0 0 .25rem; }\n"
        "  .hint { background: #eef1f8; border-left: 3px solid #3547a8; padding: .75rem 1rem;\n"
        "    font-size: .88rem; margin: 0 0 1.75rem; }\n"
        "  ul { padding-left: 1.2rem; } li { margin-bottom: .5rem; }\n"
        "  a { color: #3547a8; }\n</style>\n</head>\n<body>\n<main>\n"
        '<p class="hint">Select all of the text below this box, copy, and paste into Slack. '
        "Because you are copying from a rendered page, Slack keeps the bold headings and the "
        "clickable source numbers. Do not use paste-as-plain-text.</p>\n"
        + "\n".join(body)
        + "\n</main>\n</body>\n</html>\n", encoding="utf-8")
    n = len(re.findall(r'#s\d+', DST.read_text()))
    print(f"  wrote {DST} — {n} clickable source references")


if __name__ == "__main__":
    main()
