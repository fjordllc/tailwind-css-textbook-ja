# 第3部 環境構築

第2部までで、Tailwind CSS が「なぜ」「どう」動くのかを理解しました。ここからは、実際に手を動かすための**環境構築**です。

環境構築は、Tailwind でつまずく人が最も多い場所でもあります。理由は単純で、Tailwind は「どのビルドツールの上で動かすか」によって導入手順が変わるからです。Vite で動かすのか、Rails のアセットパイプラインで動かすのか——土台が違えば、入れ方も変わります。

そこでこの第3部では、まず導入経路の全体像と共通の作法を押さえ（第7章）、次に主要なフレームワークごとの具体的な手順を見ます（第8章、Rails を最重点で扱います）。最後に、補完や整形といったエディタ環境を整え、開発を快適にします（第9章）。

> **本書は Tailwind CSS v4 を前提としています。** v4 では読み込みが `@import "tailwindcss";` の 1 行になり、`tailwind.config.js` は必須ではなくなりました。古い記事に出てくる `@tailwind base; @tailwind components; @tailwind utilities;` という 3 行の書き方は **v3 までのもの**です。本書では使いません。

---

# 第7章 Tailwind CSS の導入方法

## 7.1 導入経路の地図

Tailwind の導入経路は、大きく次の 4 つです。最初にこの地図を持っておくと、自分が何を選んでいるのかを見失いません。

| 経路 | 何のためか | 向いている人 |
| --- | --- | --- |
| **Play CDN** | ビルドなしでブラウザだけで試す | とにかく今すぐ試したい・学習用 |
| **Vite プラグイン** | Vite を使うプロジェクトに組み込む | React / Vue / Svelte など Vite ベースのほとんど |
| **PostCSS プラグイン** | PostCSS を使うビルドに組み込む | Next.js や、PostCSS 前提のツール |
| **Tailwind CLI** | Tailwind 単体で CSS をビルドする | ビルドツールを増やしたくない・小規模 |

このうち、本番プロジェクトで主役になるのは **Vite プラグイン**です。v4 で最も手軽かつ高速な経路として公式が推奨しています。Rails のような独自のアセットパイプラインを持つフレームワークは、これとは別に専用の経路（gem）が用意されています（第8章）。

## 7.2 最速の入口: Play CDN と Tailwind Play

「まず Tailwind がどんなものか触りたい」なら、ビルド環境を作らずに始められる方法が 2 つあります。

**(1) Play CDN（自分の HTML ファイルで試す）**

HTML の `<head>` に次のスクリプトを 1 行入れるだけで、その場でユーティリティが効くようになります。

```html
<!doctype html>
<html>
  <head>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
  </head>
  <body>
    <h1 class="text-3xl font-bold underline">Hello world!</h1>
  </body>
</html>
```

これは v4 のパッケージ `@tailwindcss/browser` を使う方法です。ブラウザ上でその場で CSS を生成するため、**開発・学習用と割り切ってください**（本番には使いません。ページ表示のたびに生成コストがかかります）。テーマも `<style type="text/tailwindcss">` の中に `@theme { ... }` を書けば試せます。

**(2) Tailwind Play（ブラウザ上のエディタ）**

ファイルすら用意したくないなら、公式のオンライン環境 **Tailwind Play**（https://play.tailwindcss.com/）が便利です。左に HTML、右にプレビューが出て、生成された CSS も確認できます。第2部で学んだ「どんな CSS が生成されるか」を確かめるのにも最適です。

## 7.3 推奨: `@tailwindcss/vite` での導入手順

ここからが実プロジェクト向けです。まずは推奨経路である Vite から見ます。手順は 3 ステップです。

**ステップ 1: パッケージをインストールする**

```bash
npm install tailwindcss @tailwindcss/vite
```

**ステップ 2: Vite に Tailwind プラグインを登録する**

`vite.config.ts`（または `.js`）にプラグインを追加します。

```ts
import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    tailwindcss(),
  ],
})
```

**ステップ 3: CSS で Tailwind を読み込む**

プロジェクトの CSS エントリ（たとえば `src/style.css`）に、次の 1 行を書きます。

```css
@import "tailwindcss";
```

