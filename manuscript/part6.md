# 第6部 コンポーネント設計

ここまで何度も「繰り返しはコンポーネント化で解決します」と先送りにしてきました。第6部で、その約束を回収します。

第3章で見たとおり、Tailwind の「クラスが長くなる」という弱点は、**同じ長いクラス列を何度も書くとき**に最も痛みになります。ボタンを 50 か所に置くのに、毎回 15 個のクラスをコピーするのは現実的ではありません。この重複をどう減らすか——それがこの部のテーマです。

ただし、減らし方には**良い方法と悪い方法**があります。第22章でまず「`@apply` で CSS に逃がす」という一見便利な方法の落とし穴を理解し、なぜコンポーネント抽出が推奨されるのかを腹落ちさせます。第23章では再利用を支える道具（`clsx`・`tailwind-merge`・CVA）を、第24章では Rails、第25章では React での具体的な設計を扱います。

---

# 第22章 UI コンポーネントを作る

## 22.1 「重複」をどう捉えるか

まず大前提として、Tailwind における重複は「悪」と決めつけないことが大切です。`p-4`・`bg-white` のようなユーティリティが画面のあちこちに現れるのは、第3章で見たとおり**設計どおり**であって、問題ではありません。生成される CSS は `.p-4` ひとつだけなので、いくら使っても CSS は増えません。

問題になるのは、**「ボタン」「カード」のような意味のあるまとまりが、長いクラス列ごと何度も複製される**ときです。

```html
<!-- 同じボタンを 3 か所に……長いクラス列が複製される -->
<button class="inline-flex items-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700">保存</button>
<button class="inline-flex items-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700">送信</button>
<button class="inline-flex items-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700">更新</button>
```

これだと、ボタンのデザインを変えるとき 3 か所すべてを直す必要があり、修正漏れも起きます。これこそが「コンポーネント化で解決すべき重複」です。

重複への対処には、大きく 2 つの方向があります。1 つは `@apply` で CSS にまとめる方法、もう 1 つはテンプレート/コンポーネントとして抽出する方法です。順に見ていきます。

## 22.2 `@apply` の役割と落とし穴

`@apply` は、ユーティリティクラスを**自前の CSS クラスの中に展開する**ディレクティブです（第2部）。

```css
.btn-primary {
  @apply inline-flex items-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700;
}
```

```html
<button class="btn-primary">保存</button>
```

これを見ると、「HTML がすっきりして最高では？」と思うかもしれません。実際、`@apply` は便利に**見えます**。しかし、ここには大きな落とし穴があります。

`@apply` で `.btn-primary` を作るということは、**第1章で見た「セマンティックなクラス名を作る世界」に逆戻りしている**ということです。考えてみてください。

- `.btn-primary` という**名前を考える**必要が再び生まれる（命名コストの復活）。
- このクラスは CSS ファイルに存在するので、**CSS が再び増えていく**（線形に増えない、という利点の放棄）。
- 見た目を知るには、HTML から CSS ファイルへ**行き来する**必要が戻ってくる。
- 結局、BEM 時代と同じ「グローバルな CSS クラス」を管理することになる。

つまり `@apply` を多用すると、Tailwind を導入してわざわざ捨てたはずの問題が、そっくり戻ってくるのです。HTML が一瞬きれいに見える代償として、Tailwind の利点をほとんど手放してしまいます。

## 22.3 `@apply` よりコンポーネント抽出が推奨される理由

では作者やコミュニティは、重複にどう対処せよと言っているのでしょうか。答えは明確で、**`@apply` ではなく、テンプレートやコンポーネントとして抽出せよ**、です。

Tailwind 公式ドキュメントも、重複の管理方法として最初に挙げるのは「テンプレートのループ」や「コンポーネント/部分テンプレートへの抽出」であり、`@apply` は最後にわずかに触れられるだけです。さらに公式は、`@apply` について「**マークアップを整理したいという理由だけで使うのは避けるべき**」という趣旨の注意を添えています。

