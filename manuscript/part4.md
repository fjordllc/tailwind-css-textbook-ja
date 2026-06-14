# 第4部 Utility Class を使う

ここからは、いよいよ個々のユーティリティクラスを学びます。ただし本書は**リファレンス（クラス一覧表）ではありません**。クラスの全網羅は公式ドキュメントに任せ、本書は次の 3 つを各章で一貫して扱います。

1. **素の CSS ではどう考えるか**（前提となる CSS の考え方）
2. **Tailwind ではどう対応するか**（クラスの形と、生成される CSS）
3. **実務でどう使い分けるか**（一貫性を保つ判断、任意の値の乱用を避ける勘所）

そして、第2部で学んだ仕組み——`--spacing` を基準にした動的計算、oklch の色、任意の値、container query——に何度も立ち返ります。クラスを暗記するのではなく、「この値はテーマのどこから来ているのか」を理解することが、第4部のゴールです。

> **各章共通の注意（任意の値について）**: Tailwind は `p-[13px]` のように角かっこで任意の値を書けます（第4章）。これは「スケールにない値がどうしても必要なとき」の便利な逃げ道ですが、多用するとスケールという制約（第3章）が崩れ、デザインの一貫性が失われます。各章で「ここぞ」という使いどころと、避けるべき乱用を示します。

---

# 第10章 Spacing

## 10.1 spacing スケールの思想

余白は、デザインの印象を最も大きく左右する要素のひとつです。素の CSS では `padding: 16px` のように好きな値を書けますが、第3章で見たとおり、この自由さがチーム開発では余白のばらつきを生みます。

Tailwind は、余白を**スケール（段階的な値の並び）**として提供します。そして v4 では、このスケールが第5章で見た `--spacing` というたった 1 つの基準値から計算されます。

```css
/* p-4 が生成する CSS（簡略化） */
.p-4 { padding: calc(var(--spacing) * 4); }
```

`--spacing` の既定値は `0.25rem`（＝ 4px）です。つまり `p-4` は `0.25rem × 4 = 1rem`（16px）になります。数字の `4` が「4px」という意味ではなく、「基準値の 4 倍」だという点が重要です。この仕組みのおかげで、`p-4`・`p-6`・`p-8` のように飛び飛びの値が自然と 4px 刻みで揃い、誰が書いても余白の歩幅がそろいます。

## 10.2 padding

要素の**内側**の余白が padding です。クラスの形は方向ごとに分かれています。

```html
<div class="p-4">全方向に内側余白</div>
<div class="px-6 py-3">左右に 6、上下に 3</div>
<div class="pt-8">上だけ 8</div>
```

- `p-*` … 全方向（`padding`）
- `px-*` / `py-*` … 横（`padding-inline`）/ 縦（`padding-block`）
- `pt-*` `pr-*` `pb-*` `pl-*` … 上下左右の個別

v4 では、横方向が `padding-left/right` ではなく **`padding-inline`** という論理プロパティで生成される点も覚えておきましょう。これは「文字の流れる方向」に沿った指定で、日本語・英語のような左横書きでは左右に対応しますが、アラビア語のような右横書き（RTL）では自動で左右が反転します。多言語対応を見据えた設計です。文字方向に合わせて始端・終端を指定したいときは、論理プロパティ版の `ps-*`（始端）・`pe-*`（終端）も使えます。

なお、padding に**マイナスの値はありません**。内側余白を負にすることはできないからです。

## 10.3 margin と負のマージン

要素の**外側**の余白が margin です。形は padding と同じく `m-*` `mx-*` `mt-*` などです。padding と違い、**margin にはマイナスがあります**。

```html
<div class="mt-6">上に外側余白</div>
<div class="-mt-2">上に負のマージン（上に食い込ませる）</div>
```

`-mt-2` のように先頭に `-` を付けると負のマージンになります。重なりを作る、親の padding を打ち消す、といった用途で使います。ただし負のマージンはレイアウトを直感に反して崩しやすいので、多用は禁物です。「重ねたい」意図が明確なときだけに留めましょう。

## 10.4 要素間の間隔: `space-x/y-*` と `gap-*` の違い

