# FBC Press: Tailwind CSS ― 仕組みと思想から理解する 詳細目次（節レベル）

各章は「ねらい」→「節構成」→「主な参考資料（候補）」で示します。参考 URL は執筆時に実在確認のうえ各章末へ掲載します。記号の凡例: ◎=一次情報の核、○=補助。

---

# 第1部 Tailwind CSS を理解する

## 第1章 CSS の歴史と Tailwind CSS
**ねらい:** CSS が抱えてきた「スケールしない」問題を歴史で追い、Tailwind が登場した文脈を理解する。

- 1.1 CSS は何を解決するために生まれたのか（構造と見た目の分離という理想）
- 1.2 「関心の分離」の理想と現実 — HTML と CSS は本当に分離できたのか
- 1.3 CSS が大規模化で壊れる理由（グローバルスコープ・詳細度・カスケード）
- 1.4 命名規則による戦い — OOCSS / SMACSS / BEM の登場と限界
- 1.5 CSS-in-JS とコンポーネント志向の波（styled-components 等）
- 1.6 「CSS を書かない」という発想の系譜（Atomic CSS / Tachyons / Basscss）
- 1.7 この歴史の上に Tailwind CSS がどう位置づくか
- ◎ MDN CSS 入門 / ○ BEM 公式 / ◎ Adam Wathan "CSS Utility Classes and Separation of Concerns"

## 第2章 Tailwind CSS 誕生の背景
**ねらい:** 作者 Adam Wathan が何に困り、何を作ろうとしたのかを一次情報で追う。

- 2.1 Adam Wathan とは何者か（Refactoring UI / Tailwind Labs）
- 2.2 きっかけとなったブログ記事「Separation of Concerns」再読
- 2.3 自作 CSS から生まれた最初の Tailwind（2017 年の公開）
- 2.4 「ユーティリティの自作」から「フレームワーク化」への転換点
- 2.5 JIT エンジン以前の課題（巨大な生成 CSS と PurgeCSS）
- 2.6 v1 → v2 → v3（JIT 標準化）→ v4（新エンジン）の流れ
- 2.7 ビジネスとしての Tailwind（Tailwind UI / Plus・OSS と収益の両立）
- ◎ Tailwind Blog（各メジャー版告知）/ ◎ Adam Wathan の記事・カンファレンス登壇

## 第3章 Tailwind CSS の設計思想
**ねらい:** Utility First の思想を、メリットだけでなく批判への反論まで含めて腹落ちさせる。

- 3.1 Utility First とは何か（単一責務クラスの合成でデザインする）
- 3.2 なぜインラインスタイルではダメなのか（制約・状態・レスポンシブ）
- 3.3 「制約のあるデザイン」がもたらす一貫性（デザインシステムとの接続）
- 3.4 関心の分離の再定義 — 分けるべきは HTML と CSS ではない
- 3.5 命名からの解放（クラス名を考えないコスト削減）
- 3.6 CSS が線形に増えない理由
- 3.7 「醜い HTML」問題への作者の回答
- 3.8 Utility First が向く場面・向かない場面の見取り図
- ◎ docs: Styling with Utility Classes / ◎ Adam Wathan の思想記事

---

# 第2部 Tailwind CSS の仕組み

## 第4章 Tailwind CSS はどう動くのか
**ねらい:** 「魔法」ではなくビルドの仕組みとして理解する。v4 の新エンジンを中心に。

- 4.1 全体像 — テンプレート走査 → 必要なクラスのみ CSS 生成
- 4.2 JIT（Just-In-Time）の考え方（v3 で標準化）
- 4.3 v4 の新エンジン（Oxide / Rust・Lightning CSS）と高速化
- 4.4 自動コンテンツ検出（v4）と `@source`／旧 `content` 配列の違い
- 4.5 `@import "tailwindcss"` が展開するもの（theme / base / components / utilities レイヤー）
- 4.6 CSS Cascade Layers（`@layer`）と詳細度の制御
- 4.7 任意の値（arbitrary value）が動的に解決される仕組み
- 4.8 スタイル衝突の解決（後勝ち・`!` important・prefix）
- 4.9 生成 CSS を実際に覗いてみる
- ◎ v4.0 Blog / ◎ docs: Detecting classes in source files / ◎ docs: Styling with Utility Classes