理由は 22.2 の裏返しです。コンポーネント抽出なら、

- **命名は最小限で済む**（`Button` という部品名は要るが、CSS クラスの命名体系は不要）。
- **CSS は増えない**（クラス列は HTML/テンプレート側にあるまま）。
- **見た目はその場で分かる**（コンポーネントの定義を 1 か所見ればよい）。
- **props でバリエーションを表現できる**（色やサイズを引数で変えられる。`@apply` ではできない）。

`@apply` が正当化されるのは、ごく限られた場面だけです。たとえば、自分でコントロールできない外部のマークアップ（第三者のウィジェットなど）にスタイルを当てる必要があり、かつコンポーネント化できないケース。こうした例外を除けば、**重複は CSS にではなく、テンプレート/コンポーネントに畳み込む**——これが鉄則です。

## 22.4 ボタンを題材にした抽出

「抽出」とは具体的にどうすることか。同じボタンを、各環境での部品にまとめてみます。クラス列が現れるのは**定義の 1 か所だけ**になり、使う側はすっきりします。

**HTML だけの場合（テンプレートのループ）**: データを配列にして繰り返せば、クラス列は 1 か所で済みます。

**Rails（部分テンプレート）**:

```erb
<%# app/views/shared/_button.html.erb %>
<button class="inline-flex items-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700">
  <%= label %>
</button>
```

```erb
<%= render "shared/button", label: "保存" %>
```

**React（コンポーネント）**:

```tsx
function Button({ children }: { children: React.ReactNode }) {
  return (
    <button className="inline-flex items-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700">
      {children}
    </button>
  )
}
```

```tsx
<Button>保存</Button>
```

どちらも、長いクラス列は部品の中に 1 度だけ書かれ、呼び出し側は `render "shared/button"` や `<Button>` と書くだけです。これが「重複を CSS ではなくコンポーネントに畳み込む」ということです。

## 22.5 カスタムユーティリティとコンポーネントクラスの境界

ここで線引きを整理しておきます。「自前の CSS クラスを作るな」と言っているわけではありません。問題は「何を CSS に置き、何をコンポーネントに置くか」です。

- **コンポーネント（ボタン、カードなど意味のあるまとまり）** → テンプレート/コンポーネントに抽出する（`@apply` で CSS クラスにしない）。
- **本当に汎用的な、単機能の拡張** → v4 の `@utility` でカスタムユーティリティとして定義してよい。

`@utility` は、Tailwind の流儀に沿った「新しいユーティリティを 1 つ足す」仕組みです（第2部・第26章）。

```css
@utility content-auto {
  content-visibility: auto;
}
```

これは `content-auto` という**単機能のユーティリティ**を増やすもので、`hover:` などのバリアントとも組み合わせられます。「ボタン全体」のような複合的なまとまりを 1 クラスに押し込む `@apply` とは、性質がまったく違います。**複合的なまとまりはコンポーネントへ、単機能の拡張は `@utility` へ**——この境界を覚えておけば、CSS を不健全に太らせずに済みます。

## 参考資料

* Tailwind CSS Docs — Styling with utility classes（Managing duplication / Avoiding @apply）: https://tailwindcss.com/docs/styling-with-utility-classes
* Tailwind CSS Docs — Functions and directives（@apply / @utility）: https://tailwindcss.com/docs/functions-and-directives

---

# 第23章 再利用性を高める

第22章で「コンポーネントに抽出する」方針が固まりました。この章では、抽出したコンポーネントを**実用的に使えるものにする**ための道具を見ます。ボタンに色やサイズのバリエーションを持たせたり、外から追加のクラスを受け取れるようにしたりする工夫です。主に React/JavaScript の文脈ですが、考え方は Rails にも応用できます（第24章）。

## 23.1 クラス名が長くなる問題への現実的対処

コンポーネントに抽出しても、「中のクラス列が長い」こと自体は変わりません。これは Tailwind の本質的なトレードオフ（第3章）なので、なくすことはできません。現実的な対処は次の通りです。