あとは `npm run dev` で開発サーバーを起動すれば完了です。第2部で見たとおり、この時点で `content` 配列のような走査対象の指定は不要です（v4 の自動コンテンツ検出）。

## 7.4 PostCSS（`@tailwindcss/postcss`）での導入

ビルドが PostCSS を前提にしている場合（代表例は次章の Next.js）は、PostCSS プラグインを使います。

**ステップ 1: インストール**

```bash
npm install tailwindcss @tailwindcss/postcss postcss
```

**ステップ 2: PostCSS の設定ファイルを作る**

`postcss.config.mjs` を作成します。

```js
export default {
  plugins: {
    "@tailwindcss/postcss": {},
  },
}
```

**ステップ 3: CSS で読み込む**

```css
@import "tailwindcss";
```

> v3 を知っている人へ: v3 では `postcss.config.js` に `tailwindcss` と `autoprefixer` を並べて書くのが定番でした。v4 では、ベンダープレフィックス付与などを内蔵の Lightning CSS が担うため（第4章）、`autoprefixer` を別途書く必要はありません。

## 7.5 CLI（`@tailwindcss/cli`）での導入とウォッチ

「Vite も PostCSS も使いたくない、Tailwind だけで CSS を作りたい」場合は、Tailwind CLI を使います。

**ステップ 1: インストール**

```bash
npm install tailwindcss @tailwindcss/cli
```

**ステップ 2: 入力 CSS を用意する**

```css
/* src/input.css */
@import "tailwindcss";
```

**ステップ 3: ビルド（ウォッチ）する**

入力ファイルを指定し、出力先を決めて実行します。`--watch` を付けると、ファイルの変更を監視して自動で再ビルドします。

```bash
npx @tailwindcss/cli -i ./src/input.css -o ./src/output.css --watch
```

生成された `output.css` を HTML から読み込めば完成です。

```html
<link href="./output.css" rel="stylesheet">
```

CLI は仕組みが分かりやすいので、「Tailwind が実際に何をしているか」を理解する学習用途にも向いています。

## 7.6 `@import "tailwindcss"` と最小の CSS エントリ

ここまでのどの経路でも、CSS エントリは次の 1 行から始まります。

```css
@import "tailwindcss";
```

第4章で見たとおり、この 1 行が theme / base / components / utilities の各レイヤーを読み込みます。あなた独自のスタイルやテーマは、この下に足していきます。

```css
@import "tailwindcss";

/* テーマのカスタマイズ（第5章） */
@theme {
  --color-brand: oklch(0.45 0.24 264);
}

/* 必要なら自前のスタイルやカスタムユーティリティ（第22章・第26章） */
```

この「`@import` してから、必要なものを足す」という形が、v4 のすべてのプロジェクトの出発点になります。

## 7.7 v3 からの移行ツール（`@tailwindcss/upgrade`）の概要

既存の v3 プロジェクトを v4 に上げるなら、公式の移行ツールが用意されています。

```bash
npx @tailwindcss/upgrade
```

このツールは、面倒な変換の大部分を自動でやってくれます。具体的には、

- `@tailwind base; @tailwind components; @tailwind utilities;` を `@import "tailwindcss";` に置き換える
- `tailwind.config.js` の内容を、可能な範囲で CSS の `@theme` に移す
- 名前が変わったユーティリティを書き換える（例: `shadow-sm` → `shadow-xs`、`outline-none` → `outline-hidden`）

といったことを行います。実行には Node.js 20 以上が必要です。なお、v4 はモダンブラウザ（Safari 16.4+ / Chrome 111+ / Firefox 128+ など）を対象としているため、古いブラウザを手厚くサポートする必要があるプロジェクトは v3.4 に留まる判断もありえます。移行の詳細や破壊的変更は第29章でまとめて扱います。

## 7.8 よくある初回トラブル（クラスが効かない・検出されない）

最後に、導入直後にハマりがちな問題と対処をまとめます。多くは第2部の仕組みを思い出せば解決できます。

**(1) クラスを書いたのにスタイルが効かない**

最も多い原因は、**クラス名を動的に組み立てている**ことです。第4章で見たとおり、Tailwind はソースを「ただのテキスト」として走査し、完全なクラス名の文字列だけを拾います。

