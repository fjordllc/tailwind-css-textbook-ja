# 第5部 実践的な Tailwind CSS

第4部までで、画面を組むための道具がそろいました。この第5部では、それらを使って**実際のプロダクトで必ず求められるテーマ**に取り組みます。レスポンシブ（第17章）、ダークモード（第18章）、アニメーション（第19章）、フォーム（第20章）、アクセシビリティ（第21章）です。

これらはすべて、第2部で学んだ**バリアントの仕組み**（第6章）の応用です。`md:`・`dark:`・`hover:`・`motion-reduce:`・`invalid:` といったバリアントが、ここで実戦投入されます。「条件付きでスタイルを当てる」という Tailwind の核心が、最も生きる場面です。

---

# 第17章 レスポンシブデザイン

## 17.1 モバイルファースト原則

レスポンシブデザインとは、画面幅に応じてレイアウトを変えることです。素の CSS ではメディアクエリ（`@media`）で書きますが、Tailwind では第6章で見たブレークポイントのバリアント（`sm:` `md:` `lg:` …）を使います。

ここで最も重要な原則が**モバイルファースト**です。Tailwind では、**プレフィックスなしのクラスはすべての画面に効き、`md:` などのプレフィックス付きは「その幅以上」で上書きする**という設計になっています。

```html
<!-- スマホでは縦並び、md 以上で横並び -->
<div class="flex flex-col md:flex-row">...</div>
```

ここでよくある誤解を解いておきます。`md:` は「md サイズのときだけ」ではなく「**md 幅以上のすべて**」を意味します。だから設計の順序は「まず狭い画面（無印）を作り、広くなったら上書きする」になります。`sm:text-left` を「スマホのとき左寄せ」と誤解すると、意図と逆になります。**無印＝土台、プレフィックス＝広い画面での変更**、と覚えてください。

## 17.2 デフォルトブレークポイントとカスタム

v4 の既定ブレークポイントは次のとおりです（第6章で確認した値です）。

| プレフィックス | 最小幅 | 生成される CSS |
| --- | --- | --- |
| `sm:` | 40rem (640px) | `@media (width >= 40rem)` |
| `md:` | 48rem (768px) | `@media (width >= 48rem)` |
| `lg:` | 64rem (1024px) | `@media (width >= 64rem)` |
| `xl:` | 80rem (1280px) | `@media (width >= 80rem)` |
| `2xl:` | 96rem (1536px) | `@media (width >= 96rem)` |

カスタムしたいときは、第5章のとおり `@theme` で `--breakpoint-*` を定義します。たとえば `--breakpoint-3xl: 120rem;` と書けば `3xl:` が使えるようになります。

## 17.3 範囲指定・`max-*` バリアント

「ある幅**以上**」だけでなく「ある幅**未満**」を指定したいこともあります。そのときは `max-*` バリアントを使います。

```html
<div class="max-md:hidden">md 未満では隠す</div>
```

`md:` と `max-*` を組み合わせると、「md 以上 xl 未満だけ」のような**範囲指定**もできます。

```html
<div class="md:max-xl:flex">md 以上 xl 未満のときだけ flex</div>
```

ただし範囲指定は読みにくくなりがちなので、本当に必要なときに限るのが無難です。

## 17.4 メディアクエリ vs Container Queries

ここが現代のレスポンシブで最も大切な使い分けです。第14章で触れた**Container Queries**（コンテナクエリ）との違いを整理します。

- **ブレークポイント（`md:` など）= 画面の幅に反応する。** ページ全体のレイアウトを切り替えるのに向く。
- **コンテナクエリ（`@md:` など）= 親要素の幅に反応する。** 「どこに置かれるか分からないコンポーネント」を、置かれた場所の幅に応じて変えるのに向く。

```html
<!-- このカードは、画面ではなく自分の親の幅で形を変える -->
<div class="@container">
  <article class="flex flex-col @md:flex-row">...</article>
</div>
```

同じカードを、広いメイン領域に置いても狭いサイドバーに置いても、それぞれの幅に合わせて自律的に振る舞えます。**ページ全体の構成はブレークポイント、再利用するコンポーネントはコンテナクエリ**、という使い分けを覚えておくと、設計がぐっと洗練されます。

## 17.5 実務: ブレークポイント設計のアンチパターン

実務で最もありがちな失敗は、**ブレークポイントを刻みすぎる**ことです。`sm:` `md:` `lg:` `xl:` `2xl:` すべてに別々の値を指定したクラスが並ぶと、もはや誰も挙動を追えません。