- **長いクラス列が見えるのは定義の 1 か所だけ**にする（第22章の抽出）。
- **クラスの並び順をそろえる**（第9章の `prettier-plugin-tailwindcss`）。
- **バリアントごとにクラスを整理する**（後述の CVA）。

「長さをゼロにする」のではなく「長さを 1 か所に閉じ込めて管理する」のが、実務的なゴールです。

## 23.2 条件付きクラスの組み立て（clsx / classnames）

コンポーネントでは、「状態に応じてクラスを付け外しする」ことが頻繁にあります。たとえば「選択中なら背景を青く」といった具合です。素朴に書くと、文字列の連結で読みにくくなります。

これを整理するのが **`clsx`**（や同種の `classnames`）です。条件に応じて className 文字列を組み立てる、ごく小さなユーティリティです。

```tsx
import clsx from 'clsx'

clsx('px-4 py-2', isActive && 'bg-blue-600 text-white', isDisabled && 'opacity-50')
// isActive が true なら 'px-4 py-2 bg-blue-600 text-white'
```

`false` や `null` は自動で無視されるので、三項演算子や `&&` で素直に条件分岐を書けます。

## 23.3 クラス衝突の解消（tailwind-merge）

`clsx` には解決できない問題があります。**クラスの衝突**です。第4章で見たとおり、`p-4` と `p-8` のように同じプロパティを扱うクラスを両方並べても、勝つのは CSS 上の順序で決まり、HTML の並び順では決まりません。これはコンポーネントに「外から上書き用のクラスを渡したい」ときに困ります。

```tsx
// 中で p-2、外から p-4 を渡したい → 単純連結だと両方残り、意図通りにならない
<Button className="p-4" />  // 中: 'p-2' + 外: 'p-4' = 'p-2 p-4'
```

これを解決するのが **`tailwind-merge`** です。Tailwind のクラスを賢く解釈し、**衝突するものは後勝ちで 1 つにまとめて**くれます。

```ts
import { twMerge } from 'tailwind-merge'

twMerge('px-2 py-1 bg-red-500', 'p-3 bg-blue-500')
// → 'p-3 bg-blue-500'（px-2 py-1 は p-3 に、bg-red-500 は bg-blue-500 に吸収）
```

実務では、`clsx`（条件分岐）と `twMerge`（衝突解消）を組み合わせた **`cn` というヘルパー**を用意するのが定番です。

```ts
// よくある cn ヘルパー
import { clsx, type ClassValue } from 'clsx'
import { twMerge } from 'tailwind-merge'

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

役割分担は明確です。**`clsx` が「条件に応じて集める」、`tailwind-merge` が「衝突を解いて最終的な 1 列にする」**。この `cn` が、次章以降のコンポーネント設計の土台になります。

## 23.4 バリアント設計: Class Variance Authority（CVA）

ボタンには「色（primary / secondary / danger）」「サイズ（sm / md / lg）」のようなバリエーションが付きものです。これを `clsx` の条件分岐だけで書くと、すぐにごちゃごちゃになります。

ここで使うのが **CVA（Class Variance Authority）** です。これは「**どの props のとき、どのクラスを当てるか**」を宣言的に定義できるライブラリで、型安全にバリアントを管理できます（Joe Bell によるメンテナンス）。

```ts
import { cva } from 'class-variance-authority'

const button = cva(
  // 常に当たる基本クラス
  'inline-flex items-center rounded-md font-medium',
  {
    variants: {
      intent: {
        primary: 'bg-blue-600 text-white hover:bg-blue-700',
        secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200',
        danger: 'bg-red-600 text-white hover:bg-red-700',
      },
      size: {
        sm: 'px-3 py-1.5 text-sm',
        md: 'px-4 py-2 text-sm',
        lg: 'px-6 py-3 text-base',
      },
    },
    defaultVariants: { intent: 'primary', size: 'md' },
  }
)

