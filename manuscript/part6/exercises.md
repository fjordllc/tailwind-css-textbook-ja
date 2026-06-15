# 演習（第6部）

設計の良し悪しは「リファクタリングしてみる」と分かります。

1. **抽出する**: 同じ長いクラス列を持つボタンが 3 か所にコピーされた状態を作り、それを Rails の partial（または React コンポーネント）に抽出してください。`@apply` で CSS クラスにする案と比べ、なぜ抽出の方が良いのか [§22.2](chapter22.md#222-apply-の役割と落とし穴) の観点で説明できますか。
2. **バリアント設計**: `intent`（primary/danger）と `size`（sm/md）を持つボタンを、React なら CVA ＋ `cn` で、Rails なら Ruby のハッシュ＋ `class_names` で実装してください（[§23.4](chapter23.md#234-バリアント設計-class-variance-authoritycva)・[§24.5](chapter24.md#245-rails-で-cva-的なバリアント管理を実現する)）。
3. **所有する**: shadcn/ui のボタンを 1 つ取り上げ、「これは依存ライブラリではなくコピーして所有するもの」とはどういう意味か、中身（`cn`・CVA・Radix）を読んで説明してください（[§25.5](chapter25.md#255-shadcnui-に見るコピーして所有するコンポーネント観)）。
