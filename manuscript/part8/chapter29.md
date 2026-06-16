# 第29章 Tailwind v4

## 29.1 v4 が目指したもの

[第2章](../part1/chapter2.md)で見たとおり、v4 は「コードネーム Oxide」と呼ばれた新エンジンの開発から始まり、当初は v3.x の一部として計画されていたものが、あまりに大きな変化のため v4.0 として 2025 年 1 月にリリースされました。v4 が目指したのは、大きく 3 つです。

1. **速度**: ビルドを劇的に速くする。
2. **モダン CSS の全面採用**: ここ数年で進化した CSS の新機能を土台にする。
3. **設定の簡素化**: 設定を CSS に寄せ、周辺ツールを減らす。

本書はこの v4 を一貫して前提にしてきました。この章では、これまで各所で触れてきた v4 の変更点を、ひとつの見取り図としてまとめます。

## 29.2 新エンジン（Oxide / Lightning CSS）の内部

v4 のエンジンは、性能が重要な部分を **Rust** で書き直したものです（[第4章](../part2/chapter4.md)）。あわせて、CSS のパース・ベンダープレフィックス付与・`@import` の解決・圧縮を、Rust 製の高速ツール **Lightning CSS** が一手に担います。

この刷新により、公式（v4.0 時点）の計測ではフルビルドが約 3.8 倍、増分ビルドが約 8 倍以上速くなりました。同時に、以前は別途必要だった `postcss-import` や `autoprefixer` が Tailwind 単体に取り込まれ、**周辺ツールの設定が減った**のも大きな実利です（[第7章](../part3/chapter7.md)）。

## 29.3 CSS ファースト設定への全面移行

v4 最大の思想的変化が、**設定を JavaScript から CSS へ移した**ことです（[第5章](../part2/chapter5.md)）。

```css
/* v4: 設定は CSS の中に書く */
@import "tailwindcss";

@theme {
  --color-brand: oklch(0.45 0.24 264);
  --breakpoint-3xl: 120rem;
}
```

v3 までの `tailwind.config.js`（JavaScript）は必須ではなくなりました。「CSS のための設定を、CSS で書く」という自然な形への回帰です。しかも[第5章](../part2/chapter5.md)で見たとおり、`@theme` の変数は**そのまま CSS 変数として公開される**ため、設定とランタイムの値が一致します。

## 29.4 モダン CSS の全面採用

v4 は「自分で何でも実装する」のではなく、**進化したブラウザのネイティブ機能に乗る**方針を取りました。具体的には、

- **カスケードレイヤー（`@layer`）**: 詳細度の戦いを構造的に解決（[第4章](../part2/chapter4.md)）。
- **登録済みカスタムプロパティ（`@property`）**: アニメーション可能な CSS 変数などを実現。
- **`color-mix()`**: `bg-black/50` の不透明度合成に使用（[第12章](../part4/chapter12.md)）。
- **論理プロパティ**: `padding-inline` などで多言語（RTL）対応（[第10章](../part4/chapter10.md)）。

これは「Tailwind が薄くなった」ことを意味します。ブラウザができることはブラウザに任せ、Tailwind はそれを使いやすくする層に徹する——この方向性は[第30章](chapter30.md)のテーマにもつながります。

## 29.5 Container Queries・3D transform・`@starting-style` の標準化

v3 ではプラグインが必要だった、あるいは存在しなかった機能が、v4 でコアに入りました。

- **Container Queries**（`@container` / `@md:`）: 親要素の幅に応じたレイアウト（[第14章](../part4/chapter14.md)・[第17章](../part5/chapter17.md)）。
- **3D transform**（`rotate-x-*` など）: 立体的な変形（[第19章](../part5/chapter19.md)）。
- **`@starting-style`**（`starting:` バリアント）: JavaScript なしの入場アニメーション（[第19章](../part5/chapter19.md)）。

いずれも「モダン CSS をユーティリティのまま使えるようにする」という v4 の性格をよく表しています。

## 29.6 v3 → v4 移行の実務

既存の v3 プロジェクトを v4 に上げるときの要点です。[第7章](../part3/chapter7.md)でも触れた移行ツールが主役です。

```bash
npx @tailwindcss/upgrade
```

このツールは大部分を自動で変換してくれます（Node.js 20 以上が必要）。主な破壊的変更は次のとおりです。

| 項目 | v3 | v4 |
| --- | --- | --- |
| 読み込み | `@tailwind base; ...` | `@import "tailwindcss";` |
| 設定 | `tailwind.config.js` | CSS の `@theme`（`@config` で互換読込も可） |
| 影 | `shadow-sm` / `shadow` | `shadow-xs` / `shadow-sm` |
| 角丸 | `rounded-sm` | `rounded-xs` |
| リング | `ring`（3px） | `ring-3`（既定は 1px） |
| アウトライン | `outline-none` | `outline-hidden` |
| important の位置 | `!bg-red-500` | `bg-red-500!` |
| 既定のボーダー色 | `gray-200` | `currentColor` |

加えて、v4 は**モダンブラウザ（Safari 16.4+ / Chrome 111+ / Firefox 128+）が前提**です。古いブラウザを手厚くサポートする必要があるプロジェクトは、無理に上げず **v3.4 に留まる**判断もありえます。移行は「ツールで自動変換 → 差分を確認 → 手で微修正」の順で、小さく進めるのが安全です。

## 参考資料

* [Tailwind CSS v4.0（2025-01-22）](https://tailwindcss.com/blog/tailwindcss-v4)
* [「Open-sourcing our progress on Tailwind CSS v4.0」（新エンジン Oxide）](https://tailwindcss.com/blog/tailwindcss-v4-alpha)
* [Tailwind CSS Docs — Upgrade guide（v3 → v4）](https://tailwindcss.com/docs/upgrade-guide)

