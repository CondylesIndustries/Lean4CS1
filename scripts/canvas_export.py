#!/usr/bin/env python3
"""Generate the Canvas-pasteable exports from SYLLABUS.md.

Canvas's rich-text editor strips <style> and <script>, so md2canvas emits a
fragment whose every rule is an inline attribute. Two files are written:

  canvas-syllabus.html   the whole syllabus
  canvas-schedule.html   the Schedule section on its own

Paste either into Canvas's HTML view (the </> button at the editor's lower
right), or open it in a browser and copy the rendered page into the visual
editor.
"""
import io, os, re, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from md2canvas import convert, CODE

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'SYLLABUS.md')

# Bracketed spans are notes to the instructor, not content for students.
STUB = re.compile(r'<code style="%s">\[[^<]*\]</code>' % re.escape(CODE))
TBA = '<em style="color:#6b7280;">To be announced.</em>'


def student_facing(html):
    html = STUB.sub(TBA, html)
    return html.replace('<p>%s</p>\n' % TBA, '')      # a paragraph that was only a stub


def write(path, html):
    io.open(path, 'w', encoding='utf-8').write(html.rstrip('\n') + '\n')
    print('  %-24s %6d bytes' % (os.path.basename(path), len(html)))


def main():
    md = io.open(SRC, encoding='utf-8').read()
    write(os.path.join(ROOT, 'canvas-syllabus.html'), student_facing(convert(md)))

    m = re.search(r'(## Schedule \(.*?)\n---\n', md, re.S)
    if m is None:
        sys.exit('canvas_export: no Schedule section found in SYLLABUS.md')
    write(os.path.join(ROOT, 'canvas-schedule.html'), student_facing(convert(m.group(1).rstrip())))


if __name__ == '__main__':
    main()