button({ intent: 'danger', size: 'lg' })
// → 基本クラス + danger のクラス + lg のクラス
```

`intent` や `size` という props と、当てるクラスの対応が 1 か所にまとまり、見通しが格段に良くなります。しかも TypeScript で「存在しないバリアントを渡したらエラー」にできるので、安全です。

## 23.5 デザイントークンを単一の真実にする

ここまでの道具（`cn`・CVA）は、あくまで「クラスをどう組み立てるか」の話です。その土台として、**何色・何 px を使うか**は、第5章のテーマ（`@theme`）に集約しておくべきです。

CVA のバリアントに `bg-blue-600` のような直値を書いていても、その `blue-600` 自体はテーマで定義されたトークンです。さらに第12章で触れたセマンティックトークン（`bg-primary` など）をテーマに用意しておけば、CVA の定義も `bg-primary` のように意味で書けて、ブランド変更にも強くなります。**「値はテーマ、組み立ては CVA/cn」**という二層構造が、保守しやすいコンポーネントの基本形です。

## 23.6 実務: デザインシステムへの育て方

これらを組み合わせると、自然と「自分たちのデザインシステム」が育ちます。育て方の順序はこうです。

1. まずベタ書きで作る（早く動かす）。
2. 重複してきたらコンポーネントに抽出する（第22章）。
3. バリエーションが増えてきたら CVA で整理する。
4. 共通の値はテーマトークンに集約する。

最初から完璧なデザインシステムを作ろうとせず、**重複が痛くなってきた箇所から段階的に育てる**のが、現実的で失敗しにくいやり方です。

## 23.7 AI 生成コードとクラス設計

近年は、ChatGPT や Cursor、Copilot のような AI が Tailwind のコードを生成する機会が増えました。AI は Tailwind を出力しやすい（クラスがそのまま見た目を表し、学習データも豊富なため）一方で、**長いクラス列をベタ書きで吐き、任意の値やトークンを無視した直値を混ぜがち**という傾向があります。

そこで、本章の道具が AI 時代にこそ効きます。AI が生成した長いクラス列を、人間が **CVA やコンポーネントへ畳み込み**、直値はテーマトークンに寄せて整える。AI には「既存のテーマ変数とコンポーネント規約に従って」と前提を渡す（第26章・付録E）。生成して終わりにせず、本章の設計に取り込むことで、AI の速度と設計の一貫性を両立できます。

## 参考資料

* clsx（GitHub）: https://github.com/lukeed/clsx
* tailwind-merge（GitHub）: https://github.com/dcastil/tailwind-merge
* Class Variance Authority（公式サイト）: https://cva.style/
* Tailwind CSS Docs — Theme: https://tailwindcss.com/docs/theme

---

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

最も基本的な方法が部分テンプレートです。第22章でも見たとおり、クラス列を partial の中に閉じ込めます。バリアントを扱いたいときは、`locals` で受け取った値に応じてクラスを組み立てます。Ruby 側でクラスを組み立てるとき、Rails の `class_names`（または `token_list`）ヘルパーが `clsx` に近い役割を果たします。

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

React の CVA（第23章）に当たる「宣言的なバリアント管理」は、Rails でも Ruby のハッシュとヘルパーで十分に表現できます。専用ライブラリがなくても、考え方を移植すればよいのです。

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

第8章で触れたとおり、Turbo がページを部分的に差し替えても、**そのクラスがソースコード中に文字列として存在していれば**スタイルは正しく当たります。動的に組み立てたクラス名が検出されないという原則（第4章・第27章）は、ここでも同じです。

ダークモードのトグル（第18章）やメニューの開閉のような**クラスの付け外し**は、Stimulus コントローラーで行うのが Rails 流です。

```js
// app/javascript/controllers/toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    document.documentElement.classList.toggle("dark")
  }
}
```

第6章で見た `data-*` バリアントは、Stimulus が付与する `data-` 属性と非常に相性が良く、「開いているときだけスタイルを変える」といった表現を、JavaScript を最小限にして書けます。

## 24.7 実務: 既存 Rails アプリへの段階的導入

既存の Rails アプリに Tailwind を入れるときは、一気に全部を置き換えようとしないことが肝心です。おすすめの順序は、(1) `tailwindcss-rails` を導入（第8章）→ (2) 新しく作る画面から Tailwind で書く → (3) 既存画面は触るついでに少しずつ移行、です。既存の CSS との衝突が心配なら、第4章で触れた **prefix** で名前空間を分ける手もあります。コンポーネント化も同様に、まず partial、痛くなったら ViewComponent、と段階的に育てれば、移行のリスクを抑えられます。

## 参考資料

* ViewComponent（公式サイト）: https://viewcomponent.org/
* Phlex（公式サイト）: https://www.phlex.fun/
* tailwindcss-rails（GitHub）: https://github.com/rails/tailwindcss-rails
* Rails API — `class_names` / `token_list`: https://api.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html

---

# 第25章 React でのコンポーネント設計

React では、第23章の道具（`cn`・CVA）がそのまま主役になります。この章では、それらを使った実践的なコンポーネント設計と、Headless UI・shadcn/ui という 2 つの重要なエコシステムを扱います。

## 25.1 props でバリアントを受けるコンポーネント設計

React のコンポーネントは、props でバリエーションを受け取るのが基本です。第23章の CVA と組み合わせると、型安全で見通しのよいボタンが作れます。

```tsx
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from './cn'