```html
<!-- アンチパターン: 分岐が多すぎる -->
<div class="text-sm sm:text-base md:text-lg lg:text-xl xl:text-2xl">...</div>
```

多くの場合、切り替えは 1〜2 段階で十分です。「スマホと PC の 2 パターン」を基本に考え、どうしても必要なときだけ中間を足す。これだけで、レスポンシブはずっと保守しやすくなります。

## 参考資料

* Tailwind CSS Docs — Responsive design: https://tailwindcss.com/docs/responsive-design
* Tailwind CSS Docs — Responsive design（Container queries の節）: https://tailwindcss.com/docs/responsive-design

---

# 第18章 ダークモード

## 18.1 `dark:` バリアントの仕組み

ダークモードは、`dark:` バリアントで実現します。第6章で見たとおり、これは「ダークモードのときだけ効くスタイル」を生成するバリアントです。

```html
<div class="bg-white text-gray-900 dark:bg-gray-900 dark:text-gray-100">
  ライトでは白地・黒字、ダークでは黒地・白字
</div>
```

無印（`bg-white text-gray-900`）がライトモードの見た目、`dark:` 付きがダークモードでの上書きです。第17章のモバイルファーストと同じ「土台＋上書き」の構造です。

## 18.2 `media`（OS 連動）と `class`/`selector`（手動切替）戦略

ダークモードの「効くタイミング」には、大きく 2 つの戦略があります。

- **OS 連動（既定）**: 利用者の OS 設定（`prefers-color-scheme`）に従って自動で切り替わります。設定不要で、`dark:` がそのまま OS のダークモードに反応します。
- **手動切替（クラス方式）**: ページ内のトグルボタンで切り替えたい場合。`<html>` などに `.dark` クラスが付いているときだけ `dark:` を効かせます。

「ユーザーに切り替えボタンを提供したい」なら、後者の手動切替を選びます。

## 18.3 v4 でのダークモード設定（`@custom-variant dark`）

手動切替にするには、第6章で触れた `@custom-variant` を使って `dark:` の意味を上書きします。v4 では CSS にこう書きます。

```css
@import "tailwindcss";

@custom-variant dark (&:where(.dark, .dark *));
```

これで `dark:` は「OS 設定」ではなく「**祖先に `.dark` クラスがあるとき**」に効くようになります。あとは JavaScript で `<html>` に `.dark` を付け外しすれば、テーマが切り替わります。

```js
// ダークにする / 戻す
document.documentElement.classList.toggle('dark')
```

> v3 を知っている人へ: v3 では `tailwind.config.js` に `darkMode: 'class'` と書きました。v4 ではこの設定が CSS の `@custom-variant` に移りました。

## 18.4 トグル実装とちらつき対策

手動切替で必ずぶつかるのが、**初期表示のちらつき（FOUC: Flash of Unstyled Content）**です。ページ読み込み時、JavaScript で `.dark` を付ける前に一瞬ライトモードが表示され、直後に暗転する——この不快なちらつきです。

原因は、「`.dark` を付ける JavaScript が、画面の描画より後に走る」ことです。対策は、**描画前（`<head>` の早い段階）に、同期的なスクリプトで `.dark` を決定する**ことです。

```html
<!-- <head> の早い位置に置く同期スクリプト -->
<script>
  if (localStorage.theme === 'dark' ||
      (!('theme' in localStorage) &&
       window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    document.documentElement.classList.add('dark')
  }
</script>
```

保存済みの設定（`localStorage`）か OS 設定を見て、最初の描画より前にクラスを付けます。Rails でも React/Next.js でも、考え方は同じです。Rails ならレイアウトの `<head>` にこのスクリプトを直接書きます。Next.js（App Router）では、同様のスクリプトを `<head>` に同期実行で差し込みます。これは、テーマをブラウザの `localStorage` に保存する場合の定石です。

なお、テーマを **Cookie やデータベースに保存する**設計であれば、サーバー側でユーザーの設定を知れるので、最初から `<html class="dark">` をサーバーレンダリングして出力できます。この場合は描画前のスクリプトが不要になり、ちらつきも原理的に起きません（公式ドキュメントもこの方法に触れています）。「クライアント保存ならスクリプト、サーバー保存なら初期クラスを出力」と使い分けると覚えてください。

## 18.5 実務: 色設計をダークモード前提にする

ダークモード対応で苦労しないコツは、第12章でも触れたとおり、**最初からセマンティックトークンで色を組む**ことです。