## 第5章 テーマシステム
**ねらい:** v4 の `@theme` と CSS 変数を中心に、デザイントークンの実体を理解する。

- 5.1 テーマとは何か（デザイントークンの一元管理）
- 5.2 `@theme` ディレクティブの基本（v4）
- 5.3 テーマ変数が「CSS 変数 ＋ ユーティリティ生成」を兼ねる仕組み
- 5.4 名前空間（`--color-*` `--spacing-*` `--breakpoint-*` `--font-*` …）と生成されるクラスの対応
- 5.5 拡張・上書き・リセット（`--*: initial`）
- 5.6 v3 の `tailwind.config.js`（`theme.extend`）との対応関係と移行
- 5.7 spacing スケールと `--spacing` の動的計算（v4）
- 5.8 色: oklch ベースの新パレットと P3
- 5.9 実行時に CSS 変数を使う（`var(--color-...)`・JS からの参照）
- ◎ docs: Theme / ◎ v4.0 Blog（CSS-first config・theme variables）

## 第6章 バリアントの仕組み
**ねらい:** `hover:` `md:` `dark:` などが「セレクタ生成のルール」であることを理解する。

- 6.1 バリアントとは（条件付きでスタイルを適用するプレフィックス）
- 6.2 状態系: `hover` `focus` `active` `disabled` `focus-visible` ほか
- 6.3 構造系: `first` `last` `odd` `even` `only` `empty`
- 6.4 グループ・ピア（`group-*` / `peer-*`）と親子・兄弟への反応
- 6.5 メディア系: ブレークポイント・`dark`・`motion-reduce`・`print`
- 6.6 属性・データ系: `aria-*` `data-*`（v4 で柔軟化）
- 6.7 `has-*`（親が子を持つとき）・`not-*`（v4）・`*`（直接の子）
- 6.8 バリアントのスタック（`dark:lg:hover:` の評価順）
- 6.9 カスタムバリアント（`@custom-variant`）
- ◎ docs: Hover, focus & other states / ◎ docs: Responsive design / ◎ docs: Dark mode

---

# 第3部 環境構築

## 第7章 Tailwind CSS の導入方法
**ねらい:** v4 を最短で動かし、各導入経路の違いを理解する。

- 7.1 導入経路の地図（Vite プラグイン / PostCSS / CLI / CDN）
- 7.2 最速の入口: Play CDN（`@tailwindcss/browser`、開発・学習用）と Tailwind Play（play.tailwindcss.com）
- 7.3 推奨: `@tailwindcss/vite` での導入手順
- 7.4 PostCSS（`@tailwindcss/postcss`）での導入
- 7.5 CLI（`@tailwindcss/cli`）での導入とウォッチ
- 7.6 `@import "tailwindcss"` と最小の CSS エントリ
- 7.7 v3 からの移行ツール（`@tailwindcss/upgrade`）の概要
- 7.8 よくある初回トラブル（クラスが効かない・検出されない）
- ◎ docs: Installation（各経路）/ ◎ docs: Upgrade guide

## 第8章 フレームワークごとの導入
**ねらい:** 主要フレームワークでの導入差を実コードで示す。**Rails を最重点。**

- 8.1 導入差が生まれる理由（ビルドパイプラインの違い）
- 8.2 **Rails 詳説 ①**: `tailwindcss-rails` gem（Node ビルド不要の Rails 向け gem 経路。スタンドアロン実行ファイルを使う）と `bin/rails tailwindcss:install`
- 8.3 **Rails 詳説 ②**: Propshaft / Sprockets・`app/assets/tailwind/application.css`・`bin/dev` とウォッチ
- 8.4 **Rails 詳説 ③**: `cssbundling-rails` + esbuild/Vite 経路との比較・使い分け
- 8.5 **Rails 詳説 ④**: importmap 構成での注意点と Turbo との相性
- 8.6 React（Vite）での導入
- 8.7 Next.js（App Router）での導入と注意点
- 8.8 Vue / Nuxt での導入
- 8.9 Svelte / SvelteKit での導入
- 8.10 Astro での導入
- 8.11 早見表（各環境の設定ファイル・エントリ・ウォッチ方法）
- ◎ docs: Framework guides（Rails / Next.js / Nuxt / SvelteKit / Astro ほか）/ ◎ tailwindcss-rails README

