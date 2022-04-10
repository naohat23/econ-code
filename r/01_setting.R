
# 01_setting.R ------------------------------------------------------------

## Rを使用する際の各種設定に関するコード



# 設定全般 --------------------------------------------------------------------

## 全変数の削除
rm(list = ls())


## 警告を非表示
options(warn = -1)


## 関数が表示する警告やメッセージを非表示
suppressWarnings()
suppressMessages()


# パッケージのインストールとインポート ------------------------------------------------------------

## パッケージ一覧
packages <- c(
  # tidyverse系
  "lubridate", # 日付処理
  "magrittr", # パイプ処理
  "tidyverse", # モダンなデータ分析用パッケージセット
  # 図表系
  "geofacet", # 地図形式のファセット図配置
  "ggpubr", # 論文形式の図表作成
  "ggsci", # 科学系論文の雑誌別カラーパレット
  "ggrepel", # 散布図のラベル付与
  "lemon", # ファセット図の軸・目盛り表示
  "RColorBrewer", # カラーパレット
  # 統計系
  "mgcv", # 一般化加法モデル（GAM）
  "plm", # パネルデータモデル
  "sigmoid", # シグモイド関数
  "tidyquant" # 金融時系列データ分析
)


## インストールしていないパッケージがあればインストール
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]

if(length(new_packages)) {
  install.packages(new_packages)
}


## パッケージをインポート
for (pkg in packages) {
  library(pkg, character.only = TRUE)
}


## 変数を削除
rm(
  new_packages,
  packages,
  pkg
)


# 図表設定 --------------------------------------------------------------------

## ggplotのテーマ設定（Excelのグラフと類似したテーマを選択）
## https://ggplot2.tidyverse.org/reference/ggtheme.html
theme_set(theme_light())


## ウィンドウズPCにおけるggplotの日本語フォント設定
windowsFonts("MEIRYO" = windowsFont("Meiryo UI"))
windowsFonts("YUGO" = windowsFont("Yu Gothic UI"))