「**子要素どうしの間隔**」を空けたい場面はとても多くあります。Tailwind には方法が 2 つあり、使い分けがよく問われます。

**`gap-*`（推奨）**: Flexbox や Grid のコンテナに付けて、子の間の溝を空けます。

```html
<div class="flex gap-4">
  <button>保存</button>
  <button>キャンセル</button>
</div>
```

**`space-x-*` / `space-y-*`**: 隣り合う子要素の間に、片側マージンで間隔を入れます（隣接する要素どうしの間だけに溝ができるイメージです）。

```html
<div class="space-y-4">
  <p>段落1</p>
  <p>段落2</p>
</div>
```

**どちらを使うべきか。** 現在は **`gap-*` が第一候補**です。`gap` は CSS Grid / Flexbox の正式な機能で、要素を折り返したときも間隔が正しく保たれ、子要素を入れ替えても破綻しません。`space-*` はマージンを使うため、子の順序や折り返しで意図せぬ余白が出ることがあります。Flex/Grid コンテナなら `gap`、それ以外でやむを得ないときだけ `space-*`、と覚えておけば十分です。

## 10.5 任意の値とスケール外の値

どうしてもスケールにない余白が必要なら、任意の値が使えます。

```html
<div class="p-[18px]">スケールにない 18px</div>
```

ただし、これを安易に使うのは黄色信号です。`p-[18px]` が現れるのは、たいてい「デザインがスケールに沿っていない」サインです。本当にその値でなければならないのか、`p-4`（16px）や `p-5`（20px）で代用できないかを先に疑ってください。どうしても必要なら、**それをテーマ変数として定義し、名前を付けて再利用する**（第5章・第26章）方が、1 回限りの `[18px]` を散らすより健全です。

## 10.6 実務: 一貫した余白設計とアンチパターン

実務では、「余白の値を決める」のではなく「**余白の歩幅を決める**」と考えると、設計がぶれません。たとえば「セクション間は `py-16`、カード内は `p-6`、要素間は `gap-4`」のように、役割ごとに使う値をチームで決めておきます。

避けたいアンチパターンは、**画面ごとに余白がバラバラ**になることです。`p-[13px]`・`mt-[7px]`・`gap-[5px]` のような任意の値が散らばり始めたら、スケールから外れた設計の崩れを疑うべきサインです（詳しくは第27章）。

## 参考資料

* Tailwind CSS Docs — Padding: https://tailwindcss.com/docs/padding
* Tailwind CSS Docs — Margin: https://tailwindcss.com/docs/margin
* Tailwind CSS Docs — Gap: https://tailwindcss.com/docs/gap

---

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

- **フォントファミリ**: `font-sans`・`font-serif`・`font-mono`。独自のフォントは第5章のとおり `@theme` に `--font-display: ...` のように定義すると `font-display` が使えます。
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

ここまでは「自分でクラスを付けられる要素」の話でした。しかし、**CMS やマークダウンが吐き出す本文 HTML** には、自分でクラスを付けられません。`<h2>` や `<p>` や `<ul>` がクラスなしで流れてきます。第3章で「Tailwind が向かない場面」として挙げたケースです。

これを解決するのが公式プラグイン **`@tailwindcss/typography`** です。本文を囲む要素に `prose` クラスを 1 つ付けるだけで、中の見出し・段落・リスト・引用・コードなどが、まとめて読みやすく整形されます。

```html
<article class="prose">
  <!-- ここに CMS が出力した HTML が入る -->
</article>
```

`prose-lg` で全体を大きく、`dark:prose-invert` でダークモード対応もできます。ブログ記事やドキュメントページの定番です。プラグインの導入方法（v4 では CSS で `@plugin "@tailwindcss/typography";`）は第26章で扱います。

## 11.6 実務: 本文・記事ページの型

実務では、文字まわりは「型」を決めて使い回すのが効率的です。たとえば「記事本文は `prose prose-lg`、見出しは `text-3xl font-bold tracking-tight`、補足テキストは `text-sm text-gray-500`」のように、用途ごとの組み合わせをコンポーネント（第6部）に畳み込みます。任意のフォントサイズ（`text-[15px]` など）に手を出す前に、まずスケールの中で表現できないかを考えるのが、一貫性を守るコツです。

