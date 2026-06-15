# 第6章 バリアントの仕組み

ここまでで、ユーティリティが生成される仕組み（第4章）と、その値を決めるテーマ（第5章）を見てきました。残るピースが**バリアント**です。`hover:bg-blue-700` の `hover:`、`md:flex` の `md:` のように、ユーティリティの前に付けて**「どんな条件のときに効かせるか」を指定する接頭辞**——これがバリアントです。第3章で「Tailwind がインラインスタイルと違う最大の理由」として挙げた、状態とレスポンシブを支える仕組みです。

## 6.1 バリアントとは

バリアントは、ユーティリティに「条件」を付けるものです。

```html
<button class="bg-blue-500 hover:bg-blue-700">送信</button>
```

ここで `bg-blue-500` は常に効く背景色、`hover:bg-blue-700` は**マウスを乗せたときだけ**効く背景色です。生成される CSS を見ると、バリアントの正体がよく分かります（簡略化）。

```css
.bg-blue-500 { background-color: var(--color-blue-500); }
.hover\:bg-blue-700:hover { background-color: var(--color-blue-700); }
```

`hover:` というバリアントは、要するに **CSS の `:hover` セレクタを生成するための指示**だったわけです。バリアントとは「ユーティリティを、特定のセレクタやメディアクエリでくるむためのルール」だと理解してください。インラインスタイル（`style` 属性）では `:hover` も `@media` も書けないので、これはユーティリティクラスならではの表現力です。

## 6.2 状態系のバリアント

ユーザーの操作や要素の状態に応じたバリアントです。よく使うものを挙げます。

```html
<button class="bg-blue-500 hover:bg-blue-600 active:bg-blue-700 focus:ring-2 disabled:opacity-50">
  送信
</button>
```

- `hover:` … マウスが乗っているとき（`:hover`）
- `focus:` … フォーカスが当たっているとき（`:focus`）
- `focus-visible:` … キーボード操作などでフォーカスが当たったとき。マウスクリック時には出さない、アクセシビリティに配慮したフォーカス表示に使います（第21章）
- `active:` … 押されている最中（`:active`）
- `disabled:` … 無効化されているとき（`:disabled`）

いずれも、対応する CSS の擬似クラスに変換されているだけです。

## 6.3 構造系のバリアント

要素の位置や状態（何番目か、空かどうか）に応じたバリアントです。リストやテーブルで活躍します。

```html
<ul>
  <li class="border-b last:border-b-0 odd:bg-gray-50">項目</li>
</ul>
```

- `first:` / `last:` … 最初 / 最後の子要素（`:first-child` / `:last-child`）
- `odd:` / `even:` … 奇数番目 / 偶数番目（`:nth-child(odd)` など）。表の縞模様（ゼブラ）に便利
- `only:` … 子要素が 1 つだけのとき
- `empty:` … 中身が空のとき

## 6.4 グループ・ピア（`group-*` / `peer-*`）

ここからが、バリアントの真価が出るところです。「**ある要素の状態に応じて、別の要素のスタイルを変えたい**」という、素の CSS では少し書きづらいことを、宣言的に書けます。

**`group-*`（親の状態に子が反応する）**

親に `group` を付け、子に `group-hover:` などを付けると、**親がホバーされたときに子のスタイルが変わります**。カード全体にマウスを乗せたら、中のタイトルの色を変える、といった定番の表現です。

```html
<a href="#" class="group block p-4">
  <h3 class="text-gray-900 group-hover:text-blue-600">プロジェクト</h3>
  <p class="text-gray-500 group-hover:text-gray-700">説明文</p>
</a>
```

**`peer-*`（兄弟の状態に反応する）**

`peer` を付けた要素の状態に、**同じ階層の別の要素**が反応します。フォームで「入力が不正なときにエラーメッセージを出す」といった用途が代表的です。

```html
<input type="email" class="peer border" />
<p class="invisible peer-invalid:visible text-red-600">
  有効なメールアドレスを入力してください
</p>
```

入力欄（`peer`）が `:invalid` のとき、後ろのメッセージが表示されます。JavaScript を書かずに、状態と見た目を連動させられるのがポイントです（フォームは第20章）。

## 6.5 メディア系のバリアント

画面や環境の条件に応じたバリアントです。中身は CSS のメディアクエリです。

- **ブレークポイント**（`sm:` `md:` `lg:` `xl:` `2xl:`）… 画面幅に応じた切り替え（第17章で詳述）
- `dark:` … ダークモードのとき（第18章）
- `motion-reduce:` … ユーザーが「視差効果を減らす」設定にしているとき。過剰なアニメーションを抑えるために使います（第19章・第21章）
- `print:` … 印刷時

```html
<div class="text-base md:text-lg dark:text-gray-200 print:text-black">...</div>
```