## 第9章 エディタ環境
**ねらい:** 補完・整形・誤り検知で実務速度を上げる。

- 9.1 VS Code: Tailwind CSS IntelliSense（補完・ホバー・色プレビュー）
- 9.2 クラス順の自動整形: `prettier-plugin-tailwindcss`
- 9.3 重複・衝突の検知（リンティングの考え方）
- 9.4 `@theme` などディレクティブで出る「unknown at-rule」警告への対処
- 9.5 JetBrains 系・Neovim 等での対応状況
- 9.6 補完を効かせる設定（`tailwindcss` 言語モード・カスタムクラス属性）
- ◎ docs: Editor setup / ◎ GitHub: tailwindlabs/tailwindcss-intellisense・prettier-plugin-tailwindcss

---

# 第4部 Utility Class を使う

各章共通の方針: 「Tailwind 以前の素の CSS → 対応するユーティリティ → 出力／生成 CSS → 実務での型」。

## 第10章 Spacing
**ねらい:** 余白を「数値の暗記」ではなくスケール（制約）として捉え、一貫した間隔設計の土台を作る。

- 10.1 spacing スケールの思想（4px 基準・`--spacing` の動的計算 / v4）
- 10.2 padding（`p-*` `px-*` `pt-*` …）
- 10.3 margin と負のマージン（`-m-*`）
- 10.4 要素間の間隔: `space-x/y-*` と `gap-*` の違い・使い分け
- 10.5 任意の値とスケール外の値
- 10.6 実務: 一貫した余白設計とアンチパターン（無秩序な任意値）
- ◎ docs: Padding / Margin / Gap / Space

## 第11章 Typography
**ねらい:** 文字まわりのユーティリティを体系的に押さえ、可読性の高い本文・記事を組めるようにする。

- 11.1 フォントサイズ・行間（`text-*` と行間のセット）
- 11.2 フォントファミリ・ウェイト・字間（`font-*` `tracking-*`）
- 11.3 行揃え・装飾・変形（`text-center` `underline` `uppercase` …）
- 11.4 行数制限（`line-clamp-*`・v4 でコア化）
- 11.5 リッチテキスト全体を整える `@tailwindcss/typography`（`prose`）
- 11.6 実務: 本文 CMS 出力・記事ページの型
- ◎ docs: Font size / Typography plugin

## 第12章 Colors
**ねらい:** v4 の oklch パレットと不透明度・グラデーションを理解し、ブランド色を破綻なく組み込む。

- 12.1 デフォルトパレットと oklch / P3（v4）
- 12.2 背景・文字・ボーダー・リング色
- 12.3 不透明度の指定（`bg-black/50` と `color-mix()` / v4）
- 12.4 グラデーション（線形・放射・円錐・補間モード / v4 で拡張）
- 12.5 テーマでの色のカスタムと意味的な色名（semantic tokens）
- 12.6 実務: ブランドカラーの組み込みとダークモード前提の設計
- ◎ docs: Colors / Background / Gradient

## 第13章 Borders と Effects
**ねらい:** 境界・角丸・影・フィルタで、トークンに沿った立体感とフォーカス表現を作れるようにする。

- 13.1 ボーダー幅・色・スタイル
- 13.2 角丸（`rounded-*`・論理プロパティ対応）
- 13.3 影（`shadow-*`・`inset-shadow-*` / v4）・リング（`ring-*`）
- 13.4 不透明度・ミックスブレンド・フィルタ（`blur` `brightness` …）
- 13.5 背景画像・サイズ・位置
- 13.6 実務: カード/ボタンの立体感、フォーカスリングとアクセシビリティ
- ◎ docs: Border / Box shadow / Filter / Ring

## 第14章 Layout
**ねらい:** display・position・サイズ・コンテナクエリで、ページの骨格を組み立てられるようにする。

- 14.1 display（`block` `inline-*` `hidden` …）
- 14.2 position と `inset-*`・`z-*`
- 14.3 サイズ（`w-*` `h-*` `size-*`・`min/max`・論理プロパティ）
- 14.4 overflow・object-fit / position
- 14.5 コンテナと `container` ユーティリティ／Container Queries（`@container` `@md:` / v4 コア）
- 14.6 実務: ページの骨格を組む手順
- ◎ docs: Display / Position / Width / Container queries