## 参考資料

* Tailwind CSS Docs — Font size: https://tailwindcss.com/docs/font-size
* Tailwind CSS Docs — Font family / weight: https://tailwindcss.com/docs/font-family
* Tailwind CSS Docs — Typography plugin: https://github.com/tailwindlabs/tailwindcss-typography

---

# 第12章 Colors

## 12.1 デフォルトパレットと oklch / P3

色は、Tailwind が「制約のあるデザイン」を最もよく体現する領域です。素の CSS では 1,600 万色から自由に選べますが、それが第3章で見た「微妙に違う青が散らばる」問題を生みます。

Tailwind は、色を **名前 + 明度の段階**（`red-500`・`blue-600` など）のパレットとして提供します。各色に `50`（最も明るい）から `950`（最も暗い）までの段階があります。そして第5章で見たとおり、v4 のパレットは **oklch** で定義されています。

```css
--color-red-500: oklch(63.7% 0.237 25.331);
```

oklch は「見た目の明るさ」に沿った色空間なので、`500 → 600 → 700` と数字を上げると素直に暗くなり、配色を組みやすいという利点があります。実務では「oklch という新しい書き方になった」程度の認識で十分ですが、自分で色を足すときも oklch で書くと段階を揃えやすくなります。

## 12.2 背景・文字・ボーダー・リング色

同じパレットを、適用先ごとに別のクラスで使います。プレフィックスが変わるだけです。

```html
<div class="bg-blue-600 text-white border border-blue-700">
  ボタン
</div>
```

- `bg-*` … 背景色
- `text-*` … 文字色
- `border-*` … ボーダー色
- `ring-*` … リング（フォーカス枠など、第13章）
- `fill-*` / `stroke-*` … SVG の塗り / 線

## 12.3 不透明度の指定

色に透明度を加えたいとき、v4 では色クラスの後ろに `/` と数値を付けます。

```html
<div class="bg-black/50">黒の 50% 透過</div>
<div class="text-blue-600/75">青の 75%</div>
```

この `bg-black/50` は、内部的には CSS の `color-mix()`（第2部で触れたモダン CSS 機能）を使って不透明度を合成しています。`rgba` を手で書く必要がなく、パレットの色をそのまま透かせるのが便利です。

## 12.4 グラデーション

v4 ではグラデーションの表現が大きく広がりました。方向を決める `bg-linear-to-r`（右へ向かう線形グラデーション）などに、開始・中間・終了の色を重ねます。

```html
<div class="bg-linear-to-r from-cyan-500 to-blue-500">線形グラデーション</div>
```

線形だけでなく、放射状（基本形は `bg-radial`、位置を指定するなら `bg-radial-[at_25%_25%]` のように書きます）や円錐（基本形は `bg-conic`、角度を付けるなら `bg-conic-<角度>`）も使えます。装飾過多にならない範囲で、ヒーロー領域やボタンのアクセントに使うとよいでしょう。

## 12.5 テーマでの色のカスタムと意味的な色名

ブランドカラーは、第5章のとおり `@theme` で定義します。このとき、`--color-brand-blue` のような「見た目の名前」だけでなく、**役割を表す意味的な名前（セマンティックトークン）**も定義しておくと、後が楽になります。

```css
@theme {
  --color-brand: oklch(0.45 0.24 264);   /* ブランド色 */
  --color-surface: oklch(1 0 0);          /* 背景面 */
  --color-danger: oklch(0.58 0.22 27);    /* 危険・エラー */
}
```

こうすると `bg-surface`・`text-danger` のように「意味」で色を呼べます。「エラーは赤」という決定を 1 か所に集約でき、後でブランド色を変えるときも定義の差し替えだけで済みます。これはダークモード（第18章）やデザインシステム（第23章）への布石にもなります。

## 12.6 実務: ブランドカラーの組み込みとダークモード前提の設計