```jsx
// NG: text-${color} は文字列として検出されない
<div className={`text-${color}-600`} />

// OK: 完全なクラス名で書く
<div className={color === 'error' ? 'text-red-600' : 'text-green-600'} />
```

この落とし穴は第27章でも改めて扱います。

**(2) 一部のファイルのクラスだけ効かない**

自動コンテンツ検出の対象外（`.gitignore` 配下、`node_modules` 内のライブラリなど）にあるファイルのクラスは拾われません。その場合は CSS 側で `@source` を足して、走査対象に含めます（第4章）。

```css
@import "tailwindcss";
@source "../node_modules/my-ui-library";
```

**(3) そもそも何も効かない**

CSS エントリに `@import "tailwindcss";` を書き忘れている、あるいはその CSS をページから読み込んでいない、というケースです。また、古い記事を見て `@tailwind base; ...` と書いてしまうのも v4 では動きません。`@import "tailwindcss";` に直してください。

**(4) ビルドは通るが、変更が反映されない**

ウォッチ（監視）プロセスが動いていない可能性があります。`npm run dev` や CLI の `--watch`、Rails なら `bin/dev`（次章）が起動しているか確認します。

## 参考資料

* Tailwind CSS Docs — Installation: using Vite: https://tailwindcss.com/docs/installation/using-vite
* Tailwind CSS Docs — Installation: using PostCSS: https://tailwindcss.com/docs/installation/using-postcss
* Tailwind CSS Docs — Installation: Tailwind CLI: https://tailwindcss.com/docs/installation/tailwind-cli
* Tailwind CSS Docs — Play CDN: https://tailwindcss.com/docs/installation/play-cdn
* Tailwind CSS Docs — Upgrade guide（v3 → v4）: https://tailwindcss.com/docs/upgrade-guide
* Tailwind Play: https://play.tailwindcss.com/

---

# 第8章 フレームワークごとの導入

## 8.1 導入差が生まれる理由

第7章で「導入経路は土台によって変わる」と述べました。その理由をはっきりさせておきましょう。

Tailwind がやることは、突き詰めれば「CSS をビルドして 1 枚のスタイルシートを出力する」ことです。問題は、**そのビルドを誰が回すか**がフレームワークごとに違う、という点です。

- React・Vue・Svelte などは、たいてい **Vite** がビルドを回します → Vite プラグイン経路（第7章）。
- Next.js は内部で **PostCSS** を使います → PostCSS プラグイン経路。
- Rails は **独自のアセットパイプライン**（Propshaft など）を持っています → Rails 専用の gem 経路。

つまり「Tailwind の入れ方の違い」は、ほとんど「そのフレームワークが CSS をどうビルドするかの違い」です。この視点を持つと、以下の各手順がなぜそうなっているのか腑に落ちます。それでは、本書が最重点とする Rails から詳しく見ていきます。

## 8.2 Rails 詳説 ①: `tailwindcss-rails` gem と最短セットアップ

Rails で Tailwind を使う最も標準的な方法は、**`tailwindcss-rails`** という gem を使うことです。これは Tailwind Labs ではなく Rails チームがメンテナンスしている公式 gem で、Tailwind 公式の Rails ガイドからもこの gem が案内されています。

最大の特徴は、**Node.js を必要としない**ことです。`tailwindcss-rails` は `tailwindcss-ruby` gem を通じて、Tailwind の**スタンドアロン実行ファイル**（単体で動く CLI のバイナリ）を取得して使います。そのため、`npm` も `package.json` も `node_modules` も要りません。Rails らしく、Ruby の世界だけで完結します。これが、第7章で見た JavaScript 系の経路と決定的に違う点です。

セットアップは、新規 Rails アプリなら次の手順です（Rails 8 以降を前提とします）。

```bash
# 新規アプリを作る
rails new my-project
cd my-project

# gem を追加して、インストールタスクを実行する
bundle add tailwindcss-rails
./bin/rails tailwindcss:install
```

`tailwindcss:install` を実行すると、必要なファイルが自動で用意されます。具体的には、入力 CSS（後述の `app/assets/tailwind/application.css`）が作られ、レイアウトに生成済み CSS を読み込む `stylesheet_link_tag` が追加され、開発用の `Procfile.dev` などが整います。

