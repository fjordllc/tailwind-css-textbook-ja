# Theme Assets

`mdbook-book-core.css` は、mdBook 向けの共通 UI スタイルです。
`mdbook-book-jp.css` は、日本語書籍向けのタイポグラフィ調整を足した上書きです。

使い方:

1. `book.toml` の `additional-css` で `theme/mdbook-book-jp.css` を先に読み込む
2. 本書固有の `theme/*.css` で色・余白・見出しサイズなどの変数を上書きする
3. `tailwind-css-textbook.css` のような書籍固有 CSS には、テーマ本体ではなくその書籍だけの差分を書く

このリポジトリでは `tailwind-css-textbook.css` が書籍固有の上書きになっています。

`mdbook-book-core.css` と `mdbook-book-jp.css` は、別リポジトリのテーマ
[mdbook-book-jp](https://github.com/machida/mdbook-book-jp) から `install.sh` で導入したコピーです。
直接編集せず（編集してもテーマ更新で上書きされます）、テーマ自体の改善は mdbook-book-jp 側で行います。
