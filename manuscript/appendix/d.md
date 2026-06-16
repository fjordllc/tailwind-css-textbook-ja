# 付録D 用語集

本書で登場した重要語をまとめます。詳しくは各章を参照してください。

- **ユーティリティクラス**: 単一の役割だけを持つ小さなクラス（`p-4`・`bg-white` など）。これを組み合わせてデザインする（[第3章](../part1/chapter3.md)）。
- **Utility First（ユーティリティファースト）**: ユーティリティクラスの組み合わせで UI を作る設計思想（[第3章](../part1/chapter3.md)）。
- **バリアント**: ユーティリティに条件を付ける接頭辞（`hover:`・`md:`・`dark:` など）。CSS のセレクタやメディアクエリを生成する（[第6章](../part2/chapter6.md)）。
- **任意の値（arbitrary value）**: 角かっこでスケール外の値を直接書く記法（`p-[13px]`）。便利だが乱用は一貫性を崩す（[第4章](../part2/chapter4.md)・[第27章](../part7/chapter27.md)）。
- **テーマ変数 / デザイントークン**: `@theme` で定義する、色・余白などの「デザイン上の決め事」。CSS 変数とユーティリティ生成を兼ねる（[第5章](../part2/chapter5.md)）。
- **セマンティックトークン**: 役割を表す色名などのトークン（`--color-primary` など）。ダークモードや配色変更に強い（[第12章](../part4/chapter12.md)・[第26章](../part7/chapter26.md)）。
- **`@theme`**: テーマ変数を定義する v4 のディレクティブ（[第5章](../part2/chapter5.md)）。
- **`@apply`**: ユーティリティを自前の CSS クラスに展開するディレクティブ。多用は非推奨（[第22章](../part6/chapter22.md)）。
- **`@utility`**: 単機能のカスタムユーティリティを追加する v4 のディレクティブ（[第22章](../part6/chapter22.md)・[第26章](../part7/chapter26.md)）。
- **`@plugin`**: JS ベースのプラグイン（typography/forms など）を CSS から読み込む互換ディレクティブ（[第26章](../part7/chapter26.md)）。
- **`@source`**: クラス走査の対象を明示的に追加/除外するディレクティブ（[第4章](../part2/chapter4.md)・[第26章](../part7/chapter26.md)）。
- **`@custom-variant`**: 独自のバリアントを定義するディレクティブ。手動ダークモードにも使う（[第6章](../part2/chapter6.md)・[第18章](../part5/chapter18.md)）。
- **JIT（Just-In-Time）**: 使われているクラスだけをその場で生成する仕組み（[第4章](../part2/chapter4.md)）。
- **Oxide**: v4 の新エンジンのコードネーム。性能重視部分は Rust 製（[第4章](../part2/chapter4.md)・[第29章](../part8/chapter29.md)）。
- **Lightning CSS**: v4 が内蔵する Rust 製の CSS 処理ツール（パース・プレフィックス・圧縮など）（[第4章](../part2/chapter4.md)・[第29章](../part8/chapter29.md)）。
- **カスケードレイヤー（`@layer`）**: レイヤーの優先順位で詳細度の戦いを制御するモダン CSS 機能（[第4章](../part2/chapter4.md)）。
- **コンテナクエリ（container query）**: 画面ではなく親要素の幅に反応するレイアウト（`@container` / `@md:`）（[第14章](../part4/chapter14.md)・[第17章](../part5/chapter17.md)）。
- **Preflight**: Tailwind が当てる土台のリセット CSS（[第4章](../part2/chapter4.md)）。
- **`cn`**: `clsx`（条件分岐）と `tailwind-merge`（衝突解消）を組み合わせた定番ヘルパー（[第23章](../part6/chapter23.md)）。
- **CVA（Class Variance Authority）**: 型安全にバリアントを管理するライブラリ（[第23章](../part6/chapter23.md)）。
- **モバイルファースト**: 無印が全画面に効き、`md:` などで広い画面を上書きする設計（[第17章](../part5/chapter17.md)）。
- **FOUC**: ダークモード初期表示などで起きる一瞬のちらつき（[第18章](../part5/chapter18.md)）。