`dark:` を要素ごとにベタ書きすると、`bg-white dark:bg-gray-900` のような対が画面中に散らばり、後で色を調整するのが地獄になります。代わりに、第5章のテーマ変数を使い、`.dark` のときに変数の値だけを差し替える設計にします。

```css
@theme {
  --color-surface: oklch(1 0 0);       /* ライトの背景 */
  --color-foreground: oklch(0.2 0 0);  /* ライトの文字 */
}

.dark {
  --color-surface: oklch(0.2 0 0);     /* ダークでは反転 */
  --color-foreground: oklch(0.95 0 0);
}
```

こうしておけば、HTML は `bg-surface text-foreground` と書くだけで両モードに対応します。`dark:` を個別に書く量が激減し、配色の調整も CSS 変数の 1 か所で済みます。

## 参考資料

* Tailwind CSS Docs — Dark mode: https://tailwindcss.com/docs/dark-mode
* Tailwind CSS Docs — Functions and directives（@custom-variant）: https://tailwindcss.com/docs/functions-and-directives

---

# 第19章 アニメーション

## 19.1 transition

アニメーションの基本は**トランジション**——状態が変わるときに、見た目をなめらかに変化させることです。`hover:` などで色やサイズが変わるとき、`transition` を付けると瞬間的にではなく徐々に変化します。

```html
<button class="bg-blue-500 transition hover:bg-blue-700 duration-200 ease-out">
  ホバーでなめらかに色が変わる
</button>
```

- `transition` … トランジションを有効にする
- `duration-200` … 変化にかける時間（200ms）
- `ease-out` … 変化の緩急（イージング）
- `delay-*` … 開始を遅らせる

## 19.2 transform

**トランスフォーム**は、要素を移動・拡大・回転させます。レイアウトに影響を与えずに見た目を動かせるので、アニメーションと相性が良い機能です。

```html
<div class="transition hover:scale-105 hover:-translate-y-1">
  ホバーで少し拡大して浮き上がる
</div>
```

- `translate-x-*` / `translate-y-*` … 移動
- `scale-*` … 拡大・縮小
- `rotate-*` … 回転

v4 では、これらが個別の CSS プロパティ（`translate`・`scale`・`rotate`）として扱われるようになり、3D の変形（`rotate-x-*` など）も扱えます。

## 19.3 組み込みアニメーションとカスタム

繰り返し動き続けるアニメーションには、組み込みのユーティリティがあります。

```html
<svg class="animate-spin">...</svg>   <!-- 回転（ローディング） -->
<div class="animate-pulse">...</div>   <!-- 点滅（スケルトン表示） -->
```

- `animate-spin` … 回転し続ける（ローディングスピナー）
- `animate-pulse` … ゆっくり点滅（読み込み中のプレースホルダー）
- `animate-bounce` … 跳ねる

独自のアニメーションは、第5章のテーマで `--animate-*` を定義して追加します。`@theme` に `@keyframes` とあわせて定義することで、`animate-自分の名前` が使えるようになります。

## 19.4 入場アニメーション `@starting-style`

「要素が現れる瞬間」をアニメーションさせたい場面——モーダルやポップオーバーがふわっと出てくる演出——は、従来 JavaScript が必要でした。v4 は、モダン CSS の **`@starting-style`** に対応する `starting:` バリアントを用意しており、これを CSS だけで書けます。

`starting:` は「要素が DOM に最初に現れた瞬間（または `display: none` から表示に変わった瞬間）の、開始時点の見た目」を指定します。

```html
<div popover id="menu"
     class="opacity-100 transition-opacity starting:opacity-0">
  ふわっと現れるメニュー
</div>
```

「開始時は透明（`starting:opacity-0`）→ 表示後は不透明（`opacity-100`）」へ、`transition` でなめらかにつなぎます。JavaScript なしで入場アニメーションが書けるのは、v4 がモダン CSS の薄いラッパーであることの好例です。

## 19.5 `motion-reduce` への配慮

アニメーションは、すべての人にとって快適とは限りません。前庭障害などのある人にとって、動きの多い画面は不快や体調不良の原因になります。OS には「視差効果を減らす（reduce motion）」設定があり、これを尊重するのがアクセシビリティの基本です。

Tailwind では `motion-reduce:` バリアントで対応します。

```html
<div class="animate-bounce motion-reduce:animate-none">
  通常は跳ねるが、reduce motion 設定なら止まる
</div>
```

