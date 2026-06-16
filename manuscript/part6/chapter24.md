# 第24章 Rails でのコンポーネント設計

本書が最重点とする Rails です。Rails には、ビューを再利用可能な部品にまとめる方法が複数あります。それぞれの性格を理解し、Tailwind と相性よく使い分けましょう。

## 24.1 Rails でのコンポーネント化の選択肢

Rails でのコンポーネント化には、主に 3 つの選択肢があります。

| 方法 | 性格 | 向いている場面 |
| --- | --- | --- |
| **部分テンプレート（partial）** | Rails 標準。学習コストゼロ | まず重複を減らしたい。小〜中規模 |
| **ViewComponent** | Ruby オブジェクトとして部品化。テスト容易 | ロジックを持つ部品、再利用と品質を重視 |
| **Phlex** | HTML を Ruby で書く | Ruby で完結させたい、合成を多用したい |

重み付けの目安はこうです。**まずは partial で十分**です。多くのプロジェクトは partial だけで重複を解消できます。部品にロジックやバリアントが増え、テストもしたくなってきたら **ViewComponent** を検討します。**Phlex** は、テンプレート言語ではなく Ruby で書きたいチームの選択肢です。いきなり凝った仕組みを入れず、必要に応じて段階的に上げていくのが Rails らしいやり方です。

## 24.2 部分テンプレートとクラス組み立て

最も基本的な方法が部分テンプレートです。[第22章](chapter22.md)でも見たとおり、クラス列を partial の中に閉じ込めます。バリアントを扱いたいときは、`locals` で受け取った値に応じてクラスを組み立てます。Ruby 側でクラスを組み立てるとき、Rails の `class_names`（または `token_list`）ヘルパーが `clsx` に近い役割を果たします。

```erb
<%# app/views/shared/_button.html.erb %>
<%# 使い方: render "shared/button", label: "削除", intent: :danger %>
<%# intent は省略可能にする（未定義 local の直接参照は NameError になるため） %>
<% intent = local_assigns.fetch(:intent, :primary) %>
<% base = "inline-flex items-center rounded-md px-4 py-2 text-sm font-medium" %>
<% styles = {
     primary: "bg-blue-600 text-white hover:bg-blue-700",
     danger:  "bg-red-600 text-white hover:bg-red-700",
   } %>
<button class="<%= class_names(base, styles.fetch(intent)) %>">
  <%= label %>
</button>
```

`class_names` は、条件付きのクラスや配列を受け取って 1 つの文字列にまとめてくれる Rails 標準のヘルパーです。「Rails だけで `clsx` 相当のことができる」と覚えておきましょう。

## 24.3 ViewComponent

partial が大きくなり、ロジックやバリアントが増えてくると、**ViewComponent** が活きてきます。これは「**コンポーネントを Ruby のクラス＋テンプレートの組**として定義する」Rails 向けの主要なコンポーネントライブラリで、Rails とシームレスに統合でき、再利用・テスト・カプセル化に優れます（Rails 本体の機能ではなく、独立した gem です。現行の v4 は長期サポート対象で、機能的に安定した段階に入っています）。

```ruby
# app/components/button_component.rb
class ButtonComponent < ViewComponent::Base
  BASE = "inline-flex items-center rounded-md px-4 py-2 text-sm font-medium"
  STYLES = {
    primary: "bg-blue-600 text-white hover:bg-blue-700",
    danger:  "bg-red-600 text-white hover:bg-red-700",
  }.freeze

  def initialize(label:, intent: :primary)
    @label = label
    @intent = intent
  end

  def classes
    class_names(BASE, STYLES.fetch(@intent))
  end
end
```

```erb
<%# app/components/button_component.html.erb %>
<button class="<%= classes %>"><%= @label %></button>
```

```erb
<%= render(ButtonComponent.new(label: "削除", intent: :danger)) %>
```

クラスの組み立てロジックが Ruby のメソッドに収まり、**コンポーネント単体でテストできる**のが大きな利点です。「このコンポーネントは danger のとき赤背景のクラスを持つ」といったテストが書けます。バリアントの種類が多い部品ほど、この構造が効きます。

## 24.4 Phlex