const button = cva('inline-flex items-center rounded-md font-medium', {
  variants: {
    intent: {
      primary: 'bg-blue-600 text-white hover:bg-blue-700',
      secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200',
    },
    size: { sm: 'px-3 py-1.5 text-sm', md: 'px-4 py-2 text-sm' },
  },
  defaultVariants: { intent: 'primary', size: 'md' },
})

type ButtonProps = React.ComponentProps<'button'> & VariantProps<typeof button>

export function Button({ intent, size, className, ...props }: ButtonProps) {
  return <button className={cn(button({ intent, size }), className)} {...props} />
}
```

## 25.2 `cn` ヘルパー（clsx + tailwind-merge）の定番パターン

上のコードの `cn(button({ intent, size }), className)` が肝心です。これは第23章で作った `cn`（`clsx` + `tailwind-merge`）です。

- `button({ intent, size })` が CVA で組み立てたクラス列を返す。
- そこに、利用側から渡された `className` を**後ろに足す**。
- `cn` の中の `tailwind-merge` が、**衝突を後勝ちで解消**する。

これにより、`<Button className="rounded-full">` のように利用側が一部だけ上書きしたとき、CVA 既定の `rounded-md` を `rounded-full` がきれいに置き換えます。**「コンポーネントの既定 ＋ 利用側の上書き」を破綻なく合成する**——この `cn` パターンが、現代の React × Tailwind の標準形です。

## 25.3 CVA による型安全なバリアント

CVA の `VariantProps<typeof button>` を使うと、コンポーネントの props 型が**バリアント定義から自動で導出**されます。`intent` に `'primary' | 'secondary'` 以外を渡すと、TypeScript がコンパイル時にエラーにしてくれます。バリアントの定義（クラス）と型が 1 か所に集約され、ずれが起きないのが大きな利点です。

## 25.4 Headless UI / Radix + Tailwind の組み合わせ

第21章で触れたとおり、モーダルやドロップダウンのような複雑な UI を**アクセシブルに**作るのは難しい仕事です。フォーカス管理、キーボード操作、ARIA 属性——これらを自前で完璧にやるのは現実的ではありません。

そこで、**Headless UI**（Tailwind Labs 製）や **Radix UI** のような「**スタイルを持たないが、アクセシビリティと挙動は作り込まれている**」ライブラリを使います。これらは見た目を持たないので、Tailwind のユーティリティで自由に装飾できます。

```tsx
import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/react'