> 新規作成の段階で決めるなら、`rails new my-project --css tailwind` のように `--css tailwind` を付けると、最初から Tailwind 入りのアプリが作られます。

## 8.3 Rails 詳説 ②: 入力 CSS・出力・ウォッチ（bin/dev）の関係

ここが Rails 利用者が最も混乱しやすいところなので、「**入力 → ビルド → 出力 → 読み込み**」の流れとして整理します。

**入力 CSS の場所**

あなたが Tailwind の設定やカスタムスタイルを書くファイルは、ここです。

```
app/assets/tailwind/application.css
```

中身は v4 の作法どおり、`@import "tailwindcss";` から始まります。

```css
@import "tailwindcss";

@theme {
  --color-brand: oklch(0.45 0.24 264);
}
```

> v3 を知っている人へ: このファイルの場所は **v4 で変わりました**。v3（gem の v3 系）では `app/assets/stylesheets/application.tailwind.css` でしたが、v4 では `app/assets/tailwind/application.css` です。古い記事のパスのままだと動かないので注意してください。

**ビルドと出力**

`tailwindcss-rails` は、上の入力 CSS を読んで、生成済みの CSS を `app/assets/builds/` に出力します。Rails のアセットパイプライン（Propshaft）は、その出力済み CSS を配信します。ビルドを手動で 1 回だけ実行したいときは次のコマンドです。

```bash
./bin/rails tailwindcss:build
```

**ウォッチ（開発中の自動再ビルド）**

開発中は、CSS を書き換えるたびに手でビルドするのは現実的ではありません。そこで「ファイルの変更を監視して自動で再ビルドする」ウォッチを使います。方法は主に 3 つあります。

1. **`bin/dev`（最も一般的）**: Rails サーバーと Tailwind のウォッチを**同時に**起動してくれるコマンドです。内部では `Procfile.dev` に書かれた複数プロセス（Web サーバー＋ `tailwindcss:watch`）を Foreman などでまとめて動かしています。開発時はこれを使うのが基本です。

   ```bash
   ./bin/dev
   ```

2. **`tailwindcss:watch` を単体で動かす**: ウォッチだけを別プロセスで動かしたいときに使います。

   ```bash
   ./bin/rails tailwindcss:watch
   ```

3. **Puma プラグインで `rails server` に統合する**: `bin/dev` を使わず、`rails server` の起動に合わせてウォッチを走らせる構成も用意されています。

整理すると、**「`app/assets/tailwind/application.css` に書く → `bin/dev` が変更を監視して `app/assets/builds/` に出力 → Propshaft がそれを配信する」**という一本道です。この流れさえ押さえれば、Rails での Tailwind は迷いません。

## 8.4 Rails 詳説 ③: Propshaft / Sprockets と cssbundling 経路の使い分け

Rails には CSS の扱い方が複数あり、ここも混乱の元なので関係を整理します。

**アセットパイプライン: Propshaft と Sprockets**

アセットパイプラインは「CSS や画像などの静的ファイルを配信する仕組み」です。Rails 8 以降の既定は **Propshaft** という軽量な仕組みで、古くからの **Sprockets** に代わるものです。`tailwindcss-rails` はどちらとも組み合わせて動きますが、新規プロジェクトでは Propshaft が標準だと考えてよいでしょう。重要なのは、**Tailwind 自体のビルドは gem（スタンドアロン実行ファイル）が行い、その成果物をアセットパイプラインが配信する**、という分担関係です。

**もう 1 つの選択肢: `cssbundling-rails`**

`tailwindcss-rails` とは別に、**`cssbundling-rails`** という gem を使う道もあります。これは Node.js を使い、esbuild や Vite などの JavaScript ツールで CSS をバンドルする方式です。

両者の使い分けの目安は次のとおりです。

| | `tailwindcss-rails` | `cssbundling-rails` |
| --- | --- | --- |
| Node.js | **不要** | 必要 |
| 仕組み | スタンドアロン実行ファイル | esbuild / Vite などでバンドル |
| 向いているケース | Tailwind だけ使えればよい。構成をシンプルにしたい | すでに Node ベースの JS ビルドがあり、CSS も同じ流れに乗せたい |

