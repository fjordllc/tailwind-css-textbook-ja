# 第13章 Borders と Effects

## 13.1 ボーダー幅・色・スタイル

境界線は、要素の区切りを示す基本的な装飾です。Tailwind では幅・色・スタイルを別々のユーティリティで指定します。

```html
<div class="border border-gray-200">細い枠（既定 1px）</div>
<div class="border-2 border-dashed border-blue-500">破線の太枠</div>
```

- 幅: `border`（1px）・`border-2`・`border-4`、方向別に `border-t`・`border-x` など
- 色: `border-*`（パレット。[第12章](chapter12.md)）
- スタイル: `border-solid`・`border-dashed`・`border-dotted`

> v4 の注意: v3 では `border` だけ書くと色が既定でグレーになっていましたが、v4 では既定のボーダー色が `currentColor`（その要素の文字色）に変わりました。意図した色にするには `border-gray-200` のように色を明示します。

## 13.2 角丸

`rounded-*` で角を丸めます。値は `--radius-*` テーマから来ています。

```html
<button class="rounded-lg">やや丸い</button>
<img class="rounded-full" />  <!-- 真円・ピル形 -->
```

`rounded-sm` < `rounded-md` < `rounded-lg` < `rounded-xl` と大きくなり、`rounded-full` で完全な丸になります。一部の角だけ丸めたいときは `rounded-t-lg`（上だけ）のように方向を付けます。

## 13.3 影とリング

**影（`shadow-*`）**は、要素を浮き上がって見せます。v4 のスケールは小さい順に `shadow-2xs`・`shadow-xs`・`shadow-sm`・`shadow-md`・`shadow-lg`・`shadow-xl`・`shadow-2xl`、無しは `shadow-none` です。

```html
<div class="shadow-md">少し浮いたカード</div>
```

> v4 の重要な注意: 影のスケール名が v3 から**ずれました**。とくに気をつけたいのは、v3 の `shadow-sm` が v4 では `shadow-xs` 相当に、v3 の `shadow`（無印）が v4 では `shadow-sm` 相当になった点です。つまり古い記事で `shadow-sm` と書かれていたら、v4 では `shadow-xs` に読み替える必要があります。無印の `shadow` も互換のため残っていますが、本書（v4）では混乱を避けるため、つねに `shadow-sm` のように明示的な段階名で書きます。

**リング（`ring-*`）**は、要素の周りに「輪」を描きます。`box-shadow` を使うため、レイアウトを押し広げずに枠を足せるのが特徴で、主に**フォーカスの可視化**に使います。

```html
<button class="focus:ring-2 focus:ring-blue-500">フォーカスで青い輪</button>
```

v4 では内側に影や輪を入れる `inset-shadow-*`・`inset-ring-*` も加わりました。

## 13.4 フィルタなどの効果

要素にぼかしや明度補正などの視覚効果をかけられます。素の CSS の `filter` に対応します。

```html
<img class="blur-sm brightness-110" />
<div class="opacity-50">半透明</div>
```

- `blur-*` … ぼかし
- `brightness-*` / `contrast-*` … 明度・コントラスト
- `opacity-*` … 不透明度（要素全体）
- `backdrop-blur-*` … 背景側をぼかす（すりガラス効果）

## 13.5 背景画像・サイズ・位置

背景画像まわりは、`bg-cover`（領域を覆う）・`bg-center`（中央寄せ）・`bg-no-repeat` などで制御します。画像 URL 自体は任意の値かインラインスタイルで渡すのが一般的です。

```html
<div class="bg-cover bg-center" style="background-image: url(/hero.jpg)">...</div>
```

## 13.6 実務: 立体感とフォーカスリング

実務でのコツは 2 つです。1 つは**影を盛りすぎない**こと。`shadow-sm`〜`shadow-md` を基準にし、`shadow-2xl` は本当に浮かせたい要素だけに使うと、画面が落ち着きます。もう 1 つは、**フォーカスリングを消さない**こと。デザイン上の理由で `outline-none` にする場合は、必ず `focus:ring-2` などで代わりの可視化を用意します。これはアクセシビリティの必須事項です（[第21章](../part5/chapter21.md)）。

## 参考資料

* [Tailwind CSS Docs — Border width / color](https://tailwindcss.com/docs/border-width)
* [Tailwind CSS Docs — Box shadow](https://tailwindcss.com/docs/box-shadow)
* [Tailwind CSS Docs — Filter（filter プロパティ本体）](https://tailwindcss.com/docs/filter)
* [Tailwind CSS Docs — blur（`blur-*`）](https://tailwindcss.com/docs/filter-blur)
* [Tailwind CSS Docs — brightness（`brightness-*`）](https://tailwindcss.com/docs/filter-brightness)
* [Tailwind CSS Docs — backdrop-blur（`backdrop-blur-*`）](https://tailwindcss.com/docs/backdrop-filter-blur)