実務では、最初から**ダークモードを前提に色を設計**しておくと後悔が減ります。具体的には、`bg-white`・`text-black` のような直接的な色ではなく、12.5 のセマンティックトークン（`bg-surface`・`text-foreground` など）で組んでおき、ダークモード時にトークンの値だけを差し替える、という設計です（第18章）。`text-[#1a1a1a]` のような任意の色を散らすと、ダークモード対応や配色変更のときに総とっかえになります。色こそ、任意の値を避けてテーマに寄せるべき領域です。

## 参考資料

* Tailwind CSS Docs — Colors: https://tailwindcss.com/docs/colors
* Tailwind CSS Docs — Background color: https://tailwindcss.com/docs/background-color
* Tailwind CSS Docs — Theme（色のカスタム）: https://tailwindcss.com/docs/theme

---

# 第13章 Borders と Effects

## 13.1 ボーダー幅・色・スタイル

境界線は、要素の区切りを示す基本的な装飾です。Tailwind では幅・色・スタイルを別々のユーティリティで指定します。

```html
<div class="border border-gray-200">細い枠（既定 1px）</div>
<div class="border-2 border-dashed border-blue-500">破線の太枠</div>
```

- 幅: `border`（1px）・`border-2`・`border-4`、方向別に `border-t`・`border-x` など
- 色: `border-*`（パレット。第12章）
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

実務でのコツは 2 つです。1 つは**影を盛りすぎない**こと。`shadow-sm`〜`shadow-md` を基準にし、`shadow-2xl` は本当に浮かせたい要素だけに使うと、画面が落ち着きます。もう 1 つは、**フォーカスリングを消さない**こと。デザイン上の理由で `outline-none` にする場合は、必ず `focus:ring-2` などで代わりの可視化を用意します。これはアクセシビリティの必須事項です（第21章）。

## 参考資料

* Tailwind CSS Docs — Border width / color: https://tailwindcss.com/docs/border-width
* Tailwind CSS Docs — Box shadow: https://tailwindcss.com/docs/box-shadow
* Tailwind CSS Docs — Filter（filter プロパティ本体）: https://tailwindcss.com/docs/filter
* Tailwind CSS Docs — blur（`blur-*`）: https://tailwindcss.com/docs/filter-blur
* Tailwind CSS Docs — brightness（`brightness-*`）: https://tailwindcss.com/docs/filter-brightness
* Tailwind CSS Docs — backdrop-blur（`backdrop-blur-*`）: https://tailwindcss.com/docs/backdrop-filter-blur

---

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

`hidden md:block` のように、レスポンシブと組み合わせて「特定の画面幅だけ表示」を作るのは頻出パターンです（第17章）。

## 14.2 position と重なり

`position` で要素の配置基準を決め、`top/right/bottom/left`（まとめて `inset-*`）でずらします。重なり順は `z-*` です。

```html
<div class="relative">
  <span class="absolute top-2 right-2">バッジ</span>
</div>
```

`relative` を付けた親を基準に、`absolute` の子を四隅へ配置する——この組み合わせが、バッジや閉じるボタンの定番です。`sticky top-0` でスクロール追従ヘッダーも作れます。

## 14.3 サイズ（width / height / size）

幅・高さの指定です。`w-*` / `h-*` は第10章の `--spacing` スケールを共有します。さらに割合・画面基準の値も使えます。

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

そして v4 の目玉が **Container Queries**（コンテナクエリ）です。第17章で扱うレスポンシブは「画面幅」に反応しますが、コンテナクエリは「**親要素の幅**」に反応します。サイドバーの中でもメイン領域の中でも、置かれた場所の幅に応じてレイアウトを変えられます。

```html
<div class="@container">
  <div class="flex flex-col @md:flex-row">
    <!-- 親(@container)が md 幅以上になったら横並びに -->
  </div>
</div>
```

親に `@container` を付け、子に `@md:` のような接頭辞を付けます。これにより、コンポーネントが「どの画面か」ではなく「**自分が今どれだけの幅を与えられているか**」で自律的にレイアウトを決められます。再利用しやすいコンポーネントを作るうえで強力な機能です。

## 14.6 実務: ページの骨格を組む手順

