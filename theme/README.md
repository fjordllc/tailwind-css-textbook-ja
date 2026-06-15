# Theme Assets

`mdbook-book-core.css` は、mdBook 向けの共通 UI スタイルです。
`mdbook-book-jp.css` は、日本語書籍向けのタイポグラフィ調整を足した上書きです。

使い方:

1. 共通スタイルを `@import "./mdbook-book-core.css";` で読み込む
2. 日本語書籍向けなら `@import "./mdbook-book-jp.css";` を追加する
3. 各書籍の `theme/*.css` で色・余白・見出しサイズなどの変数を上書きする

このリポジトリでは `tailwind-css-textbook.css` が薄いラッパーになっています。
将来 `mdbook-book-jp` を別リポジトリとして配るときも、この 2 層をそのまま移せます。
