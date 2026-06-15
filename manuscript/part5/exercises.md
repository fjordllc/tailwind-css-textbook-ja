# 演習（第5部）

実践テーマは「条件付きで見た目を変える」練習が中心です。

1. **ダークモード**: [§18.3](chapter18.md#183-v4-でのダークモード設定custom-variant-dark) の `@custom-variant dark (&:where(.dark, .dark *))` を設定し、`<html>` に `.dark` を付け外しして配色が切り替わるカードを作ってください。さらに、`dark:` をベタ書きする版と、セマンティックトークン（`bg-surface` など）で切り替える版の両方を書き、違いを体感しましょう（[§18.5](chapter18.md#185-実務-色設計をダークモード前提にする)）。
2. **フォームの状態**: メール入力欄を作り、`focus:` で枠を強調し、`peer` ＋ `peer-invalid:` で不正時にエラーメッセージを表示してください（[§20.3](chapter20.md#203-状態表現focus--invalid--disabled--peer)）。
3. **アクセシビリティ点検**: アイコンだけのボタンに `sr-only` でラベルを付け、`focus-visible:` でフォーカスリングを出してください。`outline-none` だけで終わらせていないか確認しましょう（[§21.2](chapter21.md#212-視覚的に隠す-sr-only)・[§21.3](chapter21.md#213-フォーカス可視化focus-visible-とリング)）。