`motion-reduce:animate-none` で、reduce motion を有効にしているユーザーには動きを止めます。逆に `motion-safe:`（動きを許可している人にだけ animate を付ける）という書き方もあります。**装飾的なアニメーションには、原則この配慮をセットにする**習慣をつけましょう（第21章）。

## 19.6 実務: マイクロインタラクションと過剰演出の回避

実務でのアニメーションは、**控えめなマイクロインタラクション**（ボタンのホバー、フォーカス時のリング、読み込み中の表示など）に効果を発揮します。ユーザーに「反応した」という手応えを返すのが目的です。

逆に避けたいのは、過剰な演出です。スクロールのたびに要素が派手に動く、画面遷移ごとに大きなアニメーションが入る、といった演出は、最初は楽しくてもすぐに鬱陶しくなり、操作の邪魔になります。「気づかないくらい自然」が良いアニメーションの目安です。`duration-200` 前後の短いトランジションを基本に、`motion-reduce` への配慮を忘れずに、が実務の定石です。

## 参考資料

* Tailwind CSS Docs — Transition property: https://tailwindcss.com/docs/transition-property
* Tailwind CSS Docs — Translate: https://tailwindcss.com/docs/translate
* Tailwind CSS Docs — Scale: https://tailwindcss.com/docs/scale
* Tailwind CSS Docs — Rotate: https://tailwindcss.com/docs/rotate
* Tailwind CSS Docs — Animation: https://tailwindcss.com/docs/animation
* Tailwind CSS Docs — Hover, focus & other states（starting / motion-reduce）: https://tailwindcss.com/docs/hover-focus-and-other-states

---

# 第20章 フォームデザイン

## 20.1 素のフォーム要素のばらつきと `@tailwindcss/forms`

フォーム要素（`<input>`・`<select>`・チェックボックスなど）は、ブラウザや OS によって見た目がバラバラで、しかも素の状態ではユーティリティで整えにくいという厄介な性質があります。チェックボックスの色を変えるだけでも、本来は手間がかかります。

これを解決するのが公式プラグイン **`@tailwindcss/forms`** です。このプラグインは、フォーム要素に**ユーティリティで上書きしやすい素直なリセット（土台のスタイル）**を当てます。これを入れておくと、`<input>` や `<select>` を、ふつうのユーティリティ（`rounded`・`border`・`focus:ring-2` など）でそのまま整えられるようになります。

既定では、このプラグインは **2 つを同時に提供**します。1 つはフォーム要素すべてにグローバルに当たるリセット、もう 1 つは `form-input`・`form-select`・`form-multiselect`・`form-checkbox`・`form-radio`・`form-textarea` というクラス群です。何も設定しなければ両方が使えます。

そのうえで、片方だけに**制限したい**ときに `strategy` を指定します。

- `strategy: "base"`: グローバルなリセットだけにする（クラスは生成しない）。多くの新規プロジェクトはこれで十分です。
- `strategy: "class"`: `form-*` クラスを付けた要素にだけリセットを当てる（グローバルには当てない）。既存の見た目を壊したくないとき向け。

導入（v4 では CSS に `@plugin "@tailwindcss/forms";`）は第26章で扱います。

## 20.2 入力・選択・チェック/ラジオのスタイリング

`@tailwindcss/forms` を入れた前提で、フォーム要素はふつうのユーティリティで整えます。

```html
<input type="text"
  class="rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-500" />

<input type="checkbox" class="rounded text-blue-600 focus:ring-blue-500" />
```

チェックボックスやラジオの色は `text-*`（チェック時の色）で指定できるようになります。これがプラグインの効果です。

## 20.3 状態表現（focus / invalid / disabled / peer）

フォームでは「状態を見た目に反映する」ことが重要です。第6章のバリアントが主役になります。

```html
<input required
  class="border-gray-300
         focus:ring-2 focus:ring-blue-500
         invalid:border-red-500
         disabled:bg-gray-100 disabled:cursor-not-allowed" />
```

- `focus:` … 入力中の強調
- `invalid:` … 入力値が不正なとき（`required` 未入力やメール形式違反など）
- `required:` … 必須項目
- `disabled:` … 無効化されているとき

さらに第6章で見た `peer-*` を使うと、**入力欄の状態に応じてエラーメッセージを出す**といった連動を、JavaScript なしで書けます。

```html
<input type="email" class="peer ..." />
<p class="hidden peer-invalid:block text-sm text-red-600">
  メールアドレスの形式が正しくありません
</p>
```

## 20.4 `field-sizing` など新ユーティリティ

