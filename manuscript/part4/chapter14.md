# 第14章 Layout

## 14.1 display

レイアウトの出発点は `display` です。要素を「どう積むか」を決めます。

```html
<span class="block">ブロックにする</span>
<div class="inline-block">並べられるブロック</div>
<div class="hidden md:block">狭い画面では消す</div>
```

- `block` / `inline` / `inline-block`
- `flex` / `grid` … 次章以降の主役
- `hidden` … `display: none`（要素を消す）

`hidden md:block` のように、レスポンシブと組み合わせて「特定の画面幅だけ表示」を作るのは頻出パターンです（[第17章](../part5/chapter17.md)）。

## 14.2 position と重なり

`position` で要素の配置基準を決め、`top/right/bottom/left`（まとめて `inset-*`）でずらします。重なり順は `z-*` です。

```html
<div class="relative">
  <span class="absolute top-2 right-2">バッジ</span>
</div>
```

`relative` を付けた親を基準に、`absolute` の子を四隅へ配置する——この組み合わせが、バッジや閉じるボタンの定番です。`sticky top-0` でスクロール追従ヘッダーも作れます。

## 14.3 サイズ（width / height / size）

幅・高さの指定です。`w-*` / `h-*` は[第10章](chapter10.md)の `--spacing` スケールを共有します。さらに割合・画面基準の値も使えます。

```html
<div class="w-64">幅 = spacing 64</div>
<div class="w-1/2">親の 50%</div>
<div class="w-full">親いっぱい</div>
<div class="h-dvh">画面の高さ（動的ビューポート）</div>
```

- 数値: `w-64`（`calc(var(--spacing) * 64)`）
- 分数: `w-1/2`・`w-1/3`（親に対する割合）
- 特殊: `w-full`(100%)・`w-screen`(100vw)・`w-dvw`/`h-dvh`（モバイルのアドレスバーを考慮した動的ビューポート）
- 制限: `min-w-*`・`max-w-*`（最小・最大）

v4 で便利なのが **`size-*`** です。幅と高さを**同時に**設定します。アイコンのように正方形にしたい要素で重宝します。

```html
<svg class="size-6">...</svg>  <!-- w-6 h-6 と同じ -->
```

## 14.4 overflow と object

はみ出しの扱いは `overflow-*` です。`overflow-hidden`（隠す）・`overflow-auto`（必要なときスクロール）・`overflow-x-auto`（横だけ）など。画像をボックスに収める比率は `object-cover`（覆う）・`object-contain`（収める）で制御します。

```html
<img class="h-48 w-full object-cover" />  <!-- 領域に合わせて切り抜く -->
```

## 14.5 コンテナと Container Queries

「中身を読みやすい幅で中央に収めたい」ときは `mx-auto max-w-*` の組み合わせが基本です。

```html
<div class="mx-auto max-w-3xl px-4">読みやすい幅の本文</div>
```

そして v4 の目玉が **Container Queries**（コンテナクエリ）です。[第17章](../part5/chapter17.md)で扱うレスポンシブは「画面幅」に反応しますが、コンテナクエリは「**親要素の幅**」に反応します。サイドバーの中でもメイン領域の中でも、置かれた場所の幅に応じてレイアウトを変えられます。

```html
<div class="@container">
  <div class="flex flex-col @md:flex-row">
    <!-- 親(@container)が md 幅以上になったら横並びに -->
  </div>
</div>
```

親に `@container` を付け、子に `@md:` のような接頭辞を付けます。これにより、コンポーネントが「どの画面か」ではなく「**自分が今どれだけの幅を与えられているか**」で自律的にレイアウトを決められます。再利用しやすいコンポーネントを作るうえで強力な機能です。

## 14.6 実務: ページの骨格を組む手順

実務では、いきなり細部を作らず、**外側から内側へ**組むと崩れにくくなります。おすすめの順序は、(1) ページ全体の最大幅と中央寄せ（`mx-auto max-w-*`）→ (2) 大きな領域分け（Flex / Grid、[第15章](chapter15.md)・[第16章](chapter16.md)）→ (3) 各領域の余白（[第10章](chapter10.md)）→ (4) 中身の装飾、です。骨格が決まる前から `absolute` や任意のサイズで微調整を始めると、後で破綻しがちです。

## 参考資料

* [Tailwind CSS Docs — Display](https://tailwindcss.com/docs/display)
* [Tailwind CSS Docs — Width / Size](https://tailwindcss.com/docs/width)
* [Tailwind CSS Docs — Responsive design（Container queries）](https://tailwindcss.com/docs/responsive-design)

