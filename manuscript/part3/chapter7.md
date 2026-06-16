# 第7章 Tailwind CSS の導入方法

## 7.1 導入経路の地図

Tailwind の導入経路は、大きく次の 4 つです。最初にこの地図を持っておくと、自分が何を選んでいるのかを見失いません。

| 経路 | 何のためか | 向いている人 |
| --- | --- | --- |
| **Play CDN** | ビルドなしでブラウザだけで試す | とにかく今すぐ試したい・学習用 |
| **Vite プラグイン** | Vite を使うプロジェクトに組み込む | React / Vue / Svelte など Vite ベースのほとんど |
| **PostCSS プラグイン** | PostCSS を使うビルドに組み込む | Next.js や、PostCSS 前提のツール |
| **Tailwind CLI** | Tailwind 単体で CSS をビルドする | ビルドツールを増やしたくない・小規模 |

このうち、本番プロジェクトで主役になるのは **Vite プラグイン**です。v4 で最も手軽かつ高速な経路として公式が推奨しています。Rails のような独自のアセットパイプラインを持つフレームワークは、これとは別に専用の経路（gem）が用意されています（[第8章](chapter8.md)）。

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

ファイルすら用意したくないなら、公式のオンライン環境 **Tailwind Play**（<https://play.tailwindcss.com/>）が便利です。左に HTML、右にプレビューが出て、生成された CSS も確認できます。第2部で学んだ「どんな CSS が生成されるか」を確かめるのにも最適です。

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

> v3 を知っている人へ: v3 では `postcss.config.js` に `tailwindcss` と `autoprefixer` を並べて書くのが定番でした。v4 では、ベンダープレフィックス付与などを内蔵の Lightning CSS が担うため（[第4章](../part2/chapter4.md)）、`autoprefixer` を別途書く必要はありません。

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

[第4章](../part2/chapter4.md)で見たとおり、この 1 行が theme / base / components / utilities の各レイヤーを読み込みます。あなた独自のスタイルやテーマは、この下に足していきます。

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

といったことを行います。実行には Node.js 20 以上が必要です。なお、v4 はモダンブラウザ（Safari 16.4+ / Chrome 111+ / Firefox 128+ など）を対象としているため、古いブラウザを手厚くサポートする必要があるプロジェクトは v3.4 に留まる判断もありえます。移行の詳細や破壊的変更は[第29章](../part8/chapter29.md)でまとめて扱います。

## 7.8 よくある初回トラブル（クラスが効かない・検出されない）

最後に、導入直後にハマりがちな問題と対処をまとめます。多くは第2部の仕組みを思い出せば解決できます。

**(1) クラスを書いたのにスタイルが効かない**

最も多い原因は、**クラス名を動的に組み立てている**ことです。[第4章](../part2/chapter4.md)で見たとおり、Tailwind はソースを「ただのテキスト」として走査し、完全なクラス名の文字列だけを拾います。

```jsx
// NG: text-${color} は文字列として検出されない
<div className={`text-${color}-600`} />

// OK: 完全なクラス名で書く
<div className={color === 'error' ? 'text-red-600' : 'text-green-600'} />
```

この落とし穴は[第27章](../part7/chapter27.md)でも改めて扱います。

**(2) 一部のファイルのクラスだけ効かない**

自動コンテンツ検出の対象外（`.gitignore` 配下、`node_modules` 内のライブラリなど）にあるファイルのクラスは拾われません。その場合は CSS 側で `@source` を足して、走査対象に含めます（[第4章](../part2/chapter4.md)）。

```css
@import "tailwindcss";
@source "../node_modules/my-ui-library";
```

**(3) そもそも何も効かない**

CSS エントリに `@import "tailwindcss";` を書き忘れている、あるいはその CSS をページから読み込んでいない、というケースです。また、古い記事を見て `@tailwind base; ...` と書いてしまうのも v4 では動きません。`@import "tailwindcss";` に直してください。

**(4) ビルドは通るが、変更が反映されない**

ウォッチ（監視）プロセスが動いていない可能性があります。`npm run dev` や CLI の `--watch`、Rails なら `bin/dev`（次章）が起動しているか確認します。

## 参考資料

* [Tailwind CSS Docs — Installation: using Vite](https://tailwindcss.com/docs/installation/using-vite)
* [Tailwind CSS Docs — Installation: using PostCSS](https://tailwindcss.com/docs/installation/using-postcss)
* [Tailwind CSS Docs — Installation: Tailwind CLI](https://tailwindcss.com/docs/installation/tailwind-cli)
* [Tailwind CSS Docs — Play CDN](https://tailwindcss.com/docs/installation/play-cdn)
* [Tailwind CSS Docs — Upgrade guide（v3 → v4）](https://tailwindcss.com/docs/upgrade-guide)
* [Tailwind Play](https://play.tailwindcss.com/)

