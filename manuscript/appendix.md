# 付録

本文を読み終えた読者が、実務で手元に置いて使うための資料です。付録A は公式ドキュメントの歩き方、付録B はよく使うユーティリティ、付録C は早見表、付録D は用語集、付録E は AI に Tailwind コードを依頼するときのプロンプト集、付録F は「ゼロから動く最小例」のハンズオンです。

> **はじめて Tailwind を動かす人は、付録F から始めても構いません。** Play CDN / Rails / Vite の 3 経路で、コピペして「Hello, Tailwind!」を表示するまでを通しで案内します（第3部からもここへ誘導しています）。

---

# 付録A 公式ドキュメントの歩き方

本書は「なぜ」を理解するための教科書であり、すべてのクラスを網羅してはいません。日々の開発では、**公式ドキュメント**（https://tailwindcss.com/docs）を引くのが基本になります。ここでは、その歩き方を示します。

## docs の構成

公式ドキュメントは、おおむね次のように分類されています。

- **Getting started / Core concepts**: 導入（Installation）と、本書の第2部にあたる中心的な考え方（Styling with utility classes / Hover, focus & other states / Responsive design / Dark mode / Theme / Colors / Adding custom styles / Detecting classes / Functions and directives）。困ったらまずここに戻ります。
- **Base styles**: Preflight などの土台。
- **Layout / Flexbox & Grid / Spacing / Sizing / Typography / Backgrounds / Borders / Effects / Filters / Transitions & Animation / Transforms / Interactivity / SVG / Accessibility**: ユーティリティのカテゴリ別リファレンス（本書の第4・5部に対応）。
- **Customization 系**（Theme / Functions and directives / Detecting classes など）: テーマや設定（本書の第5・26章に対応）。

## 効率的な引き方

- **検索を使う**: docs 上部の検索（`⌘K` / `Ctrl K`）が最速です。プロパティ名（`gap`・`grid-template-columns`）でもクラス名でも引けます。
- **各ページの「Quick reference」表**: 各ユーティリティのページ冒頭に、クラスと生成 CSS の対応表があります。値を確認したいときはここを見ます。
- **バージョンに注意**: 本書は v4 前提です。古い記事や v3 の docs を見ていないか、URL とバージョン表記を確認しましょう。
- **Playground と Upgrade guide**: 挙動を試すなら **Tailwind Play**（https://play.tailwindcss.com/）、移行するなら **Upgrade guide**（https://tailwindcss.com/docs/upgrade-guide）。

---

# 付録B よく使う Utility 一覧

実務で登場頻度の高いユーティリティを、カテゴリ別に厳選しました。網羅ではなく「まずこれを覚えれば大半は書ける」というセットです。

## Spacing（余白・第10章）
- padding: `p-*` `px-*` `py-*` `pt-* pr-* pb-* pl-*`
- margin: `m-*` `mx-*` `my-*`（負: `-m-*`）
- 間隔: `gap-*`（Flex/Grid）/ `space-x-* space-y-*`

## Sizing（サイズ・第14章）
- 幅高さ: `w-*` `h-*` `size-*`
- 割合・特殊: `w-1/2` `w-full` `w-screen` `h-dvh`
- 制限: `min-w-*` `max-w-*` `min-h-*` `max-h-*`

## Typography（文字・第11章）
- サイズ/行間: `text-xs`〜`text-9xl`、`text-sm/6`
- 太さ/字間: `font-normal` `font-medium` `font-bold` / `tracking-tight`
- 揃え/装飾: `text-center` `text-right` / `underline` / `truncate` `line-clamp-*`

## Colors（色・第12章）
- `bg-*` `text-*` `border-*` `ring-*`（例: `bg-blue-600` `text-white`）
- 不透明度: `bg-black/50`

## Flexbox（第15章）
- `flex` `flex-col` `flex-wrap`
- `justify-center` `justify-between` / `items-center`
- `grow` `shrink-0` `basis-*`

## Grid（第16章）
- `grid` `grid-cols-*` `col-span-*` `row-span-*` `gap-*`

## Borders / Effects（第13章）
- `border` `border-2` / `rounded-md` `rounded-full`
- `shadow-sm` `shadow-md` / `ring-2`
- `opacity-*` `blur-*`

