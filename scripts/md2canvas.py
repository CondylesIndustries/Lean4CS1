"""Convert SYLLABUS.md to a Canvas-safe HTML fragment.

Canvas's rich-text editor strips <style> and <script>, so every rule is inline.
Handles only the constructs SYLLABUS.md actually uses.
"""
import re, html, io, sys

TBL   = 'border-collapse:collapse;width:100%;margin:1em 0;font-size:0.92em;'
TH    = 'border:1px solid #c7cdd1;padding:6px 8px;background:#f5f5f5;text-align:left;vertical-align:top;'
TD    = 'border:1px solid #c7cdd1;padding:6px 8px;vertical-align:top;'
CODE  = 'background:#f5f5f5;padding:1px 4px;border-radius:3px;font-family:Menlo,Consolas,monospace;font-size:0.92em;'
PRE   = 'background:#f5f5f5;border:1px solid #dfe3e6;border-radius:4px;padding:10px 12px;overflow-x:auto;font-family:Menlo,Consolas,monospace;font-size:0.9em;'
QUOTE = 'border-left:4px solid #c7cdd1;margin:1em 0;padding:0.4em 1em;background:#fafafa;'
FILL  = 'background:#fff3b0;padding:1px 4px;border-radius:3px;'

def inline(t):
    """Inline markup. Order matters: protect code spans before anything else."""
    spans = []
    def stash(m):
        spans.append(m.group(1)); return '\x00%d\x00' % (len(spans) - 1)
    t = re.sub(r'`([^`]+)`', stash, t)

    # CommonMark backslash escapes: \* is a literal asterisk, not emphasis.
    # Park them as sentinels so nothing downstream reads them as markup.
    t = re.sub(r'\\([!-/:-@\[-`{-~])', lambda m: '\x04%d\x04' % ord(m.group(1)), t)

    keep_br = '<br>' in t
    t = t.replace('<br>', '\x01')
    t = re.sub(r'<(https?://[^>]+)>', lambda m: '\x02%s\x02' % m.group(1), t)
    t = re.sub(r'<(mailto:[^>]+|[^@<>\s]+@[^@<>\s]+)>', lambda m: '\x03%s\x03' % m.group(1), t)
    t = html.escape(t, quote=False)
    if keep_br:
        t = t.replace('\x01', '<br>')
    t = re.sub(r'\x02(.+?)\x02', r'<a href="\1">\1</a>', t)
    t = re.sub(r'\x03(.+?)\x03',
               lambda m: '<a href="mailto:%s">%s</a>' % (m.group(1).replace('mailto:', ''),
                                                         m.group(1).replace('mailto:', '')), t)
    # links, then emphasis
    t = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', t)
    t = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', t)
    t = re.sub(r'(?<!\*)\*([^*]+)\*(?!\*)', r'<em>\1</em>', t)

    def unstash(m):
        c = html.escape(spans[int(m.group(1))], quote=False)
        style = CODE
        return '<code style="%s">%s</code>' % (style, c)
    t = re.sub(r'\x00(\d+)\x00', unstash, t)
    return re.sub(r'\x04(\d+)\x04',
                  lambda m: html.escape(chr(int(m.group(1))), quote=False), t)

def cells(row):
    return [c.strip() for c in row.strip().strip('|').split('|')]

def convert(md):
    lines = md.split('\n')
    out, i = [], 0
    while i < len(lines):
        l = lines[i]

        if l.startswith('```'):                                  # code fence
            i += 1; buf = []
            while i < len(lines) and not lines[i].startswith('```'):
                buf.append(html.escape(lines[i], quote=False)); i += 1
            i += 1
            out.append('<pre style="%s">%s</pre>' % (PRE, '\n'.join(buf)))
            continue

        if re.match(r'^#{1,6} ', l):                             # heading
            n = len(l) - len(l.lstrip('#'))
            tag = 'h%d' % min(n + 1, 6)                          # H1 -> h2, Canvas owns the page title
            out.append('<%s>%s</%s>' % (tag, inline(l[n:].strip()), tag))
            i += 1; continue

        if l.strip() == '---':                                   # rule
            out.append('<hr>'); i += 1; continue

        if l.startswith('> '):                                   # blockquote
            buf = []
            while i < len(lines) and lines[i].startswith('>'):
                buf.append(lines[i].lstrip('>').strip()); i += 1
            out.append('<blockquote style="%s"><p>%s</p></blockquote>' % (QUOTE, inline(' '.join(buf))))
            continue

        if l.startswith('|'):                                    # table
            rows = []
            while i < len(lines) and lines[i].startswith('|'):
                rows.append(lines[i]); i += 1
            head = cells(rows[0])
            body = [cells(r) for r in rows[2:]]                  # rows[1] is the --- separator
            t = ['<table style="%s"><thead><tr>' % TBL]
            t += ['<th style="%s">%s</th>' % (TH, inline(c)) for c in head]
            t.append('</tr></thead><tbody>')
            for r in body:
                t.append('<tr>' + ''.join('<td style="%s">%s</td>' % (TD, inline(c)) for c in r) + '</tr>')
            t.append('</tbody></table>')
            out.append(''.join(t)); continue

        m = re.match(r'^(\s*)([-*]|\d+\.) ', l)                  # list
        if m:
            ordered = not m.group(2) in ('-', '*')
            tag = 'ol' if ordered else 'ul'
            items = []
            while i < len(lines):
                mm = re.match(r'^(\s*)([-*]|\d+\.) (.*)$', lines[i])
                if mm:
                    items.append(mm.group(3)); i += 1
                elif lines[i].startswith('  ') and lines[i].strip() and items:
                    items[-1] += ' ' + lines[i].strip(); i += 1   # wrapped continuation
                else:
                    break
            out.append('<%s>%s</%s>' % (tag, ''.join('<li>%s</li>' % inline(x) for x in items), tag))
            continue

        if not l.strip():
            i += 1; continue

        buf = []                                                 # paragraph
        while i < len(lines) and lines[i].strip() and not re.match(r'^(#{1,6} |[-*] |\d+\. |\||>|```|---$)', lines[i]):
            buf.append(lines[i].strip()); i += 1
        if buf:
            out.append('<p>%s</p>' % inline(' '.join(buf)))
    return '\n'.join(out)

if __name__ == '__main__':
    src = io.open(sys.argv[1], encoding='utf-8').read()
    io.open(sys.argv[2], 'w', encoding='utf-8').write(convert(src) + '\n')
    print('wrote', sys.argv[2])