**多くの Rails プロジェクトでは、Node 不要でシンプルな `tailwindcss-rails` が第一候補**です。フロントエンドを JavaScript ツールで本格的にバンドルしている場合に限り、`cssbundling-rails` を検討する、という順序がおすすめです。

## 8.5 Rails 詳説 ④: importmap 構成での注意点と Turbo との相性

最後に、JavaScript の管理方式である **importmap** との関係です。

ここで誤解を解いておきます。**importmap は JavaScript を管理する仕組みであって、CSS には関与しません**。Rails 8 の既定は「JS は importmap、CSS は `tailwindcss-rails`」という組み合わせで、両者は別々に動きます。つまり「importmap を使っているから Tailwind が入れにくい」ということはなく、`tailwindcss-rails` がそのまま使えます。むしろ「Node 不要の importmap ＋ Node 不要の `tailwindcss-rails`」は、**Rails らしいシンプルな構成**として相性が良い組み合わせです。

**Turbo との相性**

Rails の標準フロントエンドである **Turbo**（Hotwire）は、ページ遷移を高速化するために、ページ全体を読み込み直さず差し替えます。このとき気をつけたいのは、Tailwind の CSS は**ビルド時にすべて生成されている**という点です。第4章で見たとおり、Tailwind はソースを静的に走査して CSS を作るので、Turbo が後から差し込む HTML に使われているクラスも、**そのクラスがソースコードのどこかに文字列として存在していれば**、ちゃんとスタイルが当たります。逆に言えば、ここでも「動的に組み立てたクラス名は生成されない」という原則は同じです。Turbo で部分更新される画面でも、クラス名は完全な文字列で書く、という基本を守れば問題は起きません。

## 8.6 React（Vite）での導入

ここからは JavaScript 系フレームワークです。まず Vite で作った React プロジェクトは、第7章の Vite 経路がそのまま使えます。

```bash
npm install tailwindcss @tailwindcss/vite
```

```ts
// vite.config.ts
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
})
```

```css
/* src/index.css */
@import "tailwindcss";
```

この CSS をエントリ（`main.tsx` など）でインポートすれば完了です。JSX では `class` ではなく `className` を使う点だけ注意してください。

```tsx
export default function App() {
  return <h1 className="text-3xl font-bold underline">Hello world!</h1>
}
```

## 8.7 Next.js（App Router）での導入と注意点

Next.js は内部で PostCSS を使うため、第7章の PostCSS 経路を使います。

```bash
npm install tailwindcss @tailwindcss/postcss postcss
```

```js
// postcss.config.mjs
const config = {
  plugins: {
    "@tailwindcss/postcss": {},
  },
}
export default config
```

```css
/* app/globals.css */
@import "tailwindcss";
```

この `globals.css` を `app/layout.tsx` でインポートします（App Router の標準構成）。

```tsx
// app/layout.tsx
import "./globals.css"

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ja">
      <body>{children}</body>
    </html>
  )
}
```

**注意点**: Next.js の App Router では、コンポーネントがサーバーコンポーネントとして動くことがあります。スタイリングの観点では、第27章で扱う「クラス名を動的に組み立てない」原則がここでも重要です。プロパティから `bg-${color}` のように組み立てると検出されないため、完全なクラス名へマッピングして渡します（詳細は第25章）。

## 8.8 Vue / Nuxt での導入

Vue（Vite ベース）は React と同じく Vite 経路です。`@tailwindcss/vite` を `vite.config.ts` に登録し、CSS で `@import "tailwindcss";` を読み込みます。

Nuxt は Vite を内部で使っているため、Nuxt の設定に Vite プラグインを組み込む形になります。具体的な組み込み方は公式の Nuxt ガイドに沿うのが確実です（参考資料のリンク先）。テンプレート（`.vue` ファイル）に書いたクラスは、自動コンテンツ検出の対象になります。

## 8.9 Svelte / SvelteKit での導入

Svelte / SvelteKit も Vite ベースなので、Vite 経路を使います。`@tailwindcss/vite` を Vite の設定に追加し、アプリのグローバル CSS で `@import "tailwindcss";` を読み込みます。`.svelte` ファイル内のクラスは自動で検出されます。詳細な配線は公式の SvelteKit ガイドが最新です。