## Layout（第14章）
- `block` `inline-block` `hidden` `flex` `grid`
- `relative` `absolute` `fixed` `sticky` / `inset-0` `top-*` `z-*`
- `overflow-hidden` `overflow-auto` / `object-cover`

## States / Variants（第6章）
- 状態: `hover:` `focus:` `focus-visible:` `active:` `disabled:`
- レスポンシブ: `sm:` `md:` `lg:` `xl:` `2xl:`（および `max-*:`）
- その他: `dark:` `group-*:` `peer-*:` `has-*:` `aria-*:` `data-*:` `motion-reduce:`

---

# 付録C チートシート

1 ページで引ける早見表です。

## ブレークポイント（第17章）
| プレフィックス | 最小幅 |
| --- | --- |
| `sm:` | 40rem (640px) |
| `md:` | 48rem (768px) |
| `lg:` | 64rem (1024px) |
| `xl:` | 80rem (1280px) |
| `2xl:` | 96rem (1536px) |

※ コンテナクエリは `@container` ＋ `@sm: @md: ...`（親要素の幅に反応）

## spacing スケール（第10章）
基準 `--spacing` は既定 `0.25rem`（4px）。`数値 × 0.25rem`。
| クラス | 値 |
| --- | --- |
| `p-1` | 0.25rem (4px) |
| `p-2` | 0.5rem (8px) |
| `p-4` | 1rem (16px) |
| `p-6` | 1.5rem (24px) |
| `p-8` | 2rem (32px) |
| `p-12` | 3rem (48px) |

## フォントサイズ（第11章）
| クラス | 値 |
| --- | --- |
| `text-xs` | 12px |
| `text-sm` | 14px |
| `text-base` | 16px |
| `text-lg` | 18px |
| `text-xl` | 20px |
| `text-2xl` | 24px |
| `text-3xl` | 30px |

## 色の段階（第12章）
`50`（最も明るい）→ `100` → … → `500`（基準）→ … → `900` → `950`（最も暗い）。
例: `bg-gray-50` `text-gray-500` `border-gray-900`。不透明度は `/数値`（例 `bg-black/50`）。

## 影（v4・第13章）
小 → 大: `shadow-2xs` `shadow-xs` `shadow-sm` `shadow-md` `shadow-lg` `shadow-xl` `shadow-2xl`（無: `shadow-none`）
※ v3 の `shadow-sm` は v4 の `shadow-xs`、v3 の `shadow` は v4 の `shadow-sm`。

## v3 → v4 主な変更（第29章）
| v3 | v4 |
| --- | --- |
| `@tailwind base; ...` | `@import "tailwindcss";` |
| `tailwind.config.js` | `@theme`（CSS） |
| `!bg-red-500` | `bg-red-500!` |
| `shadow-sm` / `shadow` | `shadow-xs` / `shadow-sm` |
| `rounded-sm` | `rounded-xs` |
| `ring`（3px） | `ring-3`（既定は 1px） |
| `outline-none` | `outline-hidden` |
| 既定のボーダー色 `gray-200` | `currentColor` |

---

# 付録D 用語集

本書で登場した重要語をまとめます。詳しくは各章を参照してください。

