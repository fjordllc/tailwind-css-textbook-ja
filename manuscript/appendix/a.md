# 付録A 公式ドキュメントの歩き方

本書は「なぜ」を理解するための教科書であり、すべてのクラスを網羅してはいません。日々の開発では、**公式ドキュメント**（https://tailwindcss.com/docs）を引くのが基本になります。ここでは、その歩き方を示します。

## docs の構成

公式ドキュメントは、おおむね次のように分類されています。

- **Getting started / Core concepts**: 導入（Installation）と、本書の第2部にあたる中心的な考え方（Styling with utility classes / Hover, focus & other states / Responsive design / Dark mode / Theme / Colors / Adding custom styles / Detecting classes / Functions and directives）。困ったらまずここに戻ります。
- **Base styles**: Preflight などの土台。
- **Layout / Flexbox & Grid / Spacing / Sizing / Typography / Backgrounds / Borders / Effects / Filters / Transitions & Animation / Transforms / Interactivity / SVG / Accessibility**: ユーティリティのカテゴリ別リファレンス（本書の第4・5部に対応）。
- **Customization 系**（Theme / Functions and directives / Detecting classes など）: テーマや設定（本書の第5・26章に対応）。

## 効率的な引き方

- **検索を使う**: docs 上部の検索（`⌘K` / `Ctrl K`）が最速です。プロパティ名（`gap`・`grid-template-columns`）でもクラス名でも引けます。
- **各ページの「Quick reference」表**: 各ユーティリティのページ冒頭に、クラスと生成 CSS の対応表があります。値を確認したいときはここを見ます。
- **バージョンに注意**: 本書は v4 前提です。古い記事や v3 の docs を見ていないか、URL とバージョン表記を確認しましょう。
- **Playground と Upgrade guide**: 挙動を試すなら **Tailwind Play**（https://play.tailwindcss.com/）、移行するなら **Upgrade guide**（https://tailwindcss.com/docs/upgrade-guide）。

---