## 8.10 Astro での導入

Astro も内部で Vite を使うため、`@tailwindcss/vite` を Astro の設定（`astro.config.mjs`）の Vite プラグインとして組み込み、グローバル CSS で `@import "tailwindcss";` を読み込みます。Astro は公式の導入ガイドが用意されているので、最新の手順はそちらに従ってください（参考資料）。

## 8.11 早見表（各環境の設定ファイル・エントリ・ウォッチ方法）

最後に、本章の内容を 1 枚にまとめます。

| 環境 | 経路 | 設定を書く場所 | CSS エントリ | 開発時の起動 |
| --- | --- | --- | --- | --- |
| Rails | gem（Node 不要） | `app/assets/tailwind/application.css` | 同左（`@import`） | `./bin/dev` |
| React (Vite) | Vite プラグイン | `vite.config.ts` | `src/index.css` | `npm run dev` |
| Next.js | PostCSS プラグイン | `postcss.config.mjs` | `app/globals.css` | `npm run dev` |
| Vue / Nuxt | Vite プラグイン | Vite/Nuxt 設定 | グローバル CSS | `npm run dev` |
| Svelte / SvelteKit | Vite プラグイン | Vite 設定 | グローバル CSS | `npm run dev` |
| Astro | Vite プラグイン | `astro.config.mjs` | グローバル CSS | `npm run dev` |

どの環境でも、CSS エントリが `@import "tailwindcss";` で始まる点と、自動コンテンツ検出が効く点は共通です。違うのは「ビルドを誰が回すか」だけ——この章の出発点に戻ってきました。

## 参考資料

* Tailwind CSS Docs — Framework guides（各フレームワークの一覧）: https://tailwindcss.com/docs/installation/framework-guides
* Tailwind CSS Docs — Ruby on Rails ガイド: https://tailwindcss.com/docs/installation/framework-guides/ruby-on-rails
* tailwindcss-rails（GitHub・README / releases）: https://github.com/rails/tailwindcss-rails
* Tailwind CSS Docs — Next.js ガイド: https://tailwindcss.com/docs/installation/framework-guides/nextjs
* Tailwind CSS Docs — Nuxt ガイド: https://tailwindcss.com/docs/installation/framework-guides/nuxt
* Tailwind CSS Docs — SvelteKit ガイド: https://tailwindcss.com/docs/installation/framework-guides/sveltekit
* Tailwind CSS Docs — Astro ガイド: https://tailwindcss.com/docs/installation/framework-guides/astro

---

# 第9章 エディタ環境

導入が終わったら、開発を快適にするエディタ環境を整えます。Tailwind は「クラスを大量に書く」スタイルなので、補完や整形といった支援があるかどうかで、開発体験が大きく変わります。ここを整えるかどうかは、Tailwind を「面倒」と感じるか「快適」と感じるかの分かれ目になります。

## 9.1 VS Code: Tailwind CSS IntelliSense

VS Code を使うなら、公式拡張 **Tailwind CSS IntelliSense** は必ず入れましょう。主な機能は次のとおりです。

- **オートコンプリート**: `bg-` まで打つと候補が一覧で出ます。膨大なユーティリティを暗記する必要がなくなります。テーマで定義した独自の色やスケールも候補に出ます。
- **ホバープレビュー**: クラスにマウスを乗せると、それが生成する実際の CSS が表示されます。第2部で学んだ「クラス → CSS」の対応を、その場で確認できます。
- **色プレビュー**: `bg-red-500` のような色クラスの横に、実際の色が表示されます。
- **構文ハイライト・リンティング**: 存在しないクラスや、競合するクラス（後述）を指摘してくれます。

この拡張は、補完だけでなく**「間違いに早く気づく」**ためにも効きます。

## 9.2 クラス順の自動整形: `prettier-plugin-tailwindcss`

ユーティリティを並べていると、書く人によってクラスの順番がバラバラになります。`p-4 flex bg-white` と書く人もいれば `flex bg-white p-4` と書く人もいます。これはレビューを読みにくくし、無用な差分を生みます。

公式の Prettier プラグイン **`prettier-plugin-tailwindcss`** を使うと、保存時にクラスを**推奨される一定の順序に自動で並べ替え**てくれます。

