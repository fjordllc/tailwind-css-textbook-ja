# 付録B よく使う Utility 一覧

実務で登場頻度の高いユーティリティを、カテゴリ別に厳選しました。網羅ではなく「まずこれを覚えれば大半は書ける」というセットです。

## Spacing（余白・第10章）
- padding: `p-*` `px-*` `py-*` `pt-* pr-* pb-* pl-*`
- margin: `m-*` `mx-*` `my-*`（負: `-m-*`）
- 間隔: `gap-*`（Flex/Grid）/ `space-x-* space-y-*`

## Sizing（サイズ・第14章）
- 幅高さ: `w-*` `h-*` `size-*`
- 割合・特殊: `w-1/2` `w-full` `w-screen` `h-dvh`
- 制限: `min-w-*` `max-w-*` `min-h-*` `max-h-*`

## Typography（文字・第11章）
- サイズ/行間: `text-xs`〜`text-9xl`、`text-sm/6`
- 太さ/字間: `font-normal` `font-medium` `font-bold` / `tracking-tight`
- 揃え/装飾: `text-center` `text-right` / `underline` / `truncate` `line-clamp-*`

## Colors（色・第12章）
- `bg-*` `text-*` `border-*` `ring-*`（例: `bg-blue-600` `text-white`）
- 不透明度: `bg-black/50`

## Flexbox（第15章）
- `flex` `flex-col` `flex-wrap`
- `justify-center` `justify-between` / `items-center`
- `grow` `shrink-0` `basis-*`

## Grid（第16章）
- `grid` `grid-cols-*` `col-span-*` `row-span-*` `gap-*`

## Borders / Effects（第13章）
- `border` `border-2` / `rounded-md` `rounded-full`
- `shadow-sm` `shadow-md` / `ring-2`
- `opacity-*` `blur-*`

## Layout（第14章）
- `block` `inline-block` `hidden` `flex` `grid`
- `relative` `absolute` `fixed` `sticky` / `inset-0` `top-*` `z-*`
- `overflow-hidden` `overflow-auto` / `object-cover`

## States / Variants（第6章）
- 状態: `hover:` `focus:` `focus-visible:` `active:` `disabled:`
- レスポンシブ: `sm:` `md:` `lg:` `xl:` `2xl:`（および `max-*:`）
- その他: `dark:` `group-*:` `peer-*:` `has-*:` `aria-*:` `data-*:` `motion-reduce:`

---
