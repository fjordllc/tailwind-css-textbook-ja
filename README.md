# FBC Press: Tailwind CSS ― 仕組みと思想から理解する

このリポジトリは、**Tailwind CSS の日本語教科書**の原稿と、Web 書籍として読むための mdBook 設定を管理するものです。

本書は、プログラミングスクール **[FjordBootCamp（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/)** の教材として作成しています。

## このプロジェクトは何か

Tailwind CSS の「クラス一覧（リファレンス）」ではありません。次のことを読者が理解できる、**読み物としての教科書**を目指しています。

- Tailwind CSS が生まれた背景と、作者が解決したかった課題
- 「Utility First（ユーティリティファースト）」という設計思想
- Tailwind CSS が内部でどう動いているか（ビルドの仕組み）
- 環境構築と、Rails / React などフレームワークごとの使い方
- 実務での設計・運用、メリットとデメリット

つまり「このクラスを使うとこうなる」ではなく、**「なぜその仕組みなのか」「なぜその設計が選ばれたのか」**まで踏み込んで説明する本です。

- **対象バージョン:** Tailwind CSS v4 系（2026-06 時点の公式ドキュメントを基準）
- **言語・文体:** 日本語・です/ます調
- **想定読者:** HTML/CSS と Flexbox/Grid の基礎を習得済みで、Rails チュートリアル程度の開発経験がある初級エンジニア（React 基礎経験者を含む）

## ファイル構成

| ファイル / フォルダ | 役割 |
| --- | --- |
| [`book.toml`](./book.toml) | mdBook の設定。`manuscript/` を原稿ディレクトリとして、ブラウザ閲覧用 HTML を生成します。 |
| [`manuscript/SUMMARY.md`](./manuscript/SUMMARY.md) | mdBook 用の目次。部・章・付録を左ナビとして定義します。 |
| `manuscript/preface.md` | まえがき。対象読者・読み方・バージョン基準をまとめています。 |
| `manuscript/part*/index.md` | 各部の導入ページ。 |
| `manuscript/part*/chapter*.md` | 第1〜31章の本文。Web で読みやすいように章ごとに 1 ページへ分割しています。 |
| `manuscript/part*/exercises.md` | 各部末の演習。 |
| `manuscript/appendix/*.md` | 付録A〜F、おわりに。 |
| `manuscript/figures/*.svg` | 本文で使う図版。 |
| [`theme/`](./theme/) | mdBook の追加 CSS / JavaScript。日本語テーマ `mdbook-book-jp` と、本書固有の上書きを置きます。 |
| [`OUTLINE.md`](./OUTLINE.md) | 全31章＋付録の詳細目次。全体像や章の狙いを確認できます。 |
| [`STYLEGUIDE.md`](./STYLEGUIDE.md) | 用語の統一・表記・引用・コード例・Markdown 記法のルール。 |
| [`FIGURES.md`](./FIGURES.md) | 図版の内容・配置・alt テキストの仕様。 |
| [`FIGURE_STYLEGUIDE.md`](./FIGURE_STYLEGUIDE.md) | 図版の見た目を揃えるためのデザインルール。 |

## 本の全体構成（8部 31章）

1. **第1部 Tailwind CSS を理解する**（第1〜3章）— 歴史と設計思想
2. **第2部 Tailwind CSS の仕組み**（第4〜6章）— ビルド・テーマ・バリアント
3. **第3部 環境構築**（第7〜9章）— 導入とエディタ（Rails を重点的に）
4. **第4部 Utility Class を使う**（第10〜16章）— Spacing 〜 Grid
5. **第5部 実践的な Tailwind CSS**（第17〜21章）— レスポンシブ・ダークモード・アニメーション・フォーム・アクセシビリティ
6. **第6部 コンポーネント設計**（第22〜25章）— 再利用、Rails / React での設計
7. **第7部 実務での Tailwind CSS**（第26〜28章）— 構成・アンチパターン・批判と評価
8. **第8部 Tailwind CSS の未来**（第29〜31章）— v4・Utility First の未来・採用判断
9. **付録** — 公式ドキュメントの歩き方／よく使う Utility／チートシート／用語集／AI プロンプト集／ハンズオン（ゼロから動く最小例）
10. **各部末に演習**（やってみよう）を収録

詳細な各節の内容は [`OUTLINE.md`](./OUTLINE.md) を参照してください。

## ブラウザで読む

このリポジトリは、本文の Markdown をそのまま **mdBook** で Web 書籍として読める構成にしています。原稿は `manuscript/` に置き、mdBook の目次は `manuscript/SUMMARY.md` で管理します。

mdBook をインストール済みなら、次のコマンドでローカルプレビューできます。

```bash
mdbook serve
```

未インストールの場合は、Rust / Cargo 環境でインストールします。

```bash
cargo install mdbook
```

古い Rust toolchain を使っている場合は、対応する mdBook バージョンを指定してください。このリポジトリでは `mdbook v0.4.52` でビルド確認しています。