v4 には、フォームで便利な新ユーティリティもあります。たとえば `field-sizing-content` は、テキストエリアなどを**中身の量に応じて自動でリサイズ**させます。入力が増えると勝手に広がるテキストエリアが、JavaScript なしで作れます。

```html
<textarea class="field-sizing-content" placeholder="入力すると自動で広がります"></textarea>
```

## 20.5 実務: Rails / React フォームでの組み込みと「過信しない」範囲

実務では、フォームは各フレームワークのヘルパーが生成する要素に、Tailwind のクラスを与える形になります。

Rails の `form_with` なら、ヘルパーに `class:` を渡します。

```erb
<%= form_with model: @user do |f| %>
  <%= f.email_field :email,
        class: "rounded-md border-gray-300 focus:ring-2 focus:ring-blue-500" %>
<% end %>
```

React なら、入力要素に `className` を付けるだけです（第25章で再利用の工夫を扱います）。

**ここで大切な注意**があります。`@tailwindcss/forms` と Tailwind が面倒を見るのは、あくまで**見た目**だけです。

- **入力の検証（バリデーション）**: 値が正しいかの確認は、Rails のモデルバリデーションやフロントエンドのバリデーションが担います。Tailwind は `invalid:` で「不正なときの見た目」を出せるだけで、何が不正かを判断するのは別の層の仕事です。
- **アクセシビリティ**: ラベルと入力の関連付け（`<label for>`）、エラーの読み上げ（`aria-describedby` など）は、HTML を正しく書く必要があります（第21章）。`@tailwindcss/forms` はこれらを自動でやってはくれません。

「フォームの見た目は Tailwind、正しさとアクセシビリティは HTML とアプリ側」という役割分担を、過信せずに押さえておきましょう。

## 参考資料

* @tailwindcss/forms（GitHub）: https://github.com/tailwindlabs/tailwindcss-forms
* Tailwind CSS Docs — Field sizing（`field-sizing-content` / `field-sizing-fixed`）: https://tailwindcss.com/docs/field-sizing
* Tailwind CSS Docs — Hover, focus & other states（invalid / required / peer）: https://tailwindcss.com/docs/hover-focus-and-other-states

---

# 第21章 アクセシビリティ

## 21.1 ユーティリティと a11y の関係

アクセシビリティ（a11y）は、障害の有無や利用環境にかかわらず、誰もが使える Web を作るための取り組みです。ここで最初に押さえるべき大原則があります。

> **クラスは「見た目」、意味は「HTML」が担う。**

Tailwind のユーティリティは見た目を整えるだけで、要素の**意味**は HTML が決めます。`<div class="...">` をボタンのように装飾しても、スクリーンリーダーにはボタンとして伝わりません。ボタンは `<button>`、見出しは `<h1>`〜`<h6>`、ナビゲーションは `<nav>` を使う——この「正しい HTML を書く」ことが、アクセシビリティの土台です。Tailwind を使っても、この原則は何も変わりません。むしろ「クラスで見た目を作れてしまう」からこそ、正しい要素を選ぶ意識が大切です。

## 21.2 視覚的に隠す `sr-only`

「**目には見せないが、スクリーンリーダーには読ませたい**」テキストがあります。たとえばアイコンだけのボタンには、見た目上はラベルが要りませんが、スクリーンリーダー利用者には何のボタンか伝える必要があります。

このための専用ユーティリティが `sr-only` です。

```html
<button>
  <svg><!-- 検索アイコン --></svg>
  <span class="sr-only">検索</span>
</button>
```

`sr-only` は、要素を視覚的に消しつつ（`display: none` とは違い）支援技術には読み上げさせる、という CSS を当てます（実体は `position: absolute; width: 1px; height: 1px; overflow: hidden; ...` といった定番のテクニックです）。`display: none` だと読み上げからも消えてしまうので、この使い分けが重要です。逆に「狭い画面では隠し、広い画面では見せる」には `sr-only sm:not-sr-only` のように `not-sr-only` で打ち消します。

## 21.3 フォーカス可視化（focus-visible とリング）

キーボードだけで操作する人にとって、「いまどこにフォーカスがあるか」が見えることは死活問題です。ところがデザインの都合で、ブラウザ標準のフォーカス枠を `outline-none` で消してしまう例が後を絶ちません。**フォーカスの可視化を消すなら、必ず代わりを用意する**のが鉄則です。

