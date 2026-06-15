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

既存の mdBook プロジェクトのルートで実行します。たとえば、あなたの本が
`~/dev/my-cookbook` にあるなら、そのディレクトリで導入します。

```bash
cd ~/dev/my-cookbook
./bin/install.sh .
```

パスを直接書く場合は、次のようにもできます。

```bash
./bin/install.sh ~/dev/my-cookbook
```

導入後は、`book.toml` に次の設定が入ります。

- `language = "ja"`
- `additional-css = ["theme/mdbook-book-jp.css"]`

また、`theme/` には次の 2 ファイルが置かれます。

- `theme/mdbook-book-core.css`
- `theme/mdbook-book-jp.css`

配布物を作る場合は、このリポジトリのルートで次を実行します。

```bash
./bin/package.sh
```

たとえば `VERSION=0.1.0` を付けると、`dist/mdbook-book-jp-0.1.0.tar.gz`
ができます。

```bash
VERSION=0.1.0 ./bin/package.sh
```

スクリプトは次を行います。

- `book.toml` に `language = "ja"` を追加
- `theme/` に共通 CSS を配置
- `book.toml` の `additional-css` に `theme/mdbook-book-jp.css` を追加

## 方針

- 日本語の本文が読みやすいことを優先する
- ブラックボックスとして使えることを優先し、利用側は CSS を触らなくてよい
- 共通レイアウト層と日本語特化層を分けて、他の書籍にも再利用しやすくする