```bash
npm install -D prettier prettier-plugin-tailwindcss
```

```js
// .prettierrc（または prettier.config.js）
export default {
  plugins: ["prettier-plugin-tailwindcss"],
}
```

チーム全員が同じ順序になるため、「クラスの並べ方」で悩む時間と、レビューでの無駄な指摘がなくなります。これはチーム開発でとくに価値が大きい設定です（第26章でも触れます）。

> 補足: このプラグインは Prettier のものなので、Node を使わない Rails プロジェクトでは、整形のためだけに Prettier を導入するか判断が必要です。「整形のためだけに Node を入れたくない」なら、後述の IntelliSense によるクラス並び替え支援や、チームの命名ルールで運用する方法もあります。

## 9.3 重複・衝突の検知

Tailwind CSS IntelliSense は、**衝突するクラス**も警告してくれます。たとえば `p-4` と `p-8` を同じ要素に書くと、片方は無意味になります（第4章の「衝突の解決」）。こうした「効かないクラス」を書いてしまったとき、エディタ上で気づけるのは大きな助けです。動的にクラスを組み立てる React などでは、最終的に第23章で扱う `tailwind-merge` のような仕組みで衝突を解消しますが、まずはエディタの警告で早期に気づくのが第一歩です。

## 9.4 ディレクティブの「unknown at-rule」警告への対処

Tailwind は `@theme`・`@source`・`@utility`・`@custom-variant` といった独自のディレクティブを使います（第2部）。ところが、エディタの標準的な CSS チェッカーはこれらを知らないため、「**unknown at-rule（未知のアットルール）**」という警告を出すことがあります。これは Tailwind 側の誤りではなく、エディタが新しい構文を知らないだけです。

対処は次のとおりです。

- **Tailwind CSS IntelliSense を使う**: この拡張には、Tailwind の独自ディレクティブをすべて理解する専用の言語モードが含まれており、CSS ファイルを Tailwind の言語モードとして扱うことで警告が消えます。
- **標準の CSS リンティングを調整する**: エディタが厳しく構文チェックしている場合は、その CSS の検証を無効化・緩和する設定を行います。

「赤い波線が出るが実害はない」状態を放置すると、本当のエラーを見逃しやすくなります。早めに解消しておきましょう。

## 9.5 JetBrains 系・Neovim 等での対応状況

Tailwind の支援は VS Code だけのものではありません。公式の言語サーバー（IntelliSense の中核）をベースに、さまざまなエディタが対応しています。

- **JetBrains 系（RubyMine・WebStorm など）**: Tailwind の補完に対応しています。Rails 開発で RubyMine を使う人も、補完の恩恵を受けられます。
- **Cursor・Zed**: これらのエディタでも Tailwind の支援が利用できます。
- **Neovim など**: 言語サーバーを介して補完を有効にできます。

公式ドキュメントの Editor setup ページに、対応エディタと設定方法がまとまっています（参考資料）。

## 9.6 補完を効かせる設定

最後に、補完を最大限効かせるための小さなコツです。

- **クラスを書く場所を教える**: 文字列の中にクラスを書く独自のヘルパー（たとえば `cn(...)` や、Rails のヘルパーメソッド）を使っている場合、その関数の中でも補完が効くように、IntelliSense に「ここにもクラスが書かれる」と設定できます。
- **CSS の言語モードを合わせる**: 9.4 のとおり、Tailwind の CSS ファイルは Tailwind の言語モードとして扱うと、ディレクティブの補完と警告抑制の両方が効きます。

ここまでで、Tailwind を実プロジェクトで動かし、快適に書くための土台が整いました。次の第4部からは、いよいよ個々のユーティリティ——余白・文字・色・レイアウトなど——を、第2部で学んだ仕組みの理解の上に学んでいきます。

## 参考資料

* Tailwind CSS Docs — Editor setup（IntelliSense・言語モード・警告対処）: https://tailwindcss.com/docs/editor-setup
* Tailwind CSS IntelliSense（GitHub）: https://github.com/tailwindlabs/tailwindcss-intellisense
* prettier-plugin-tailwindcss（GitHub）: https://github.com/tailwindlabs/prettier-plugin-tailwindcss