v4 のブレークポイントは、デフォルトで `sm`=40rem(640px)、`md`=48rem(768px)、`lg`=64rem(1024px)、`xl`=80rem(1280px)、`2xl`=96rem(1536px) です。生成されるメディアクエリは `@media (width >= 48rem)` のような新しい範囲記法になっています。

## 6.6 属性・データ系のバリアント

HTML の属性に応じてスタイルを当てるバリアントです。アクセシビリティ属性や、自前の状態管理と相性が良いものです。

```html
<button aria-pressed="true" class="aria-pressed:bg-blue-600">トグル</button>
<div data-size="large" class="data-[size=large]:p-8">...</div>
```

- `aria-*:` … `aria-checked` や `aria-pressed` などの ARIA 属性に反応。状態を見た目に反映できます（第21章）
- `data-*:` … `data-` 属性に反応。`data-[size=large]:p-8` のように属性の値で分岐もできます。JavaScript フレームワークが要素に付ける状態（開いている/選択中など）と組み合わせると強力です

v4 では、`data-*` バリアントが標準でかなり柔軟に書けるようになりました。Stimulus（Rails）や各種 UI ライブラリが付与する `data-` 属性をそのままスタイリングのフックにできます。

## 6.7 `has-*` ・ `not-*` ・ `*`

比較的新しい CSS 機能に対応したバリアントです。

- **`has-*`**（親が特定の子を持つとき）… CSS の `:has()` に対応。「中にチェック済みのラジオがあるラベルの背景を変える」など、これまで JavaScript が必要だった表現を CSS だけで書けます。

```html
<label class="has-checked:bg-indigo-50 p-4 border rounded">
  <input type="radio" name="plan" /> プラン A
</label>
```

- **`not-*`**（v4）… `:not()` に対応。「ホバーされて**いない**とき」のような否定条件を書けます。
- **`*`**（直接の子すべて）… 直接の子要素すべてに同じスタイルを当てます。`*:`（直接の子）や `**:`（すべての子孫）といった形があります。

これらは「素の CSS の進化を、ユーティリティのまま使える」ようにしたものです。Tailwind がモダン CSS の薄いラッパーである、という性格がよく表れています。

## 6.8 バリアントのスタック（評価順）

バリアントは**重ねがけ（スタック）**できます。`dark:` かつ `md:` 以上かつ `hover:` のとき、というように条件を組み合わせられます。

```html
<button class="dark:md:hover:bg-fuchsia-600">保存</button>
```

これは「ダークモードで、画面が md 以上で、ホバーされているとき」に背景色を変える、という意味です。生成される CSS は、メディアクエリの入れ子と擬似クラスの組み合わせになります（簡略化）。

```css
@media (prefers-color-scheme: dark) {
  @media (width >= 48rem) {
    .dark\:md\:hover\:bg-fuchsia-600:hover {
      background-color: var(--color-fuchsia-600);
    }
  }
}
```

複雑に見えますが、左から順に条件を絞り込んでいるだけです。なお、書く順番は読みやすさのために**「環境 → 状態」の順（`dark:md:hover:`）に揃える**チーム規約にしておくと、後から読みやすくなります。

## 6.9 カスタムバリアント（`@custom-variant`）

用意されたバリアントで足りないときは、自分でバリアントを定義できます。v4 では `@custom-variant` ディレクティブを使います。

```css
@custom-variant pointer-coarse (@media (pointer: coarse));
```

これで `pointer-coarse:p-6`（指で操作するタッチデバイスのとき余白を広げる）のように使えます。

実は、v4 のダークモードを「手動切り替え（クラス方式）」にする設定も、このカスタムバリアントで書きます。

```css
@custom-variant dark (&:where(.dark, .dark *));
```

こう書くと、`dark:` は「OS 設定」ではなく「`.dark` クラスが祖先に付いているとき」に効くようになります（第18章で詳しく扱います）。

ここまでで、Tailwind の三本柱——**ユーティリティの生成（第4章）・テーマ（第5章）・バリアント（第6章）**——がそろいました。この 3 つが分かれば、Tailwind の挙動はもう「魔法」ではありません。次の第3部では、これらを実際に動かすための**環境構築**に進みます。

## 参考資料

* Tailwind CSS Docs — Hover, focus, and other states（各種バリアント・スタック）: https://tailwindcss.com/docs/hover-focus-and-other-states
* Tailwind CSS Docs — Responsive design（ブレークポイント・max-* ・container queries）: https://tailwindcss.com/docs/responsive-design
* Tailwind CSS Docs — Dark mode（dark: ・@custom-variant dark）: https://tailwindcss.com/docs/dark-mode
* Tailwind CSS Docs — Functions and directives（@custom-variant）: https://tailwindcss.com/docs/functions-and-directives

---
