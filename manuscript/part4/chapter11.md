# 第11章 Typography

## 11.1 フォントサイズ・行間

文字は情報そのものです。読みやすさは、フォントサイズと**行間（line-height）**の組み合わせで決まります。素の CSS では `font-size` と `line-height` を別々に指定しますが、Tailwind では `text-*` ひとつで両方をいい感じに設定してくれます。

```html
<p class="text-base">本文（既定の行間付き）</p>
<h1 class="text-4xl">見出し</h1>
```

v4 のサイズスケールは `text-xs`（12px）から `text-9xl`（128px）まで段階的に並んでいます。`text-base`（16px）を基準に、`sm`・`lg`・`xl`・`2xl`… と広がります。**それぞれに、読みやすい既定の行間がセットで定義されている**のがポイントです。サイズを選ぶだけで、行間も自動でついてきます。

行間を自分で調整したいときは、`text-{サイズ}/{行間}` の形でまとめて書けます。

```html
<p class="text-sm/6">サイズは sm、行間は 6（= 1.5rem）</p>
<p class="text-lg/7">サイズは lg、行間は 7</p>
```

スラッシュの後ろの数字は、`--spacing` ベースの行間です。本文を読みやすくしたいときは、行間を少し広めに取るのが定石です。

## 11.2 フォントファミリ・ウェイト・字間

- **フォントファミリ**: `font-sans`・`font-serif`・`font-mono`。独自のフォントは[第5章](../part2/chapter5.md)のとおり `@theme` に `--font-display: ...` のように定義すると `font-display` が使えます。
- **ウェイト（太さ）**: `font-normal`・`font-medium`・`font-bold` など。見出しは `font-bold`、本文は `font-normal`、が基本です。
- **字間（letter-spacing）**: `tracking-tight`・`tracking-normal`・`tracking-wide`。大きな見出しは少し詰める（`tracking-tight`）と引き締まって見えます。

```html
<h1 class="font-sans text-4xl font-bold tracking-tight">締まった見出し</h1>
```

## 11.3 行揃え・装飾・変形

文字の見た目を整える基本のユーティリティです。素の CSS の `text-align`・`text-decoration`・`text-transform` にそのまま対応します。

```html
<p class="text-center underline uppercase">中央・下線・大文字</p>
```

- 行揃え: `text-left` `text-center` `text-right` `text-justify`
- 装飾: `underline` `line-through` `no-underline`
- 変形: `uppercase` `lowercase` `capitalize`

## 11.4 行数制限（line-clamp）

カードの説明文などで「3 行で切って `…` を付けたい」場面はよくあります。素の CSS では複数行の省略は書くのが面倒ですが、Tailwind では `line-clamp-*` 一発です（v4 でコア機能です）。

```html
<p class="line-clamp-3">長い説明文をここに……（3 行を超えたら省略記号で切られる）</p>
```

`line-clamp-none` で解除できます。一覧画面のカードで高さを揃えるのに重宝します。

## 11.5 リッチテキスト全体を整える `@tailwindcss/typography`

ここまでは「自分でクラスを付けられる要素」の話でした。しかし、**CMS やマークダウンが吐き出す本文 HTML** には、自分でクラスを付けられません。`<h2>` や `<p>` や `<ul>` がクラスなしで流れてきます。[第3章](../part1/chapter3.md)で「Tailwind が向かない場面」として挙げたケースです。

これを解決するのが公式プラグイン **`@tailwindcss/typography`** です。本文を囲む要素に `prose` クラスを 1 つ付けるだけで、中の見出し・段落・リスト・引用・コードなどが、まとめて読みやすく整形されます。

```html
<article class="prose">
  <!-- ここに CMS が出力した HTML が入る -->
</article>
```

`prose-lg` で全体を大きく、`dark:prose-invert` でダークモード対応もできます。ブログ記事やドキュメントページの定番です。プラグインの導入方法（v4 では CSS で `@plugin "@tailwindcss/typography";`）は[第26章](../part7/chapter26.md)で扱います。

## 11.6 実務: 本文・記事ページの型

実務では、文字まわりは「型」を決めて使い回すのが効率的です。たとえば「記事本文は `prose prose-lg`、見出しは `text-3xl font-bold tracking-tight`、補足テキストは `text-sm text-gray-500`」のように、用途ごとの組み合わせをコンポーネント（第6部）に畳み込みます。任意のフォントサイズ（`text-[15px]` など）に手を出す前に、まずスケールの中で表現できないかを考えるのが、一貫性を守るコツです。

## 参考資料

* [Tailwind CSS Docs — Font size](https://tailwindcss.com/docs/font-size)
* [Tailwind CSS Docs — Font family / weight](https://tailwindcss.com/docs/font-family)
* [Tailwind CSS Docs — Typography plugin](https://github.com/tailwindlabs/tailwindcss-typography)