## 第15章 Flexbox
**ねらい:** 既知の Flexbox 知識をユーティリティに対応づけ、ナビ・ツールバーを素早く組めるようにする。

- 15.1 Flexbox の素の CSS と Tailwind の対応表
- 15.2 方向・折り返し（`flex-row` `flex-wrap`）
- 15.3 主軸・交差軸の配置（`justify-*` `items-*` `content-*`）
- 15.4 伸縮（`grow` `shrink` `basis-*`）
- 15.5 個別配置（`self-*` `order-*`）
- 15.6 実務: ナビゲーションバー・ツールバーの型
- ◎ docs: Flex / Justify content / Align items

## 第16章 Grid
**ねらい:** Grid をユーティリティで表現し、カードグリッドやダッシュボードのレイアウトを組めるようにする。

- 16.1 Grid の素の CSS と Tailwind の対応表
- 16.2 列・行の定義（`grid-cols-*` `grid-rows-*`・任意トラック）
- 16.3 配置とスパン（`col-span-*` `row-start-*`・`auto-rows`）
- 16.4 `gap` と Flexbox との使い分け
- 16.5 動的な列数（`grid-cols-15` のような任意値 / v4）
- 16.6 実務: カードグリッド・ダッシュボードレイアウト
- ◎ docs: Grid template columns / Gap / Grid

---

# 第5部 実践的な Tailwind CSS

## 第17章 レスポンシブデザイン
**ねらい:** モバイルファーストの上書きモデルを理解し、過剰な分岐を避けた設計ができるようにする。

- 17.1 モバイルファースト原則（無印＝全幅、`md:` 以上で上書き）
- 17.2 デフォルトブレークポイントと `--breakpoint-*` のカスタム
- 17.3 範囲指定・`max-*` バリアント
- 17.4 メディアクエリ vs Container Queries（v4）の使い分け
- 17.5 実務: ブレークポイント設計のアンチパターン（過剰な分岐）
- ◎ docs: Responsive design / Container queries

## 第18章 ダークモード
**ねらい:** `dark:` の仕組みと切替戦略を理解し、ちらつきのないダークモードを実装できるようにする。

- 18.1 `dark:` バリアントの仕組み
- 18.2 `media`（OS 連動）と `class`/`selector`（手動切替）戦略
- 18.3 v4 でのダークモード設定（`@custom-variant dark`）
- 18.4 トグル実装（Rails / React それぞれ）とちらつき対策
- 18.5 実務: 色設計をダークモード前提にする（セマンティックトークン）
- ◎ docs: Dark mode

## 第19章 アニメーション
**ねらい:** transition・transform・カスタムアニメーションを、アクセシビリティに配慮して節度よく使えるようにする。

- 19.1 transition（`transition` `duration-*` `ease-*` `delay-*`）
- 19.2 transform（`translate` `scale` `rotate`・3D / v4）
- 19.3 組み込みアニメーション（`animate-spin` `animate-pulse` …）とカスタム（`@theme` の `--animate-*`）
- 19.4 入場アニメーション `@starting-style`（v4）
- 19.5 `motion-reduce` への配慮（アクセシビリティ）
- 19.6 実務: マイクロインタラクション、過剰演出を避ける
- ◎ docs: Transition / Transform / Animation

## 第20章 フォームデザイン
**ねらい:** フォーム要素のばらつきを整え、状態（focus/invalid 等）を見た目に反映できるようにする。

- 20.1 素のフォーム要素のばらつきと `@tailwindcss/forms`
- 20.2 入力・選択・チェック/ラジオのスタイリング
- 20.3 状態表現（`focus` `invalid` `disabled` `required` `peer-*` バリデーション表示）
- 20.4 `field-sizing`（v4）など新ユーティリティ
- 20.5 実務: Rails フォーム（form_with）/ React フォームでの組み込み
- ◎ docs: forms plugin / Hover, focus & other states

## 第21章 アクセシビリティ
**ねらい:** ユーティリティは見た目・意味は HTML という役割分担を踏まえ、a11y を落とさない実装を身につける。

- 21.1 ユーティリティと a11y の関係（クラスは見た目、意味は HTML）
- 21.2 視覚的に隠す `sr-only` / `not-sr-only`
- 21.3 フォーカス可視化（`focus-visible` とリング）
- 21.4 `aria-*` / `data-*` バリアントで状態を見た目に反映
- 21.5 `motion-reduce`・コントラスト・色だけに依存しない設計
- 21.6 実務: キーボード操作と Headless UI の活用
- ◎ docs: Screen readers / aria 関連 / Headless UI

