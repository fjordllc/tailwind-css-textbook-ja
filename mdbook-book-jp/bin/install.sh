#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 /path/to/mdbook-project" >&2
  exit 1
fi

target_dir="$1"
script_dir="$(cd "$(dirname "$0")/.." && pwd)"
book_toml="$target_dir/book.toml"

if [ ! -f "$book_toml" ]; then
  echo "book.toml not found: $book_toml" >&2
  exit 1
fi

mkdir -p "$target_dir/theme"
cp "$script_dir/theme/mdbook-book-core.css" "$target_dir/theme/"
cp "$script_dir/theme/mdbook-book-jp.css" "$target_dir/theme/"

python3 - "$book_toml" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
needle = "theme/mdbook-book-jp.css"
language_line = 'language = "ja"'

if language_line not in text:
    book_header = re.search(r'^\[book\]\s*$', text, re.M)
    if book_header:
        insert_at = book_header.end()
        text = text[:insert_at] + "\n" + language_line + text[insert_at:]
    else:
        text = text.rstrip() + '\n\n[book]\n' + language_line + '\n'

if needle in text:
    path.write_text(text, encoding="utf-8")
    sys.exit(0)

output_header = re.search(r'^\[output\.html\]\s*$', text, re.M)
additional = re.search(r'^\s*additional-css\s*=\s*\[(.*?)\]\s*$', text, re.M | re.S)

if additional:
    inner = additional.group(1).strip()
    if inner:
        new_inner = inner + ', ' + f'"{needle}"'
    else:
        new_inner = f'"{needle}"'
    text = text[:additional.start(1)] + new_inner + text[additional.end(1):]
elif output_header:
    insert_at = output_header.end()
    text = text[:insert_at] + '\nadditional-css = ["' + needle + '"]' + text[insert_at:]
else:
    text = text.rstrip() + '\n\n[output.html]\nadditional-css = ["' + needle + '"]\n'

path.write_text(text, encoding="utf-8")
PY

echo "Installed mdbook-book-jp into $target_dir"
