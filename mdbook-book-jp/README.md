# mdbook-book-jp

日本語の mdBook 書籍向けの共通テーマです。

## 含まれるもの

- `theme/mdbook-book-core.css`
  - mdBook の共通レイアウト
- `theme/mdbook-book-jp.css`
  - 日本語書籍向けの余白・文字組み調整
- `bin/install.sh`
  - 既存の mdBook プロジェクトへテーマを導入するスクリプト

## 使い方

既存の mdBook プロジェクトのルートで実行します。

```bash
./bin/install.sh /path/to/your-book
```

スクリプトは次を行います。

- `theme/` に共通 CSS を配置
- `book.toml` の `additional-css` に `theme/mdbook-book-jp.css` を追加

## 方針

- 日本語の本文が読みやすいことを優先する
- 黒箱として使えることを優先し、利用側は CSS を触らなくてよい
- 共通レイアウト層と日本語特化層を分けて、他の書籍にも再利用しやすくする