---

# 第6部 コンポーネント設計

## 第22章 UI コンポーネントを作る
**ねらい:** 重複の正しい捉え方を学び、`@apply` ではなくコンポーネント抽出を選ぶ判断軸を持つ。

- 22.1 「重複」をどう捉えるか（テンプレートのループ・部分テンプレート）
- 22.2 `@apply` の役割と落とし穴（いつ使い、いつ使わないか）
- 22.3 `@apply` よりコンポーネント抽出が推奨される理由（作者の見解）
- 22.4 ボタンを題材にした抽出（HTML / Rails partial / React）
- 22.5 カスタムユーティリティ（`@utility` / v4）とコンポーネントクラスの境界
- ◎ docs: Styling with Utility Classes（Managing duplication）/ Functions & directives

## 第23章 再利用性を高める
**ねらい:** 条件付きクラス・衝突解消・バリアント設計の定番手法で、長いクラス列を保守可能にする。

- 23.1 クラス名が長くなる問題への現実的対処
- 23.2 条件付きクラスの組み立て（`clsx` / `classnames`）
- 23.3 クラス衝突の解消（`tailwind-merge`）
- 23.4 バリアント設計: **Class Variance Authority（CVA）**
- 23.5 デザイントークンを単一の真実にする（テーマ ＋ セマンティック名）
- 23.6 実務: デザインシステムへの育て方
- 23.7 AI 生成コードとクラス設計（生成された長いクラス列を CVA／コンポーネントへ畳み込む、レビューで整える）
- ◎ docs / ○ CVA・tailwind-merge・clsx の各 README

## 第24章 Rails でのコンポーネント設計
**ねらい:** Rails の選択肢を比較し、Tailwind と最も相性よく運用する。

- 24.1 Rails でのコンポーネント化の選択肢（partial / helper / ViewComponent / Phlex）
- 24.2 部分テンプレートと `locals`、`tag` ヘルパーでのクラス組み立て
- 24.3 **ViewComponent**: コンポーネントクラス＋テンプレート、バリアントの渡し方
- 24.4 **Phlex**: Ruby で HTML を書く、Tailwind クラスの合成と再利用
- 24.5 Rails で CVA 的なバリアント管理を実現する（Ruby 側のヘルパー設計）
- 24.6 Hotwire（Turbo/Stimulus）と動的クラス操作・ダークモードトグル
- 24.7 実務: 既存 Rails アプリへの段階的導入
- ◎ tailwindcss-rails / ○ ViewComponent docs / ○ Phlex docs

## 第25章 React でのコンポーネント設計
**ねらい:** `cn` ヘルパー・CVA・Headless UI を組み合わせ、型安全で再利用可能な React コンポーネントを設計する。

- 25.1 props でバリアントを受けるコンポーネント設計
- 25.2 `clsx` + `tailwind-merge`（`cn` ヘルパー）の定番パターン
- 25.3 CVA による型安全なバリアント
- 25.4 Headless UI / Radix + Tailwind の組み合わせ
- 25.5 shadcn/ui に見る「コピーして所有する」コンポーネント観
- 25.6 Next.js での注意（Server Components・クラスの動的生成回避）
- ◎ docs / ○ Headless UI・CVA・shadcn/ui の各一次資料

---

# 第7部 実務での Tailwind CSS

## 第26章 プロジェクト構成
**ねらい:** CSS エントリ・トークン・レイヤーの置き場所を決め、大規模化に耐える構成とチーム運用を整える。

- 26.1 CSS エントリの構成（`@import "tailwindcss"` ＋ `@theme` ＋ カスタムレイヤー）
- 26.2 テーマ・トークンの置き場所と命名規約
- 26.3 カスタムユーティリティ／コンポーネント／ベースの分け方（`@layer` `@utility` `@plugin`、および公式プラグイン typography/forms を構成上どこで管理するか。※第11・20章は「使い方」、本章は「管理場所」を扱う）
- 26.4 大規模化への備え（ファイル分割・`@source`・モノレポ）
- 26.5 CI でのビルドと出力サイズの監視（必要に応じて Storybook や視覚回帰テストで見た目を確認する、程度の補足に留める）
- 26.6 チームでのクラス順統一・レビュー観点
- 26.7 AI が従えるテーマ・規約の作り方（`@theme` で意味的な色・余白・フォントを定義し、コンポーネント規約・命名を言語化しておくと、AI 出力をブランドに沿わせやすい）
- ◎ docs: Functions & directives / Detecting classes / Theme

