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