<Menu>
  <MenuButton className="rounded-md bg-blue-600 px-4 py-2 text-white">
    オプション
  </MenuButton>
  <MenuItems className="mt-2 rounded-md border bg-white shadow-lg">
    <MenuItem>
      {/* キーボード操作・フォーカス・ARIA はライブラリが面倒を見る */}
      <a className="block px-4 py-2 data-focus:bg-gray-100" href="#">編集</a>
    </MenuItem>
  </MenuItems>
</Menu>
```

**挙動とアクセシビリティはライブラリ、見た目は Tailwind** という分担が、最も効率がよく、間違いも起きにくいやり方です。

## 25.5 shadcn/ui に見る「コピーして所有する」コンポーネント観

React × Tailwind のエコシステムで、いま最も影響力があるのが **shadcn/ui** です。これは、従来の UI ライブラリとは**思想がまったく違う**点を理解することが重要です。

従来の UI ライブラリは、npm でインストールして「依存パッケージとして使う」ものでした。中身はブラックボックスで、カスタマイズはライブラリが許した範囲に限られます。

shadcn/ui はそうではありません。これは**「コンポーネントのコードを、自分のプロジェクトにコピーして取り込む」**という形をとります。コピーした時点で、そのコードは**あなたのもの**になります。中身は Tailwind のクラスと、第23章で見た `cn`・CVA・Radix などで書かれた、ふつうの React コンポーネントです。だから、

- 中身が完全に見えて、好きなように書き換えられる（Open Code）。
- ライブラリのバージョンアップに振り回されない。
- 第23章で学んだ道具がそのまま使われているので、構造を理解できる。

shadcn/ui は自身を「**インストールする UI ライブラリではなく、自分の UI ライブラリの作り方**」だと位置づけています。「完成品を借りる」のではなく、「**良い出発点をコピーして所有し、育てる**」もの——この捉え方ができると、shadcn/ui を正しく使えます。逆に「便利な部品集」として依存し、中身を理解しないままコピーを増やすと、結局メンテナンスできないコードを抱えることになります。

## 25.6 Next.js での注意（Server Components・動的クラス生成の回避）

最後に Next.js 特有の注意です。第8章で触れたとおり、App Router ではコンポーネントがサーバーコンポーネントとして動くことがあります。スタイリングの観点で重要なのは、ここでも第4章・第27章の原則——**クラス名を動的に組み立てない**ことです。

```tsx
// NG: bg-${color}-600 はビルド時に検出されず、CSS が生成されない
function Badge({ color }: { color: string }) {
  return <span className={`bg-${color}-600`}>...</span>
}

// OK: 完全なクラス名をマッピングして渡す
const COLORS = { red: 'bg-red-600', blue: 'bg-blue-600' } as const
function Badge({ color }: { color: keyof typeof COLORS }) {
  return <span className={COLORS[color]}>...</span>
}
```

サーバーコンポーネントでもクライアントコンポーネントでも、Tailwind が静的にクラスを走査するという仕組み（第4章）は変わりません。CVA を使うと、この「完全なクラス名をマッピングする」形が自然に守られるため、結果として安全になります。

第6部はここまでです。`@apply` に逃げず、コンポーネントに抽出し、`cn`・CVA・テーマトークンで再利用可能に育て、Rails では partial → ViewComponent / Phlex、React では Headless UI / shadcn/ui を活用する——Tailwind を「大量のクラス」から「整然としたデザインシステム」へと昇華させる道筋を見てきました。次の第7部では、これらを**実務のプロジェクト全体**で運用するための構成・アンチパターン・評価に踏み込みます。

## 参考資料

* shadcn/ui（公式サイト・ドキュメント）: https://ui.shadcn.com/docs
* Headless UI（公式サイト）: https://headlessui.com/
* Radix Primitives（公式サイト）: https://www.radix-ui.com/primitives
* Class Variance Authority（公式サイト）: https://cva.style/
* tailwind-merge（GitHub）: https://github.com/dcastil/tailwind-merge
