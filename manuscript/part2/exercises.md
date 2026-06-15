# 演習（第2部）

仕組みは「実際に生成 CSS を見る」のが最良の理解法です。**Tailwind Play**（https://play.tailwindcss.com/）を開いて試しましょう。

1. **生成 CSS を見よう**: Play で `<div class="p-6 text-center">` と書き、生成された CSS を確認してください。`p-6` が `calc(var(--spacing) * 6)` になっていることを自分の目で確かめましょう（§4.1・§4.9）。
2. **テーマを足そう**: Play の CSS 欄に `@theme { --color-brand: oklch(0.45 0.24 264); }` を追加し、`bg-brand` が使えるようになることを確認してください（§5.2〜5.4）。
3. **バリアントを重ねよう**: `class="bg-blue-500 hover:bg-blue-700 md:bg-green-500"` の要素を作り、ホバー時・画面幅を変えたときの挙動を観察してください。生成された CSS にメディアクエリと `:hover` がどう現れるか見てみましょう（第6章）。
