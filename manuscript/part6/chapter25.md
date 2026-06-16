# 第25章 React でのコンポーネント設計

React では、[第23章](chapter23.md)の道具（`cn`・CVA）がそのまま主役になります。この章では、それらを使った実践的なコンポーネント設計と、Headless UI・shadcn/ui という 2 つの重要なエコシステムを扱います。

## 25.1 props でバリアントを受けるコンポーネント設計

React のコンポーネントは、props でバリエーションを受け取るのが基本です。[第23章](chapter23.md)の CVA と組み合わせると、型安全で見通しのよいボタンが作れます。

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

上のコードの `cn(button({ intent, size }), className)` が肝心です。これは[第23章](chapter23.md)で作った `cn`（`clsx` + `tailwind-merge`）です。

- `button({ intent, size })` が CVA で組み立てたクラス列を返す。
- そこに、利用側から渡された `className` を**後ろに足す**。
- `cn` の中の `tailwind-merge` が、**衝突を後勝ちで解消**する。

これにより、`<Button className="rounded-full">` のように利用側が一部だけ上書きしたとき、CVA 既定の `rounded-md` を `rounded-full` がきれいに置き換えます。**「コンポーネントの既定 ＋ 利用側の上書き」を破綻なく合成する**——この `cn` パターンが、現代の React × Tailwind の標準形です。

## 25.3 CVA による型安全なバリアント

CVA の `VariantProps<typeof button>` を使うと、コンポーネントの props 型が**バリアント定義から自動で導出**されます。`intent` に `'primary' | 'secondary'` 以外を渡すと、TypeScript がコンパイル時にエラーにしてくれます。バリアントの定義（クラス）と型が 1 か所に集約され、ずれが起きないのが大きな利点です。

## 25.4 Headless UI / Radix + Tailwind の組み合わせ

[第21章](../part5/chapter21.md)で触れたとおり、モーダルやドロップダウンのような複雑な UI を**アクセシブルに**作るのは難しい仕事です。フォーカス管理、キーボード操作、ARIA 属性——これらを自前で完璧にやるのは現実的ではありません。

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

shadcn/ui はそうではありません。これは**「コンポーネントのコードを、自分のプロジェクトにコピーして取り込む」**という形をとります。コピーした時点で、そのコードは**あなたのもの**になります。中身は Tailwind のクラスと、[第23章](chapter23.md)で見た `cn`・CVA・Radix などで書かれた、ふつうの React コンポーネントです。だから、

- 中身が完全に見えて、好きなように書き換えられる（Open Code）。
- ライブラリのバージョンアップに振り回されない。
- [第23章](chapter23.md)で学んだ道具がそのまま使われているので、構造を理解できる。

shadcn/ui は自身を「**インストールする UI ライブラリではなく、自分の UI ライブラリの作り方**」だと位置づけています。「完成品を借りる」のではなく、「**良い出発点をコピーして所有し、育てる**」もの——この捉え方ができると、shadcn/ui を正しく使えます。逆に「便利な部品集」として依存し、中身を理解しないままコピーを増やすと、結局メンテナンスできないコードを抱えることになります。

## 25.6 Next.js での注意（Server Components・動的クラス生成の回避）

最後に Next.js 特有の注意です。[第8章](../part3/chapter8.md)で触れたとおり、App Router ではコンポーネントがサーバーコンポーネントとして動くことがあります。ただしスタイリングの観点では、**サーバー／クライアントのどちらで動いても、Tailwind が静的にクラスを走査する仕組み（[第4章](../part2/chapter4.md)）は変わりません**。したがって「クラス名を動的に組み立てない（`bg-${color}` のように書かない）」という原則も同じく適用されます（理由と完全なクラス名へのマッピング例は [§27.3](../part7/chapter27.md#273-クラス名の動的文字列結合で検出漏れ)）。

React 固有のうれしい点として、[第23章](chapter23.md)の CVA を使うと「props を完全なクラス名に対応づける」形が自然に守られるため、この落とし穴を避けやすくなります。

第6部はここまでです。`@apply` に逃げず、コンポーネントに抽出し、`cn`・CVA・デザイントークンで再利用可能に育て、Rails では partial → ViewComponent / Phlex、React では Headless UI / shadcn/ui を活用する——Tailwind を「大量のクラス」から「整然としたデザインシステム」へと昇華させる道筋を見てきました。次の第7部では、これらを**実務のプロジェクト全体**で運用するための構成・アンチパターン・評価に踏み込みます。

## 参考資料

* [shadcn/ui（公式サイト・ドキュメント）](https://ui.shadcn.com/docs)
* [Headless UI（公式サイト）](https://headlessui.com/)
* [Radix Primitives（公式サイト）](https://www.radix-ui.com/primitives)
* [Class Variance Authority（公式サイト）](https://cva.style/)
* [tailwind-merge（GitHub）](https://github.com/dcastil/tailwind-merge)