表示されたローカル URL をブラウザで開くと、左ナビ・検索・前後移動付きの書籍として読めます。本文は Web で読みやすいように**章ごとに 1 ページ**へ分割しています。各部の `index.md` は導入ページ、各章の `chapter*.md` は本文ページ、`exercises.md` は演習ページです。

## 編集する

本文を編集するときは、対応する `manuscript/part*/chapter*.md` を変更します。章や付録を増減するときは、あわせて `manuscript/SUMMARY.md` を更新してください。

執筆時の表記・文体・コード例・Markdown の注意点は [`STYLEGUIDE.md`](./STYLEGUIDE.md) にまとめています。特に、日本語文中で `**...**` を密着させると mdBook で強調に変換されないことがあるため、文中強調は必要に応じて `<strong>...</strong>` を使います。

図版を追加・修正するときは、`manuscript/figures/` に SVG を置き、本文から相対パスで参照します。図版の内容仕様は [`FIGURES.md`](./FIGURES.md)、見た目のルールは [`FIGURE_STYLEGUIDE.md`](./FIGURE_STYLEGUIDE.md) を参照してください。

## HTML を生成する

静的 HTML を生成する場合は次を実行します。

```bash
mdbook build
```

生成物は `/book/` に出力されます。これは配信用の成果物なので、リポジトリにはコミットしません（`.gitignore` で除外済み）。

この環境では `mdbook v0.4.52` でビルド確認済みです。

## 日本語テーマ（mdbook-book-jp）

本書の日本語向け CSS は、再利用できるように **別リポジトリのテーマ [mdbook-book-jp](https://github.com/machida/mdbook-book-jp)** として切り出しています。日本語の本文が読みやすいことを優先した、mdBook 用の共通テーマです。

- **共通レイアウト層**（`mdbook-book-core.css`）と **日本語タイポグラフィ層**（`mdbook-book-jp.css`）の 2 層構成です。
- このリポジトリの `theme/mdbook-book-core.css` / `theme/mdbook-book-jp.css` は、そのテーマから**導入したコピー**です。直接編集はせず、本書固有の調整は `theme/tailwind-css-textbook.css` に書きます。
- `book.toml` の `additional-css` は `mdbook-book-jp.css` と `tailwind-css-textbook.css` を読み込みます。テーマ本体は先に、書籍固有の上書きは後に適用されます。

テーマを導入・更新するときは、テーマ側リポジトリの導入スクリプトを使います。

```bash
# 例: テーマを取得して、このプロジェクトへ導入/更新する
git clone https://github.com/machida/mdbook-book-jp.git
./mdbook-book-jp/bin/install.sh /path/to/tailwind-css-textbook-ja
```

`install.sh` は `theme/` へ CSS を配置し、`book.toml` に `language = "ja"` と `additional-css` を追加します。テーマ自体の改善（共通レイアウトや日本語組版の調整）は mdbook-book-jp 側で行い、本書側では更新スクリプトで取り込みます。

テーマを更新する場合も同じスクリプトを再実行します。

```bash
./mdbook-book-jp/bin/update.sh /path/to/tailwind-css-textbook-ja
```

## FjordBootCamp について

本書は、プログラミングスクール **[FjordBootCamp（フィヨルドブートキャンプ）](https://bootcamp.fjord.jp/)** の教材として作成されました。

FjordBootCamp は、現役のソフトウェアエンジニアが運営する日本語のオンラインプログラミングスクールです。未経験からでも学べるカリキュラムで、**Rails エンジニアコース**（Ruby on Rails によるバックエンド／フロントエンド開発）と**フロントエンドエンジニアコース**（HTML / CSS / JavaScript・TypeScript）を提供しています。暗記ではなく「自分で考えて学び続ける力」を養うことを重視し、受講生は自分で設計・公開する成果物まで作り上げます。

本書が想定する読者（HTML/CSS と Flexbox/Grid の基礎があり、Rails チュートリアル程度の経験がある初級エンジニア）は、まさに FjordBootCamp が育てる学習者像と重なります。Tailwind CSS をこれから実務で使う人の土台づくりに役立ててください。

- 公式サイト: <https://bootcamp.fjord.jp/>

## ライセンス

Copyright (c) 2026 FjordBootCamp

このリポジトリの本文・原稿は [MIT License](./LICENSE) で公開します。著作権者は FjordBootCamp（[https://github.com/fjordllc](https://github.com/fjordllc)）です。

なお、`theme/mdbook-book-core.css` / `theme/mdbook-book-jp.css` は日本語テーマ [mdbook-book-jp](https://github.com/machida/mdbook-book-jp)（Copyright (c) 2026 machida, MIT License）から導入したもので、その著作権は machida に帰属します。

## 品質方針（執筆の約束ごと）

- **一次情報を最優先**します（公式ドキュメント・公式ブログ・GitHub・リリースノート・作者 Adam Wathan の発信）。第三者ブログは補助に留めます。
- **各章末に「参考資料」セクションを置き、URL を明記**します。掲載前に各 URL の実在を確認します。
- 各概念は **「Tailwind 以前はどうだったか → なぜ問題か → Tailwind はどう解決したか」** の流れで説明します。

詳しいルールは [`STYLEGUIDE.md`](./STYLEGUIDE.md) にあります。
