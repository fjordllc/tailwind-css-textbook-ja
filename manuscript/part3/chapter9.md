# 第9章 エディタ環境

導入が終わったら、開発を快適にするエディタ環境を整えます。Tailwind は「クラスを大量に書く」スタイルなので、補完や整形といった支援があるかどうかで、開発体験が大きく変わります。ここを整えるかどうかは、Tailwind を「面倒」と感じるか「快適」と感じるかの分かれ目になります。

## 9.1 VS Code: Tailwind CSS IntelliSense

VS Code を使うなら、公式拡張 **Tailwind CSS IntelliSense** は必ず入れましょう。主な機能は次のとおりです。

- **オートコンプリート**: `bg-` まで打つと候補が一覧で出ます。膨大なユーティリティを暗記する必要がなくなります。テーマで定義した独自の色やスケールも候補に出ます。
- **ホバープレビュー**: クラスにマウスを乗せると、それが生成する実際の CSS が表示されます。第2部で学んだ「クラス → CSS」の対応を、その場で確認できます。
- **色プレビュー**: `bg-red-500` のような色クラスの横に、実際の色が表示されます。
- **構文ハイライト・リンティング**: 存在しないクラスや、競合するクラス（後述）を指摘してくれます。

この拡張は、補完だけでなく**「間違いに早く気づく」**ためにも効きます。

## 9.2 クラス順の自動整形: `prettier-plugin-tailwindcss`

ユーティリティを並べていると、書く人によってクラスの順番がバラバラになります。`p-4 flex bg-white` と書く人もいれば `flex bg-white p-4` と書く人もいます。これはレビューを読みにくくし、無用な差分を生みます。

公式の Prettier プラグイン **`prettier-plugin-tailwindcss`** を使うと、保存時にクラスを**推奨される一定の順序に自動で並べ替え**てくれます。

```bash
npm install -D prettier prettier-plugin-tailwindcss
```

```js
// .prettierrc（または prettier.config.js）
export default {
  plugins: ["prettier-plugin-tailwindcss"],
}
```

チーム全員が同じ順序になるため、「クラスの並べ方」で悩む時間と、レビューでの無駄な指摘がなくなります。これはチーム開発でとくに価値が大きい設定です（[第26章](../part7/chapter26.md)でも触れます）。

> 補足: このプラグインは Prettier のものなので、Node を使わない Rails プロジェクトでは、整形のためだけに Prettier を導入するか判断が必要です。「整形のためだけに Node を入れたくない」なら、後述の IntelliSense によるクラス並び替え支援や、チームの命名ルールで運用する方法もあります。

## 9.3 重複・衝突の検知

Tailwind CSS IntelliSense は、**衝突するクラス**も警告してくれます。たとえば `p-4` と `p-8` を同じ要素に書くと、片方は無意味になります（[第4章](../part2/chapter4.md)の「衝突の解決」）。こうした「効かないクラス」を書いてしまったとき、エディタ上で気づけるのは大きな助けです。動的にクラスを組み立てる React などでは、最終的に[第23章](../part6/chapter23.md)で扱う `tailwind-merge` のような仕組みで衝突を解消しますが、まずはエディタの警告で早期に気づくのが第一歩です。

## 9.4 ディレクティブの「unknown at-rule」警告への対処

Tailwind は `@theme`・`@source`・`@utility`・`@custom-variant` といった独自のディレクティブを使います（第2部）。ところが、エディタの標準的な CSS チェッカーはこれらを知らないため、「**unknown at-rule（未知のアットルール）**」という警告を出すことがあります。これは Tailwind 側の誤りではなく、エディタが新しい構文を知らないだけです。

対処は次のとおりです。

- **Tailwind CSS IntelliSense を使う**: この拡張には、Tailwind の独自ディレクティブをすべて理解する専用の言語モードが含まれており、CSS ファイルを Tailwind の言語モードとして扱うことで警告が消えます。
- **標準の CSS リンティングを調整する**: エディタが厳しく構文チェックしている場合は、その CSS の検証を無効化・緩和する設定を行います。

「赤い波線が出るが実害はない」状態を放置すると、本当のエラーを見逃しやすくなります。早めに解消しておきましょう。

## 9.5 JetBrains 系・Neovim 等での対応状況

Tailwind の支援は VS Code だけのものではありません。公式の言語サーバー（IntelliSense の中核）をベースに、さまざまなエディタが対応しています。

- **JetBrains 系（RubyMine・WebStorm など）**: Tailwind の補完に対応しています。Rails 開発で RubyMine を使う人も、補完の恩恵を受けられます。
- **Cursor・Zed**: これらのエディタでも Tailwind の支援が利用できます。
- **Neovim など**: 言語サーバーを介して補完を有効にできます。

公式ドキュメントの Editor setup ページに、対応エディタと設定方法がまとまっています（参考資料）。

## 9.6 補完を効かせる設定

最後に、補完を最大限効かせるための小さなコツです。

- **クラスを書く場所を教える**: 文字列の中にクラスを書く独自のヘルパー（たとえば `cn(...)` や、Rails のヘルパーメソッド）を使っている場合、その関数の中でも補完が効くように、IntelliSense に「ここにもクラスが書かれる」と設定できます。
- **CSS の言語モードを合わせる**: 9.4 のとおり、Tailwind の CSS ファイルは Tailwind の言語モードとして扱うと、ディレクティブの補完と警告抑制の両方が効きます。

ここまでで、Tailwind を実プロジェクトで動かし、快適に書くための土台が整いました。次の第4部からは、いよいよ個々のユーティリティ——余白・文字・色・レイアウトなど——を、第2部で学んだ仕組みの理解の上に学んでいきます。

## 参考資料

* [Tailwind CSS Docs — Editor setup（IntelliSense・言語モード・警告対処）](https://tailwindcss.com/docs/editor-setup)
* [Tailwind CSS IntelliSense（GitHub）](https://github.com/tailwindlabs/tailwindcss-intellisense)
* [prettier-plugin-tailwindcss（GitHub）](https://github.com/tailwindlabs/prettier-plugin-tailwindcss)

