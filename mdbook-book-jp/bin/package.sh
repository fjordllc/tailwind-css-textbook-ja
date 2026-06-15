#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "$0")/.." && pwd)"
dist_dir="$root_dir/dist"
name="mdbook-book-jp"
version="${VERSION:-dev}"
archive="$dist_dir/${name}-${version}.tar.gz"

mkdir -p "$dist_dir"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

cp -R "$root_dir/README.md" "$tmpdir/"
cp -R "$root_dir/LICENSE" "$tmpdir/"
cp -R "$root_dir/bin" "$tmpdir/"
mkdir -p "$tmpdir/theme"
cp "$root_dir/theme/mdbook-book-core.css" "$tmpdir/theme/"
cp "$root_dir/theme/mdbook-book-jp.css" "$tmpdir/theme/"

tar -C "$tmpdir" -czf "$archive" .
echo "$archive"
