# Tailwind CSS 教科書（執筆プロジェクト）

このリポジトリは、**Tailwind CSS の日本語の教科書を書くためのプロジェクト**です。完成した本のソース原稿と、それを書くための設計資料（目次・執筆ルール）が入っています。

## このプロジェクトは何か

Tailwind CSS の「クラス一覧（リファレンス）」ではありません。次のことを読者が理解できる、**読み物としての教科書**を目指しています。

- Tailwind CSS が生まれた背景と、作者が解決したかった課題
- 「Utility First（ユーティリティファースト）」という設計思想
- Tailwind CSS が内部でどう動いているか（ビルドの仕組み）
- 環境構築と、Rails / React などフレームワークごとの使い方
- 実務での設計・運用、メリットとデメリット

つまり「このクラスを使うとこうなる」ではなく、**「なぜその仕組みなのか」「なぜその設計が選ばれたのか」**まで踏み込んで説明する本です。

- **対象バージョン:** Tailwind CSS v4 系（最新安定版。執筆時点で公式ドキュメントは v4.3、v4.0 は 2025-01-22 リリース）
- **言語・文体:** 日本語・です/ます調
- **想定読者:** HTML/CSS と Flexbox/Grid の基礎を習得済みで、Rails チュートリアル程度の開発経験がある初級エンジニア（React 基礎経験者を含む）

## 現在の状況

✅ **初稿完成。全31章＋付録（A〜F）・各部演習を執筆し、部ごとの品質レビュー・全体の最終レビューを反映済み。**

完了した工程は次のとおりです。

1. ✅ 全31章＋付録の詳細な目次（`OUTLINE.md`）と執筆ルール（`STYLEGUIDE.md`）を作成・構成レビュー反映済み
2. ✅ 第1〜8部（全31章）を執筆し、**部ごとの品質レビューを反映済み**（`manuscript/part*/chapter*.md`）
3. ✅ 付録A〜F・各部末の演習を執筆（`manuscript/appendix/*.md` ほか）
4. ✅ 機械チェック（URL リンク切れ／用語揺れ／章・参照番号／目次と本文の差分）をすべて通過
5. ✅ 全体の最終レビュー（重複／章間の流れ／読み物としての完成度）を反映済み — 詳細は [`REVIEW_NOTES.md`](./REVIEW_NOTES.md)
6. ✅ mdBook でブラウザ閲覧できる最小構成を追加（`book.toml`, `manuscript/SUMMARY.md`）

### 今後の改善候補（初稿のブロッカーではない）

- **図版の追加**: 優先度が高いのは ①テンプレート走査→生成 CSS、②`@theme`→CSS 変数＋ユーティリティ生成、③コンポーネント抽出 vs `@apply` の 3 点。加えて、初学者の読みやすさを上げる図（余白の3種 padding/margin/gap、Flexbox の2軸、spacing スケール など）も `FIGURES.md` に整理済み。作図方針・媒体サイズの検討を伴うため、別タスク（別 Issue／別コミット）として扱う。作図の仕様は [`FIGURES.md`](./FIGURES.md) にまとめてある。

## ファイル構成

| ファイル / フォルダ | 役割 | 状態 |
| --- | --- | --- |
| [`OUTLINE.md`](./OUTLINE.md) | **全31章＋付録の詳細目次（節レベル）。** まずここを読むと全体像が分かります。 | ✅ 作成済み |
| [`STYLEGUIDE.md`](./STYLEGUIDE.md) | 用語の統一・表記・引用・コード例の書き方ルール。全章で守ります。 | ✅ 作成済み |
| [`book.toml`](./book.toml) | mdBook の設定。`manuscript/` を原稿ディレクトリとしてブラウザ閲覧用 HTML を生成します。 | ✅ 作成済み |
| [`theme/tailwind-css-textbook.css`](./theme/tailwind-css-textbook.css) | mdBook の追加 CSS。`mdbook-book-core.css` と `mdbook-book-jp.css` を組み合わせる薄いラッパーです。 | ✅ 作成済み |
| [`theme/mdbook-book-core.css`](./theme/mdbook-book-core.css) / [`theme/mdbook-book-jp.css`](./theme/mdbook-book-jp.css) | 再利用しやすい共通レイアウト層と、日本語向けタイポグラフィ層。将来的に `mdbook-book-jp` として別リポジトリ化しやすい構成にしています。 | ✅ 作成済み |
| [`manuscript/SUMMARY.md`](./manuscript/SUMMARY.md) | mdBook 用の目次。部・章・付録をブラウザ書籍の左ナビとして定義します。 | ✅ 作成済み |
| `manuscript/part*/index.md` | 各部の導入ページ。 | ✅ 執筆済み |
| `manuscript/part*/chapter*.md` | 第1〜31章の本文。Web で読みやすいように章ごとに 1 ページへ分割しています。 | ✅ 執筆済み |
| `manuscript/part*/exercises.md` | 各部末の演習。 | ✅ 執筆済み |
| `manuscript/appendix/*.md` | 付録A〜F（docs の歩き方／よく使う Utility／チートシート／用語集／AI プロンプト集／ゼロから動かすハンズオン）と参考資料。 | ✅ 執筆済み |

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

## ブラウザで読む（mdBook）

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

静的 HTML を生成する場合は次を実行します。

```bash
mdbook build
```

生成物は `/book/` に出力されます。これは配信用の成果物なので、リポジトリにはコミットしません（`.gitignore` で除外済み）。

この環境では `mdbook v0.4.52` でビルド確認済みです。

## ライセンス

Copyright (c) 2026 FjordBootCamp

このリポジトリの内容は [MIT License](./LICENSE) で公開します。

## 品質方針（執筆の約束ごと）

- **一次情報を最優先**します（公式ドキュメント・公式ブログ・GitHub・リリースノート・作者 Adam Wathan の発信）。第三者ブログは補助に留めます。
- **各章末に「参考資料」セクションを置き、URL を明記**します。掲載前に各 URL の実在を確認します。
- 各概念は **「Tailwind 以前はどうだったか → なぜ問題か → Tailwind はどう解決したか」** の流れで説明します。

詳しいルールは [`STYLEGUIDE.md`](./STYLEGUIDE.md) にあります。