## 第27章 Tailwind CSS のアンチパターン
**ねらい:** 現場で頻発する崩れ方を具体例で示し、その原因と矯正手順を身につける。

- 27.1 任意の値（`[...]`）の乱用と一貫性の崩壊
- 27.2 `@apply` でユーティリティを CSS に逃がしすぎる
- 27.3 クラス名の動的文字列結合で検出漏れ（`text-${color}` 問題）
- 27.4 「巨大コンポーネント1個」化（抽出粒度の誤り）
- 27.5 デザイントークンを無視した直値の散乱
- 27.6 既存 CSS との二重管理
- 27.7 アンチパターンの矯正手順
- 27.8 AI 生成 Tailwind のよくある崩れ方（任意値の乱用、`bg-blue-500`/`p-4` などトークン無視の直値選択、`text-${color}` 系の検出漏れ、レスポンシブ・a11y の欠落）とレビュー観点
- ◎ docs（Detecting classes の注意）/ ○ 公式 FAQ・GitHub Discussions

## 第28章 Tailwind CSS への批判と評価
**ねらい:** 賛否の論点を公平に扱い、読者が自分で判断できるようにする。

- 28.1 批判①「HTML が汚い」（コンポーネント化できる環境かに依存、という評価）
- 28.2 批判②「インラインスタイルと同じでは」（制約・状態・レスポンシブで反論）
- 28.3 批判③「関心の分離に反する」（価値観の対立として整理。BEM 側の合理性も認める）
- 28.4 批判④「学習コスト」（短期は批判が正・長期は反論が正）
- 28.5 批判⑤「ロックインと移植性」（採用は容易だが撤退は重い）
- 28.6 計測できる効果の実態（CSS サイズ・変更容易性・開発速度）
- 28.7 結論: 向くプロジェクト・向かないプロジェクト
- ◎ docs（インラインスタイルへの公式回答）/ Adam Wathan の思想記事 / ○ BEM 公式（対立側の思想）

---

# 第8部 Tailwind CSS の未来

## 第29章 Tailwind v4
**ねらい:** v4 が何をどう変えたのかを内部の仕組みごと理解し、v3 からの移行を実務でこなせるようにする。

- 29.1 v4 が目指したもの（速度・モダン CSS・設定の簡素化）
- 29.2 新エンジン（Oxide / Lightning CSS）の内部
- 29.3 CSS ファースト設定への全面移行（`@theme`）
- 29.4 モダン CSS の全面採用（cascade layers・`@property`・`color-mix`・論理プロパティ）
- 29.5 Container Queries・3D transform・`@starting-style` の標準化
- 29.6 v3 → v4 移行の実務（`@tailwindcss/upgrade`・破壊的変更の要点）
- ◎ v4.0 Blog / docs: Upgrade guide

## 第30章 Utility First の未来
**ねらい:** Atomic CSS の潮流とネイティブ CSS の進化、そして AI による UI 生成の中で Tailwind の立ち位置を見通す。

- 30.1 Atomic CSS の歴史的潮流における Tailwind の位置
- 30.2 ネイティブ CSS の進化（cascade layers・container queries・`@property`）との関係
- 30.3 他ツールへの影響（UnoCSS・各種 utility 系）
- 30.4 デザインツール → コード（Tailwind 前提の UI 生成）の潮流
- 30.5 AI UI 生成と Tailwind（なぜ ChatGPT / Cursor / Copilot は Tailwind を出力しやすいのか＝クラスがそのまま見た目で学習データも豊富・1ファイル完結。「フレームワークが薄くなる」未来像と、Figma / v0 / shadcn/ui 的な「生成 → 取り込み」の流れ。コピーで終わらせず自分のテーマ・コンポーネント設計へ所有する考え方への接続）
- ◎ v4.0 Blog / ○ MDN（モダン CSS）/ ○ shadcn/ui・v0 等の一次資料

