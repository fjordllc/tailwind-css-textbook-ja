# 第15章 Flexbox

## 15.1 Flexbox の素の CSS と Tailwind の対応

Flexbox は「要素を 1 方向（横一列か縦一列）に並べ、余白や伸縮を制御する」レイアウト手法です。読者はすでに Flexbox の基礎を学んでいる前提なので、ここでは**素の CSS と Tailwind の対応**を押さえることに集中します。Tailwind のクラスは、CSS プロパティをほぼそのまま短くしただけです。

| 素の CSS | Tailwind |
| --- | --- |
| `display: flex` | `flex` |
| `flex-direction: column` | `flex-col` |
| `justify-content: center` | `justify-center` |
| `align-items: center` | `items-center` |
| `gap: 1rem` | `gap-4` |

つまり Flexbox を知っていれば、Tailwind の Flex は「短い別名を覚えるだけ」です。

## 15.2 方向・折り返し

```html
<div class="flex flex-row">横並び（既定）</div>
<div class="flex flex-col">縦並び</div>
<div class="flex flex-wrap">入りきらなければ折り返す</div>
```

`flex` だけだと横並び（`flex-row`）になります。縦に積みたいときは `flex-col`、子が多くて折り返したいときは `flex-wrap` を足します。

## 15.3 主軸・交差軸の配置

Flexbox の肝は「2 つの軸での配置」です。混同しやすいので整理します。

- **主軸方向の配置 = `justify-*`**: `justify-start` / `justify-center` / `justify-between`（両端に寄せて間を均等に）/ `justify-end`
- **交差軸方向の配置 = `items-*`**: `items-start` / `items-center` / `items-stretch`

```html
<!-- 横並びで、左右両端に配置し、縦は中央そろえ -->
<div class="flex justify-between items-center">
  <span>ロゴ</span>
  <nav>メニュー</nav>
</div>
```

この `justify-between items-center` は、ヘッダーの「ロゴを左、メニューを右、縦は中央」という最頻出パターンです。

## 15.4 伸縮（grow / shrink / basis）

子要素が空きスペースをどう分け合うかを制御します。

- `grow` … 余ったスペースを埋めるように伸びる
- `shrink-0` … 縮まない（アイコンなどを潰したくないとき）
- `basis-*` … 基準サイズ

```html
<div class="flex">
  <input class="grow" />          <!-- 入力欄が伸びる -->
  <button class="shrink-0">検索</button>  <!-- ボタンは潰れない -->
</div>
```

## 15.5 個別配置（self / order）

特定の子だけ別扱いにしたいときは `self-*`（その子の交差軸配置）や `order-*`（並び順の変更）を使います。`order-first` / `order-last` で、HTML の順序を変えずに見た目の順序だけ入れ替えられます。

## 15.6 実務: ナビゲーションバー・ツールバー

Flexbox の実務での主役は、横並びの UI です。ナビゲーションバー、ツールバー、ボタンの並び、アイコン＋ラベルなど。基本の型は `flex items-center gap-*` で、これに `justify-between`（両端寄せ）や `grow`（一部を伸ばす）を足して組み立てます。1 次元（一列）の配置なら Flexbox、2 次元（行と列の格子）なら次章の Grid、という使い分けを覚えておきましょう。

## 参考資料

* [Tailwind CSS Docs — Flex](https://tailwindcss.com/docs/flex)
* [Tailwind CSS Docs — Justify content](https://tailwindcss.com/docs/justify-content)
* [Tailwind CSS Docs — Align items](https://tailwindcss.com/docs/align-items)

---