- **ユーティリティクラス**: 単一の役割だけを持つ小さなクラス（`p-4`・`bg-white` など）。これを組み合わせてデザインする（第3章）。
- **Utility First（ユーティリティファースト）**: ユーティリティクラスの組み合わせで UI を作る設計思想（第3章）。
- **バリアント**: ユーティリティに条件を付ける接頭辞（`hover:`・`md:`・`dark:` など）。CSS のセレクタやメディアクエリを生成する（第6章）。
- **任意の値（arbitrary value）**: 角かっこでスケール外の値を直接書く記法（`p-[13px]`）。便利だが乱用は一貫性を崩す（第4・27章）。
- **テーマ変数 / デザイントークン**: `@theme` で定義する、色・余白などの「デザイン上の決め事」。CSS 変数とユーティリティ生成を兼ねる（第5章）。
- **セマンティックトークン**: 役割を表す色名などのトークン（`--color-primary` など）。ダークモードや配色変更に強い（第12・26章）。
- **`@theme`**: テーマ変数を定義する v4 のディレクティブ（第5章）。
- **`@apply`**: ユーティリティを自前の CSS クラスに展開するディレクティブ。多用は非推奨（第22章）。
- **`@utility`**: 単機能のカスタムユーティリティを追加する v4 のディレクティブ（第22・26章）。
- **`@plugin`**: JS ベースのプラグイン（typography/forms など）を CSS から読み込む互換ディレクティブ（第26章）。
- **`@source`**: クラス走査の対象を明示的に追加/除外するディレクティブ（第4・26章）。
- **`@custom-variant`**: 独自のバリアントを定義するディレクティブ。手動ダークモードにも使う（第6・18章）。
- **JIT（Just-In-Time）**: 使われているクラスだけをその場で生成する仕組み（第4章）。
- **Oxide**: v4 の新エンジンのコードネーム。性能重視部分は Rust 製（第4・29章）。
- **Lightning CSS**: v4 が内蔵する Rust 製の CSS 処理ツール（パース・プレフィックス・圧縮など）（第4・29章）。
- **カスケードレイヤー（`@layer`）**: レイヤーの優先順位で詳細度の戦いを制御するモダン CSS 機能（第4章）。
- **コンテナクエリ（container query）**: 画面ではなく親要素の幅に反応するレイアウト（`@container` / `@md:`）（第14・17章）。
- **Preflight**: Tailwind が当てる土台のリセット CSS（第4章）。
- **`cn`**: `clsx`（条件分岐）と `tailwind-merge`（衝突解消）を組み合わせた定番ヘルパー（第23章）。
- **CVA（Class Variance Authority）**: 型安全にバリアントを管理するライブラリ（第23章）。
- **モバイルファースト**: 無印が全画面に効き、`md:` などで広い画面を上書きする設計（第17章）。
- **FOUC**: ダークモード初期表示などで起きる一瞬のちらつき（第18章）。

---

# 付録E AI に Tailwind コードを依頼するときのプロンプト集

第26・27・30章で見たとおり、AI は Tailwind を出力しやすい一方、規約を知らないと崩れがちです。ここでは、実務ですぐ使えるプロンプトの型を示します。

## E.1 良い依頼の型: 前提を渡す

「カードを作って」だけでは、AI は独自の色やスケールで作ってしまいます。**既存のテーマと規約を前提として渡す**のがコツです。

> 悪い例:「Tailwind でカードコンポーネントを作って」
>
> 良い例:「Tailwind v4 でカードを作ってください。**色は既存のデザイントークン（`bg-surface` `text-foreground` `border-border`）だけを使い**、独自の `bg-gray-*` や任意の値（`[...]`）は使わないでください。余白は spacing スケール（`p-4` `p-6` など）に従ってください。」

## E.2 出力形式の明示

> 「出力は **React の関数コンポーネント（TypeScript, tsx）**で、props で `intent`（primary/secondary）と `size`（sm/md）を受けられるようにしてください。バリアントは **CVA** で定義し、`cn` ヘルパーで `className` を合成してください。」

Rails なら「**ERB の部分テンプレート**で」「**ViewComponent** で」、と形式を指定します。

## E.3 制約の指定（崩れを防ぐ）

> 「次の制約を守ってください。
> - クラス名は**完全な文字列**で書く（`bg-${color}` のような動的生成は禁止）。
> - 色・余白は**デザイントークン**を使い、任意の値（`[...]`）は避ける。
> - **レスポンシブ**（`sm:` `md:`）と**アクセシビリティ**（`aria-*`、`focus-visible:`、適切な HTML 要素）を考慮する。」

## E.4 そのまま使えるプロンプト例

**新規 UI 生成**:
> 「Tailwind v4 ＋ React(tsx) で、通知カードのコンポーネントを作ってください。デザイントークン（`bg-surface` `text-foreground` `text-muted`）のみ使用。タイトル・本文・閉じるボタンを持ち、閉じるボタンには `aria-label` と `focus-visible:` のリングを付けてください。動的クラス名と任意の値は使わないこと。」

**既存コンポーネントの改修**:
> 「次のコンポーネントを、**ダークモード対応**にしてください。`dark:` を直接ベタ書きするのではなく、セマンティックトークン（`bg-surface` など）で表現する方針です。アクセシビリティとレスポンシブは崩さないでください。\n\n（ここにコードを貼る）」

