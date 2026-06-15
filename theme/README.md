# Theme Assets

`mdbook-book-core.css` は、mdBook 向けの共通 UI スタイルです。
`mdbook-book-jp.css` は、日本語書籍向けのタイポグラフィ調整を足した上書きです。

使い方:

1. 共通スタイルを `@import "./mdbook-book-core.css";` で読み込む
2. 日本語書籍向けなら `@import "./mdbook-book-jp.css";` を追加する
3. 各書籍の `theme/*.css` で色・余白・見出しサイズなどの変数を上書きする

このリポジトリでは `tailwind-css-textbook.css` が薄いラッパーになっています。

`mdbook-book-core.css` と `mdbook-book-jp.css` は、別リポジトリのテーマ
[mdbook-book-jp](https://github.com/machida/mdbook-book-jp) から `install.sh` で導入したコピーです。
直接編集せず（編集してもテーマ更新で上書きされます）、本書固有の調整はラッパー
`tailwind-css-textbook.css` に書いてください。テーマ自体の改善は mdbook-book-jp 側で行います。
