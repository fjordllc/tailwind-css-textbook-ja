# 執筆スタイル・用語統一方針

全章でこのルールに従います。表記の揺れは読者の負担になるため、ここを唯一の基準とします。

## 1. バージョン前提

- 本文は **Tailwind CSS v4 系**を前提に書きます。
- v3 以前にしか存在しない挙動・記法に触れるときは、必ず **「v3 までは〜」「過去のバージョンでは〜」** と明記します。
- v4 の代表的な変更点（執筆の基準）:
  - 新エンジン（Oxide / Rust 製、Lightning CSS 採用）
  - **CSS ファースト設定**（`tailwind.config.js` を必須としない。`@theme` で設定）
  - `@import "tailwindcss";` 一行で読み込み
  - 自動コンテンツ検出（`content` 配列の手動指定が不要に）
  - テーマ変数がそのまま CSS 変数として公開される
  - First-party Vite プラグイン `@tailwindcss/vite`
  - Container Queries・3D transform などをコアに内蔵

## 2. 文体

- です/ます調。1 文を短く。1 段落 1 トピック。
- 初学者がつまずく語は初出時に必ず補足する（例: 「ユーティリティクラス（単一の役割だけを持つ小さなクラス）」）。
- 「なぜ」を必ず添える。機能の列挙で終わらせない。
- 各概念は **「Tailwind 以前はどうだったか → なぜ問題か → Tailwind はどう解決したか」** の順で説明する。

## 3. 用語の統一表記

| 採用する表記 | 使わない／揺らさない |
| --- | --- |
| ユーティリティクラス | utilityクラス、ユーティリティ・クラス |
| Utility First（思想を指すとき）／ユーティリティファースト | utility-first（文中の和文では避ける） |
| クラス名 | クラス・ネーム |
| ディレクティブ（`@theme` など `@` で始まる命令） | 命令、アットルール（CSS の `@` 規則一般を指すときのみ「アットルール」可） |
| バリアント（`hover:` `md:` など） | 修飾子（modifier の訳としては「修飾子」を併記してよい） |
| 任意の値（arbitrary value、`bg-[#316ff6]` など） | アービトラリーバリュー |
| テーマ変数（theme variable） | テーマトークン（design token は「デザイントークン」） |
| ビルド | コンパイル（CSS 生成を指すときは「ビルド」に統一） |
| 設定ファイル | コンフィグ |

- 製品名は **Tailwind CSS**（初出）→ 以降 **Tailwind** 可。
- 人名は **Adam Wathan**（アダム・ウェイサン）。初出のみ読みを併記。
- 関連プロダクト表記: **Headless UI** / **Heroicons** / **Catalyst** / **Tailwind UI**（現 Tailwind Plus）。

## 4. コード例のルール

- 言語ラベルを必ず付ける（```html / ```css / ```js / ```ts / ```jsx / ```tsx / ```erb / ```ruby / ```bash / ```vue / ```svelte / ```astro）。React/Next.js/Vite の設定や型付きコンポーネントは `ts` / `tsx` を使う。
- 1 つの概念につき、原則として **(1) Tailwind のコード → (2) 出力 HTML（必要時）→ (3) 生成 CSS（仕組みの説明で必要なときのみ）** を示す。
- 生成 CSS を示すときは「実際の出力は簡略化しています」と注記してよい。
- HTML の `class` 属性が長くなる例は折り返して読みやすくする。
- ファイル名が重要なときはコードブロック直前に `app/views/...erb` のように示す。

## 5. 参考資料セクション

- **各章末に必ず `## 参考資料` を置く。**
- URL を必ず明記する。一次情報（公式 docs / 公式 Blog / GitHub / リリースノート / Adam Wathan の発信）を優先し、第三者ブログは補助に留める。
- 掲載前に **WebFetch で URL の実在を確認**する（リンク切れ・移転を防ぐ）。
- v4 で URL 構造が変わった項目に注意（例: `tailwindcss.com/docs/<utility>` 形式）。

## 6. 確認済みの基準 URL（全章で再利用）

- [ユーティリティファースト](https://tailwindcss.com/docs/styling-with-utility-classes)
- [テーマ](https://tailwindcss.com/docs/theme)
- [v4.0 リリース告知](https://tailwindcss.com/blog/tailwindcss-v4)
- [公式ドキュメント](https://tailwindcss.com/docs)
- [GitHub](https://github.com/tailwindlabs/tailwindcss)
