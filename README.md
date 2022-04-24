# econ-code
経済・金融データ分析に使用する、RとPythonのサンプルコード集です。

## R
R version 4.1.3 (2022-03-10)  
Platform: x86_64-w64-mingw32/x64 (64-bit)  
Running under: Windows 10 x64 (build 19042)  
### 01_setting.R - Rを使用する際の各種設定
* 設定全般
* プロキシーサーバー設定
* パッケージのインストールとインポート
* 図表設定

### 02_introduction.R - Rの基本的な使用方法
* 主要ショートカットキー
* 基本操作・ベクトル・リスト・関数
* データを読み込み・セーブ・ロード

### 03_tidyverse.R - tidyverseを使用したデータベース操作
* サンプルデータを読み込み
* 列を選択 dplyr::select()
* 列の名前を変更 dplyr::rename()
* 行をフィルタ dplyr::filter()
* 行を並べ替え dplyr::arrange()
* 列を追加・修正 dplyr::mutate()
* グループ化 dplyr::group_by()
* 集計 dplyr::summarise()
* 縦型・横型を変換 tidyr::pivot_*()
* 重複処理 dplyr::distinct()
* 欠損値処理 drop_na() replace_na() fill()
* 時系列データの頻度変換 tidyquant::tq_transmute()
### 04_plot.R - 図表作成
* サンプルデータの確認・作成
* ヒストグラム geom_histogram()
* 密度グラフ geom_density()
* 頻度棒グラフ geom_bar()
* 頻度バブルチャート geom_count()
* 散布図 geom_point() geom_path() geom_smooth()
* 棒グラフ geom_col()
* 円グラフ geom_col() + coord_polar()
* 折れ線・面・ステップグラフ geom_line() geom_area() geom_ribbon() geom_step()
* 箱ひげ・ヴァイオリングラフ geom_boxplot() geom_violin() geom_dotplot() geom_jitter() geom_dotplot()
* 色の設定 scale_color/fill_*
* 軸の設定
* タイトル・目盛線・凡例・保存 theme() ggsave()