ここで役立つのが第6章の `focus-visible:` です。これは CSS の `:focus-visible` に対応するもので、**ブラウザが「フォーカス表示を出すべきだ」と判断したときだけ**スタイルを当てます。ブラウザは入力方式（マウスかキーボードか）や要素の種類から自動でこれを判断します。たとえばボタンの場合、キーボード操作でフォーカスしたときには枠が出て、マウスでクリックしただけのときには出ない、という具合です。これにより、マウス利用者には余計な枠を出さず、キーボード利用者にはしっかり枠を見せられます。

ただし「マウスでは絶対に出ない」と言い切れるわけではありません。テキスト入力欄のように、クリックでフォーカスしても表示が必要とブラウザが判断する要素では、マウス操作でも枠が出ることがあります。挙動はブラウザと要素任せで、こちらが細かく制御するものではない、と理解しておくとよいでしょう。

```html
<button class="focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-500">
  キーボード操作のときだけリングが出る
</button>
```

## 21.4 `aria-*` / `data-*` バリアントで状態を見た目に反映

トグルボタンやアコーディオンのような UI では、「押されている」「開いている」といった状態を、見た目とスクリーンリーダーの**両方**に伝える必要があります。状態は ARIA 属性（`aria-pressed`・`aria-expanded` など）で表現し、第6章の `aria-*` バリアントでその見た目を作ります。

```html
<button aria-pressed="true" class="aria-pressed:bg-blue-600 aria-pressed:text-white">
  トグル
</button>
```

`aria-pressed` 属性を切り替えれば、見た目（`aria-pressed:` のスタイル）も支援技術への伝達も同時に正しくなります。「見た目だけ変えて ARIA 属性を更新し忘れる」というありがちなバグを、属性ドリブンにすることで防げます。

## 21.5 コントラスト・色だけに依存しない設計

色に関するアクセシビリティで重要な点が 2 つあります。

- **コントラスト比を確保する**: 文字と背景のコントラストが低いと、弱視の人や明るい屋外では読めません。`text-gray-400` を白背景に置くような薄い文字は要注意です。目安は **WCAG の AA 基準で、通常テキストは 4.5:1 以上**です（大きな文字は 3:1 以上など、一部に例外があります）。この基準を満たす配色を選びます。
- **色だけで情報を伝えない**: 「赤が必須、緑が任意」のように色だけで区別すると、色覚特性のある人に伝わりません。色に加えて、アイコンやテキスト（「※必須」など）を併用します。エラーを赤くするだけでなく、エラーメッセージの文言も添える、という具合です。

第19章で扱った `motion-reduce:` への配慮も、アクセシビリティの一環です。装飾的なアニメーションには動きを止める手段をセットにします。

## 21.6 実務: キーボード操作と Headless UI の活用

複雑な UI（モーダル、ドロップダウン、タブ、コンボボックスなど）を**正しくアクセシブルに作る**のは、実はとても難しいことです。フォーカスの管理（モーダルの外にフォーカスが出ないようにする）、キーボード操作（矢印キーでメニューを移動、Esc で閉じる）、適切な ARIA 属性——これらを自前で完璧に実装するのは大変です。

ここで頼れるのが、Tailwind Labs 製の **Headless UI** です。これは「**スタイルを持たないが、アクセシビリティと操作性は作り込まれている**」UI 部品集です。見た目は持たないので、Tailwind のユーティリティで自由に装飾できます。「面倒で間違えやすいアクセシビリティの部分はライブラリに任せ、見た目は Tailwind で作る」という、理想的な分担ができます（React での活用は第25章で扱います）。

第5部はここまでです。レスポンシブ・ダークモード・アニメーション・フォーム・アクセシビリティという、実プロダクトで必ず問われるテーマを、すべて第2部のバリアントの応用として見てきました。次の第6部では、ここまで何度も「コンポーネント化で解決する」と先送りにしてきた話題——**長いクラス列をどう再利用可能な部品にまとめるか**——に正面から取り組みます。

## 参考資料

* Tailwind CSS Docs — Display（sr-only / not-sr-only）: https://tailwindcss.com/docs/display
* Tailwind CSS Docs — Hover, focus & other states（focus-visible / aria-*）: https://tailwindcss.com/docs/hover-focus-and-other-states
* MDN — `:focus-visible`: https://developer.mozilla.org/en-US/docs/Web/CSS/:focus-visible
* W3C — WCAG 2.2 Contrast (Minimum): https://www.w3.org/TR/WCAG22/#contrast-minimum
* Headless UI（公式サイト）: https://headlessui.com/