**Phlex** は、テンプレート言語（ERB）を使わず、**HTML を Ruby のコードとして書く**ライブラリです。ビューを Ruby オブジェクトとして組み立てたいチームに向きます。

```ruby
class Button < Phlex::HTML
  def initialize(label:, intent: :primary)
    @label = label
    @intent = intent
  end

  def view_template
    button(class: classes) { @label }
  end

  private

  def classes
    base = "inline-flex items-center rounded-md px-4 py-2 text-sm font-medium"
    styles = { primary: "bg-blue-600 text-white", danger: "bg-red-600 text-white" }
    "#{base} #{styles[@intent]}"
  end
end
```

Ruby のメソッドや継承でビューを合成できるため、共通のレイアウトを継承して個別ボタンを作る、といった**オブジェクト指向的な再利用**が自然にできます。Tailwind のクラスは、ただの文字列として Ruby の中で組み立てればよいので、相性は良好です。

## 24.5 Rails で CVA 的なバリアント管理を実現する

React の CVA（[第23章](chapter23.md)）に当たる「宣言的なバリアント管理」は、Rails でも Ruby のハッシュとヘルパーで十分に表現できます。専用ライブラリがなくても、考え方を移植すればよいのです。

```ruby
# 共通化したバリアントビルダーの例
module ButtonStyles
  BASE = "inline-flex items-center rounded-md font-medium"
  INTENT = {
    primary: "bg-blue-600 text-white hover:bg-blue-700",
    danger:  "bg-red-600 text-white hover:bg-red-700",
  }.freeze
  SIZE = { sm: "px-3 py-1.5 text-sm", md: "px-4 py-2 text-sm", lg: "px-6 py-3" }.freeze

  def self.call(intent: :primary, size: :md)
    [BASE, INTENT.fetch(intent), SIZE.fetch(size)].join(" ")
  end
end

# 使い方
ButtonStyles.call(intent: :danger, size: :lg)
```

CVA の `variants`／`defaultVariants` を、ハッシュと `fetch`、デフォルト引数で再現しています。ViewComponent と組み合わせれば、型こそ付かないものの、CVA とよく似た見通しのよいバリアント管理ができます。

## 24.6 Hotwire（Turbo / Stimulus）と動的クラス操作

Rails の標準フロントエンドである **Hotwire**（Turbo / Stimulus）と Tailwind の組み合わせも押さえましょう。

[第8章](../part3/chapter8.md)で触れたとおり、Turbo がページを部分的に差し替えても、**そのクラスがソースコード中に文字列として存在していれば**スタイルは正しく当たります。動的に組み立てたクラス名が検出されないという原則（[第4章](../part2/chapter4.md)・[第27章](../part7/chapter27.md)）は、ここでも同じです。

ダークモードのトグル（[第18章](../part5/chapter18.md)）やメニューの開閉のような**クラスの付け外し**は、Stimulus コントローラーで行うのが Rails 流です。

```js
// app/javascript/controllers/toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    document.documentElement.classList.toggle("dark")
  }
}
```

[第6章](../part2/chapter6.md)で見た `data-*` バリアントは、Stimulus が付与する `data-` 属性と非常に相性が良く、「開いているときだけスタイルを変える」といった表現を、JavaScript を最小限にして書けます。

## 24.7 実務: 既存 Rails アプリへの段階的導入

既存の Rails アプリに Tailwind を入れるときは、一気に全部を置き換えようとしないことが肝心です。おすすめの順序は、(1) `tailwindcss-rails` を導入（[第8章](../part3/chapter8.md)）→ (2) 新しく作る画面から Tailwind で書く → (3) 既存画面は触るついでに少しずつ移行、です。既存の CSS との衝突が心配なら、[第4章](../part2/chapter4.md)で触れた **prefix** で名前空間を分ける手もあります。コンポーネント化も同様に、まず partial、痛くなったら ViewComponent、と段階的に育てれば、移行のリスクを抑えられます。

## 参考資料

* [ViewComponent（公式サイト）](https://viewcomponent.org/)
* [Phlex（公式サイト）](https://www.phlex.fun/)
* [tailwindcss-rails（GitHub）](https://github.com/rails/tailwindcss-rails)
* [Rails API — `class_names` / `token_list`](https://api.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html)