**リファクタリング**:
> 「次の長いクラス列を持つボタンを、**CVA でバリアント整理**し、`cn` で `className` を合成する形にリファクタリングしてください。見た目は変えないこと。\n\n（ここにコードを貼る）」

## E.5 レビュー用チェックリスト

AI の出力は「下書き」として受け取り、次を確認してから取り込みます（第27章）。

- [ ] 使われているクラスは**実在**するか（綴り間違いがないか）。
- [ ] **レスポンシブ**が破綻していないか（`md:` などの設計が妥当か）。
- [ ] **アクセシビリティ**を落としていないか（適切な要素・`aria-*`・フォーカス可視化）。
- [ ] 色・余白・角丸・影が**トークンに沿っている**か（直値・任意値の乱用がないか）。
- [ ] `text-${color}` のような**検出漏れパターン**がないか。
- [ ] 長いクラス列は、**コンポーネントや CVA に畳み込めて**いるか。

---

# 付録F ハンズオン: ゼロから動く最小例

本文は概念を順に積み上げる構成のため、「とにかく一度、自分の手で動かして青い文字を出してみたい」という人向けに、**ゼロから完成まで通しで動く最小例**をここにまとめます。3 つの経路を用意しました。**まずは F.1（ビルド不要）で「効く」体験をしてから**、F.2（Rails）や F.3（Vite）に進むのがおすすめです。

> どの経路でも、最後に画面で **「Hello, Tailwind!」が大きな青い太字＋下線**で表示されれば成功です。

## F.1 いちばん速い: ビルド不要（Play CDN）

エディタも `npm` も要りません。次の内容で `index.html` を作り、ブラウザで開くだけです（第7章 Play CDN）。

```html
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="utf-8" />
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
  </head>
  <body class="p-8">
    <h1 class="text-3xl font-bold text-blue-600 underline">Hello, Tailwind!</h1>
    <button class="mt-4 rounded-md bg-blue-600 px-4 py-2 text-white hover:bg-blue-700">
      ボタン
    </button>
  </body>
</html>
```

ファイルをダブルクリックしてブラウザで開き、**次がすべて確認できれば成功**です。

- [ ] 「Hello, Tailwind!」が**青い大きな太字**で表示される（`text-3xl font-bold text-blue-600`）
- [ ] 見出しに**下線**がある（`underline`）
- [ ] その下に**青いボタン**があり、マウスを乗せる（ホバーする）と**色が濃くなる**（`hover:bg-blue-700`）

確認できたら、`text-blue-600` を `text-red-600` に書き換えて保存し直し、見出しが赤くなることを試してください。「クラスを変える → 結果がすぐ変わる」を体感できます。

> **Play CDN は開発・学習用**です（本番では F.2 や F.3 を使います）。理由は、(1) ページを開くたびにブラウザ上で CSS を生成するため表示が遅い、(2) CDN からの読み込みが必要でオフラインでは動かない、の 2 点です。本番では、あらかじめビルドした CSS を配信します。

> さらに手軽に試すなら、ファイルすら作らず **Tailwind Play**（https://play.tailwindcss.com/）に上記の `<body>` 内を貼るだけでも確認できます。

## F.2 Rails で動かす（本書の重点経路）

Rails 8 以降を前提に、新規アプリで完成まで通します（第8章）。ターミナルで順に実行します。

```bash
# 1. Tailwind 入りで新規アプリを作る
rails new hello_tailwind --css tailwind
cd hello_tailwind

# 2. 確認用のページを作る
bin/rails generate controller Home index
```

`config/routes.rb` を編集し、**アプリのトップページ（`/`）を表示するルーティング**を設定します（`root` は「ルートディレクトリ」ではなく「アプリのトップ URL」の意味です）。

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root "home#index"   # "/" にアクセスしたら HomeController の index を表示
end
```

ビューにユーティリティを書きます。

```erb
<%# app/views/home/index.html.erb %>
<div class="p-8">
  <h1 class="text-3xl font-bold text-blue-600 underline">Hello, Tailwind!</h1>
  <button class="mt-4 rounded-md bg-blue-600 px-4 py-2 text-white hover:bg-blue-700">
    ボタン
  </button>