実務では、いきなり細部を作らず、**外側から内側へ**組むと崩れにくくなります。おすすめの順序は、(1) ページ全体の最大幅と中央寄せ（`mx-auto max-w-*`）→ (2) 大きな領域分け（Flex / Grid、第15・16章）→ (3) 各領域の余白（第10章）→ (4) 中身の装飾、です。骨格が決まる前から `absolute` や任意のサイズで微調整を始めると、後で破綻しがちです。

## 参考資料

* Tailwind CSS Docs — Display: https://tailwindcss.com/docs/display
* Tailwind CSS Docs — Width / Size: https://tailwindcss.com/docs/width
* Tailwind CSS Docs — Responsive design（Container queries）: https://tailwindcss.com/docs/responsive-design

---

# 第15章 Flexbox

## 15.1 Flexbox の素の CSS と Tailwind の対応

Flexbox は「要素を 1 方向（横一列か縦一列）に並べ、余白や伸縮を制御する」レイアウト手法です。読者はすでに Flexbox の基礎を学んでいる前提なので、ここでは**素の CSS と Tailwind の対応**を押さえることに集中します。Tailwind のクラスは、CSS プロパティをほぼそのまま短くしただけです。

| 素の CSS | Tailwind |
| --- | --- |
| `display: flex` | `flex` |
| `flex-direction: column` | `flex-col` |
| `justify-content: center` | `justify-center` |
| `align-items: center` | `items-center` |
| `gap: 1rem` | `gap-4` |

つまり Flexbox を知っていれば、Tailwind の Flex は「短い別名を覚えるだけ」です。

## 15.2 方向・折り返し

```html
<div class="flex flex-row">横並び（既定）</div>
<div class="flex flex-col">縦並び</div>
<div class="flex flex-wrap">入りきらなければ折り返す</div>
```

`flex` だけだと横並び（`flex-row`）になります。縦に積みたいときは `flex-col`、子が多くて折り返したいときは `flex-wrap` を足します。

## 15.3 主軸・交差軸の配置

Flexbox の肝は「2 つの軸での配置」です。混同しやすいので整理します。

- **主軸方向の配置 = `justify-*`**: `justify-start` / `justify-center` / `justify-between`（両端に寄せて間を均等に）/ `justify-end`
- **交差軸方向の配置 = `items-*`**: `items-start` / `items-center` / `items-stretch`

```html
<!-- 横並びで、左右両端に配置し、縦は中央そろえ -->
<div class="flex justify-between items-center">
  <span>ロゴ</span>
  <nav>メニュー</nav>
</div>
```

この `justify-between items-center` は、ヘッダーの「ロゴを左、メニューを右、縦は中央」という最頻出パターンです。

## 15.4 伸縮（grow / shrink / basis）

子要素が空きスペースをどう分け合うかを制御します。

- `grow` … 余ったスペースを埋めるように伸びる
- `shrink-0` … 縮まない（アイコンなどを潰したくないとき）
- `basis-*` … 基準サイズ

```html
<div class="flex">
  <input class="grow" />          <!-- 入力欄が伸びる -->
  <button class="shrink-0">検索</button>  <!-- ボタンは潰れない -->
</div>
```

## 15.5 個別配置（self / order）

特定の子だけ別扱いにしたいときは `self-*`（その子の交差軸配置）や `order-*`（並び順の変更）を使います。`order-first` / `order-last` で、HTML の順序を変えずに見た目の順序だけ入れ替えられます。

## 15.6 実務: ナビゲーションバー・ツールバー

Flexbox の実務での主役は、横並びの UI です。ナビゲーションバー、ツールバー、ボタンの並び、アイコン＋ラベルなど。基本の型は `flex items-center gap-*` で、これに `justify-between`（両端寄せ）や `grow`（一部を伸ばす）を足して組み立てます。1 次元（一列）の配置なら Flexbox、2 次元（行と列の格子）なら次章の Grid、という使い分けを覚えておきましょう。

## 参考資料

* Tailwind CSS Docs — Flex: https://tailwindcss.com/docs/flex
* Tailwind CSS Docs — Justify content: https://tailwindcss.com/docs/justify-content
* Tailwind CSS Docs — Align items: https://tailwindcss.com/docs/align-items

