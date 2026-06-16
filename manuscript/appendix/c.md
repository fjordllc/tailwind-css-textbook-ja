# 付録C チートシート

1 ページで引ける早見表です。

## ブレークポイント（第17章）
| プレフィックス | 最小幅 |
| --- | --- |
| `sm:` | 40rem (640px) |
| `md:` | 48rem (768px) |
| `lg:` | 64rem (1024px) |
| `xl:` | 80rem (1280px) |
| `2xl:` | 96rem (1536px) |

※ コンテナクエリは `@container` ＋ `@sm: @md: ...`（親要素の幅に反応）

## spacing スケール（第10章）
基準 `--spacing` は既定 `0.25rem`（4px）。`数値 × 0.25rem`。
| クラス | 値 |
| --- | --- |
| `p-1` | 0.25rem (4px) |
| `p-2` | 0.5rem (8px) |
| `p-4` | 1rem (16px) |
| `p-6` | 1.5rem (24px) |
| `p-8` | 2rem (32px) |
| `p-12` | 3rem (48px) |

## フォントサイズ（第11章）
| クラス | 値 |
| --- | --- |
| `text-xs` | 12px |
| `text-sm` | 14px |
| `text-base` | 16px |
| `text-lg` | 18px |
| `text-xl` | 20px |
| `text-2xl` | 24px |
| `text-3xl` | 30px |

## 色の段階（第12章）
`50`（最も明るい）→ `100` → … → `500`（基準）→ … → `900` → `950`（最も暗い）。
例: `bg-gray-50` `text-gray-500` `border-gray-900`。不透明度は `/数値`（例 `bg-black/50`）。

## 影（v4・第13章）
小 → 大: `shadow-2xs` `shadow-xs` `shadow-sm` `shadow-md` `shadow-lg` `shadow-xl` `shadow-2xl`（無: `shadow-none`）
※ v3 の `shadow-sm` は v4 の `shadow-xs`、v3 の `shadow` は v4 の `shadow-sm`。

## v3 → v4 主な変更（第29章）
| v3 | v4 |
| --- | --- |
| `@tailwind base; ...` | `@import "tailwindcss";` |
| `tailwind.config.js` | `@theme`（CSS） |
| `!bg-red-500` | `bg-red-500!` |
| `shadow-sm` / `shadow` | `shadow-xs` / `shadow-sm` |
| `rounded-sm` | `rounded-xs` |
| `ring`（3px） | `ring-3`（既定は 1px） |
| `outline-none` | `outline-hidden` |
| 既定のボーダー色 `gray-200` | `currentColor` |