</div>
```

開発サーバーを起動します。`bin/dev` は Rails サーバーと Tailwind のウォッチを同時に動かします（第8章）。

```bash
bin/dev
```

ブラウザで `http://localhost:3000` を開き、F.1 と同じく**青い見出し＋ホバーで色が変わるボタン**が出れば成功です。仕上げに、`text-blue-600` を `text-red-600` に変えて保存してください。**`bin/dev` を動かしたまま**なら、ウォッチが効いて自動で赤くなります（ターミナルに再ビルドのログが出ます）。この「保存すると自動で反映される」感覚が、「入力 CSS → ビルド → 配信」の流れ（第8章）を体感する最短ルートです。

## F.3 Vite（React）で動かす

React/Vite 経路の最小例です（第7・8章）。

```bash
# 1. Vite + React プロジェクトを作る
npm create vite@latest hello-tailwind -- --template react
cd hello-tailwind
npm install

# 2. Tailwind を入れる
npm install tailwindcss @tailwindcss/vite
```

`vite.config.js` にプラグインを追加します。

```js
// vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
})
```

CSS エントリで Tailwind を読み込みます。`react` テンプレートでは `src/index.css` が用意されているので、その先頭に書きます（テンプレートによっては `src/style.css` の場合もあります）。

```css
/* src/index.css */
@import "tailwindcss";
```

この CSS が**エントリ（`src/main.jsx`）で読み込まれている**ことを確認してください。`react` テンプレートでは最初から次の 1 行が入っています。これが無いと何も効きません。

```jsx
// src/main.jsx（最初から入っている import を確認）
import './index.css'
```

コンポーネントを書きます。

```jsx
// src/App.jsx
export default function App() {
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold text-blue-600 underline">Hello, Tailwind!</h1>
      <button className="mt-4 rounded-md bg-blue-600 px-4 py-2 text-white hover:bg-blue-700">
        ボタン
      </button>
    </div>
  )
}
```

`npm run dev` で表示される URL を開き、青い見出しが出れば成功です。JSX では `class` ではなく `className` を使う点に注意してください（第8章）。

## F.4 うまくいかないときは（症状別の診断）

初学者がつまずくのは、たいてい次のどれかです。症状から原因を切り分けましょう。

- **見出しが太くも青くもならない（何も効かない）**: ①CSS エントリに `@import "tailwindcss";` があるか、②それをページ/アプリが読み込んでいるか（HTML の `<link>`、Vite なら `main.jsx` の `import './index.css'`）を確認（第7章）。古い記事の `@tailwind base; ...` は v4 では動きません。確認後はブラウザを**強制リロード**（`Cmd/Ctrl + Shift + R`）してキャッシュを消します。
- **保存しても変更が反映されない**: ウォッチが動いているか確認。Rails は `bin/dev`、Vite は `npm run dev` のターミナルに再ビルドのログが出ているか見ます。出ていなければ、いったん停止（`Ctrl + C`）して再起動（第7章）。
- **一部のクラスだけ効かない**: そのクラス名を `text-${color}` のように動的に組み立てていないか（第4・27章）。クラス名はつねに完全な文字列で書きます。
- **（Rails）画面が 500 エラー**: Rails サーバーのターミナルにエラーが出ています。まずそれを読みます。多いのは `config/routes.rb` の設定漏れや構文ミスです。
- **困ったら開発者ツール**: ブラウザの検証ツール（`F12`）で要素を選び、目的のクラスが付いているか、対応する CSS 規則が生成されているかを確認すると、原因の切り分けが速くなります。

---

本書は以上です。第1章で見た「CSS が大規模化で壊れる」という問題から始まり、Tailwind がそれにどう答えたのか、内部でどう動き、どう使い、どう設計・運用し、どう評価されるのかを、一貫した「なぜ」とともにたどってきました。あとは、あなた自身のプロジェクトで手を動かすだけです。

## 参考資料

* Tailwind CSS Docs（公式トップ）: https://tailwindcss.com/docs
* Tailwind Play: https://play.tailwindcss.com/
* Tailwind CSS Docs — Upgrade guide: https://tailwindcss.com/docs/upgrade-guide