---

# 第16章 Grid

## 16.1 Grid の素の CSS と Tailwind の対応

CSS Grid は「行と列の**格子**で 2 次元にレイアウトする」手法です。Flexbox が 1 方向の並びを得意とするのに対し、Grid は「縦も横も揃えたい」表組み的なレイアウトに向きます。こちらも対応関係を押さえましょう。

| 素の CSS | Tailwind |
| --- | --- |
| `display: grid` | `grid` |
| `grid-template-columns: repeat(3, minmax(0,1fr))` | `grid-cols-3` |
| `gap: 1rem` | `gap-4` |
| `grid-column: span 2` | `col-span-2` |

## 16.2 列・行の定義

`grid-cols-*` で列数を決めます。`grid-cols-3` は「等幅 3 列」です。

```html
<div class="grid grid-cols-3 gap-4">
  <div>1</div><div>2</div><div>3</div>
</div>
```

このとき生成される CSS はこうです。

```css
.grid-cols-3 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
```

`minmax(0, 1fr)` になっているのは、中身が大きくても列がはみ出さないようにするための定番テクニックで、Tailwind が標準で面倒を見てくれています。複雑なトラックは任意の値で書けます（例: `grid-cols-[200px_1fr]`）。

## 16.3 配置とスパン

子要素を「何列ぶん占めるか」「何列目から始めるか」で配置します。

```html
<div class="grid grid-cols-4 gap-4">
  <div class="col-span-2">2 列ぶん</div>
  <div>1 列</div>
  <div>1 列</div>
</div>
```

- `col-span-*` … 列方向にまたぐ
- `col-start-*` / `col-end-*` … 開始・終了位置
- 行方向は `row-span-*` `row-start-*`

## 16.4 gap と Flexbox との使い分け

Grid でも間隔は `gap-*` で空けます（第10章）。`gap-x-*` / `gap-y-*` で縦横を別々にもできます。

「Flexbox と Grid のどちらを使うか」は実務でよく迷うところですが、目安はシンプルです。**一列（または一行）に並べるだけなら Flexbox、行と列の両方をきっちり揃えたいなら Grid** です。ボタンの横並びは Flex、商品カードの格子は Grid、と考えれば外しません。

## 16.5 動的な列数

第2部で見たとおり、v4 では `grid-cols-15` のような**スケールに用意されていない列数**も、設定なしで動的に生成されます。

```html
<div class="grid grid-cols-7">7 列のカレンダー</div>
```

これは「定義していないクラスがなぜ効くのか」（第4章）の好例です。とはいえ、極端な列数を任意の値で乱発すると可読性が落ちるので、よく使う列数はレスポンシブの型（次項）に落とし込むのが実務的です。

## 16.6 実務: カードグリッド・ダッシュボード

Grid の実務での主役は、**カード一覧**と**ダッシュボード**です。カード一覧は、画面幅に応じて列数を増やすレスポンシブグリッドが定番です。

```html
<div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
  <!-- カードを並べる -->
</div>
```

これは「スマホで 1 列、タブレットで 2 列、PC で 3 列」という、最もよく書くパターンです（レスポンシブは第17章で深掘りします）。ダッシュボードのように「大きいパネルと小さいパネルを混在させる」レイアウトは、`col-span-*` / `row-span-*` を組み合わせて表現します。

第4部はここまでです。余白・文字・色・装飾・レイアウト・Flex・Grid という、画面を組む道具がそろいました。いずれも第2部の仕組み（`--spacing`・oklch・任意の値・container query）の上に乗っていることを思い出してください。次の第5部では、これらを使って**レスポンシブ・ダークモード・アニメーション・フォーム・アクセシビリティ**という実践的なテーマに踏み込みます。

## 参考資料

* Tailwind CSS Docs — Grid template columns: https://tailwindcss.com/docs/grid-template-columns
* Tailwind CSS Docs — Grid column（span / start / end）: https://tailwindcss.com/docs/grid-column
* Tailwind CSS Docs — Gap: https://tailwindcss.com/docs/gap