## 第31章 Tailwind CSS を選ぶべきか
**ねらい:** プロジェクトの条件に応じた採用判断の軸を整理し、読者が自分の現場で結論を出せるようにする。

- 31.1 採用判断のチェックリスト（チーム・規模・寿命・デザインの安定度）
- 31.2 Rails プロジェクトでの判断軸
- 31.3 React/Next プロジェクトでの判断軸
- 31.4 代替案（CSS Modules / 素の CSS＋カスタムプロパティ / CSS-in-JS / UnoCSS）との比較
- 31.5 段階的導入と撤退可能性
- 31.6 結論: どんな読者に勧められるか
- ◎ docs / ○ 各代替案の一次資料

---

# 付録

## 付録A 公式ドキュメントの歩き方
- docs の構成（Core concepts / Base styles / Layout / … / Customization）
- 検索の使い方、バージョン切替、Playground と Upgrade guide の場所
- ◎ <https://tailwindcss.com/docs>

## 付録B よく使う Utility 一覧
- カテゴリ別（Spacing / Sizing / Typography / Color / Flex / Grid / Border / Effects / States）に頻出クラスを厳選

## 付録C チートシート
- 1 ページで引ける早見表（バリアント・ブレークポイント・spacing スケール・色）

## 付録D 用語集
- Utility First / バリアント / 任意の値 / `@theme` / `@apply` / `@utility` / JIT / Oxide / cascade layers / container query / デザイントークン ほか

## 付録E AI に Tailwind コードを依頼するときのプロンプト集
**ねらい:** 第26・27・30章の内容を、すぐ使える実用的なプロンプト例に落とす。

- E.1 良い依頼の型: 「`@theme` の既存テーマ変数・コンポーネント規約に従って」と前提を渡す（"カードを作って" との違い）
- E.2 出力形式の明示: Rails ERB / ViewComponent / React(tsx) / Vue など、どの形で返すかを指定する
- E.3 制約の指定: 動的クラス生成（`text-${color}`）を避ける、任意値より theme トークンを使う、レスポンシブと a11y を満たす
- E.4 そのまま使えるプロンプト例（新規 UI 生成 / 既存コンポーネントの改修 / リファクタリング）
- E.5 レビュー用チェックリスト（クラスが実在するか・レスポンシブ破綻・a11y 低下・色/余白/角丸/影がトークン準拠・検出漏れパターン）
- ◎ docs: Theme / Detecting classes / ○ shadcn/ui

## 付録F ハンズオン: ゼロから動く最小例
**ねらい:** 概念を積み上げる本文とは別に、初学者が「コピペで完走して動く」体験をできる通し手順を提供する。

- F.1 いちばん速い: ビルド不要（Play CDN / Tailwind Play）
- F.2 Rails で動かす（本書の重点経路。`rails new --css tailwind` → `bin/dev`）
- F.3 Vite（React）で動かす
- F.4 うまくいかないときは（症状別の診断）
- ◎ docs: Installation / Play CDN

## 各部末の演習（やってみよう）
- 第1〜8部の各末尾に「演習（第N部）」を 1〜3 問配置。各部の学習目標に対応し、自己点検の導線として参照節（§N.M）を併記する。

## Web 書籍化（mdBook）
- 本文 Markdown は `manuscript/` 配下に置き、`book.toml` で mdBook の `src` として指定する。
- mdBook 用のナビゲーションは `manuscript/SUMMARY.md` に置く。Web ではページが長くなりすぎないよう、本文は章ごとに 1 ページへ分割する。
- 各部の導入は `manuscript/part*/index.md`、章本文は `manuscript/part*/chapter*.md`、演習は `manuscript/part*/exercises.md`、付録は `manuscript/appendix/*.md` に置く。原稿と Web 書籍用ファイルは同じ Markdown を使い、二重管理しない。
- `mdbook build` の生成物は `/book/` に出力し、リポジトリにはコミットしない。

---

## 執筆順とマイルストーン
1. 第1部（1〜3章）— 思想と歴史。本書の背骨。
2. 第2部（4〜6章）— 仕組み。以降の理解の土台。
3. 第3部（7〜9章）— 環境構築（Rails 重点）。
4. 第4部（10〜16章）— Utility リファレンス兼解説。
5. 第5〜8部 ＋ 付録。

各章は STYLEGUIDE.md に従い、章末に実在確認済みの「参考資料」を付けます。
