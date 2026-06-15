# 付録F ハンズオン: ゼロから動く最小例

本文は概念を順に積み上げる構成のため、「とにかく一度、自分の手で動かして青い文字を出してみたい」という人向けに、**ゼロから完成まで通しで動く最小例**をここにまとめます。3 つの経路を用意しました。**まずは F.1（ビルド不要）で「効く」体験をしてから**、F.2（Rails）や F.3（Vite）に進むのがおすすめです。

> どの経路でも、最後に画面で **「Hello, Tailwind!」が大きな青い太字＋下線**で表示されれば成功です。

## F.1 いちばん速い: ビルド不要（Play CDN）

エディタも `npm` も要りません。次の内容で `index.html` を作り、ブラウザで開くだけです（[第7章](../part3/chapter7.md) Play CDN）。

```html
<!doctype html>
<html lang="ja">
  <head>
    <meta charset="utf-8" />
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
  </head>
  <body class="p-8">
    <h1 class="text-3xl font-bold text-blue-600 underline">Hello, Tailwind!</h1>
    <button class="mt-4 rounded-md bg-blue-600 px-4 py-2 text-white hover:bg-blue-700">
      ボタン
    </button>
  </body>
</html>
```

ファイルをダブルクリックしてブラウザで開き、**次がすべて確認できれば成功**です。

- [ ] 「Hello, Tailwind!」が**青い大きな太字**で表示される（`text-3xl font-bold text-blue-600`）
- [ ] 見出しに**下線**がある（`underline`）
- [ ] その下に**青いボタン**があり、マウスを乗せる（ホバーする）と**色が濃くなる**（`hover:bg-blue-700`）

確認できたら、`text-blue-600` を `text-red-600` に書き換えて保存し直し、見出しが赤くなることを試してください。「クラスを変える → 結果がすぐ変わる」を体感できます。

> **Play CDN は開発・学習用**です（本番では F.2 や F.3 を使います）。理由は、(1) ページを開くたびにブラウザ上で CSS を生成するため表示が遅い、(2) CDN からの読み込みが必要でオフラインでは動かない、の 2 点です。本番では、あらかじめビルドした CSS を配信します。

> さらに手軽に試すなら、ファイルすら作らず **Tailwind Play**（<https://play.tailwindcss.com/>）に上記の `<body>` 内を貼るだけでも確認できます。

## F.2 Rails で動かす（本書の重点経路）

Rails 8 以降を前提に、新規アプリで完成まで通します（[第8章](../part3/chapter8.md)）。ターミナルで順に実行します。

```bash
# 1. Tailwind 入りで新規アプリを作る
rails new hello_tailwind --css tailwind
cd hello_tailwind

# 2. 確認用のページを作る
bin/rails generate controller Home index
```

`config/routes.rb` を編集し、**アプリのトップページ（`/`）を表示するルーティング**を設定します（`root` は「ルートディレクトリ」ではなく「アプリのトップ URL」の意味です）。

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root "home#index"   # "/" にアクセスしたら HomeController の index を表示
end
```

ビューにユーティリティを書きます。

```erb
<%# app/views/home/index.html.erb %>
<div class="p-8">
  <h1 class="text-3xl font-bold text-blue-600 underline">Hello, Tailwind!</h1>
  <button class="mt-4 rounded-md bg-blue-600 px-4 py-2 text-white hover:bg-blue-700">
    ボタン
  </button>
</div>
```

開発サーバーを起動します。`bin/dev` は Rails サーバーと Tailwind のウォッチを同時に動かします（[第8章](../part3/chapter8.md)）。

```bash
bin/dev
```

ブラウザで [http://localhost:3000](http://localhost:3000) を開き、F.1 と同じく**青い見出し＋ホバーで色が変わるボタン**が出れば成功です。仕上げに、`text-blue-600` を `text-red-600` に変えて保存してください。**`bin/dev` を動かしたまま**なら、ウォッチが効いて自動で赤くなります（ターミナルに再ビルドのログが出ます）。この「保存すると自動で反映される」感覚が、「入力 CSS → ビルド → 配信」の流れ（[第8章](../part3/chapter8.md)）を体感する最短ルートです。

## F.3 Vite（React）で動かす

React/Vite 経路の最小例です（[第7章](../part3/chapter7.md)・[第8章](../part3/chapter8.md)）。

```bash
# 1. Vite + React プロジェクトを作る
npm create vite@latest hello-tailwind -- --template react
cd hello-tailwind
npm install

# 2. Tailwind を入れる
npm install tailwindcss @tailwindcss/vite
```

`vite.config.js` にプラグインを追加します。

```js
// vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
})
```

CSS エントリで Tailwind を読み込みます。`react` テンプレートでは `src/index.css` が用意されているので、その先頭に書きます（テンプレートによっては `src/style.css` の場合もあります）。

```css
/* src/index.css */
@import "tailwindcss";
```

この CSS が**エントリ（`src/main.jsx`）で読み込まれている**ことを確認してください。`react` テンプレートでは最初から次の 1 行が入っています。これが無いと何も効きません。

```jsx
// src/main.jsx（最初から入っている import を確認）
import './index.css'
```

コンポーネントを書きます。

```jsx
// src/App.jsx
export default function App() {
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold text-blue-600 underline">Hello, Tailwind!</h1>
      <button className="mt-4 rounded-md bg-blue-600 px-4 py-2 text-white hover:bg-blue-700">
        ボタン
      </button>
    </div>
  )
}
```

`npm run dev` で表示される URL を開き、青い見出しが出れば成功です。JSX では `class` ではなく `className` を使う点に注意してください（[第8章](../part3/chapter8.md)）。

## F.4 うまくいかないときは（症状別の診断）

初学者がつまずくのは、たいてい次のどれかです。症状から原因を切り分けましょう。

- **見出しが太くも青くもならない（何も効かない）**: ①CSS エントリに `@import "tailwindcss";` があるか、②それをページ/アプリが読み込んでいるか（HTML の `<link>`、Vite なら `main.jsx` の `import './index.css'`）を確認（[第7章](../part3/chapter7.md)）。古い記事の `@tailwind base; ...` は v4 では動きません。確認後はブラウザを**強制リロード**（`Cmd/Ctrl + Shift + R`）してキャッシュを消します。
- **保存しても変更が反映されない**: ウォッチが動いているか確認。Rails は `bin/dev`、Vite は `npm run dev` のターミナルに再ビルドのログが出ているか見ます。出ていなければ、いったん停止（`Ctrl + C`）して再起動（[第7章](../part3/chapter7.md)）。
- **一部のクラスだけ効かない**: そのクラス名を `text-${color}` のように動的に組み立てていないか（[第4章](../part2/chapter4.md)・[第27章](../part7/chapter27.md)）。クラス名はつねに完全な文字列で書きます。
- **（Rails）画面が 500 エラー**: Rails サーバーのターミナルにエラーが出ています。まずそれを読みます。多いのは `config/routes.rb` の設定漏れや構文ミスです。
- **困ったら開発者ツール**: ブラウザの検証ツール（`F12`）で要素を選び、目的のクラスが付いているか、対応する CSS 規則が生成されているかを確認すると、原因の切り分けが速くなります。

---

本書は以上です。[第1章](../part1/chapter1.md)で見た「CSS が大規模化で壊れる」という問題から始まり、Tailwind がそれにどう答えたのか、内部でどう動き、どう使い、どう設計・運用し、どう評価されるのかを、一貫した「なぜ」とともにたどってきました。あとは、あなた自身のプロジェクトで手を動かすだけです。
