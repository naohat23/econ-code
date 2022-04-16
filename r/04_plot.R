# 03_plot.R ---------------------------------------------------------------

## Rで図表を作成する方法

library(tidyverse)
library(geofacet)
library(ggpubr)
library(ggsci)
library(ggrepel)
library(lemon)
library(RColorBrewer)


## ggplotのテーマ設定（Excelのグラフと類似したテーマを選択）
## https://ggplot2.tidyverse.org/reference/ggtheme.html
theme_set(theme_light())


## ウィンドウズPCにおけるggplotの日本語フォント設定
windowsFonts("MEIRYO" = windowsFont("Meiryo UI"))
windowsFonts("YUGO" = windowsFont("Yu Gothic UI"))



# サンプルデータの確認・作成 -----------------------------------------------------------

## Rのサンプルデータセット
View(mpg)
help(mpg)

View(economics)
help(economics)


## Our World in Dataの新型コロナデータをtibble型で読み込み
data_owid <- readr::read_csv(file = "https://covid.ourworldindata.org/data/owid-covid-data.csv", # ファイルパス／URL
                             col_names = TRUE, # ヘッダー（列名データ）の有無
                             col_types = NULL, # 各列の型の指定（c：文字列型、d：数値型、D：日付型、l：論理値型）
                             skip = 0) # 読み込み時に上からスキップする行数





# ヒストグラム geom_histogram() --------------------------------------------------

## ヒストグラム
ggplot(data = mpg,
       mapping = aes(x = hwy)) +
  geom_histogram(binwidth = 5, # 階級幅
                 color = "gray", # 線の色
                 fill = "darkblue", # 塗りつぶしの色
                 size = 0.5) # 線の太さ


## ヒストグラム＆グループ化（横並び）
ggplot(data = mpg,
       mapping = aes(x = hwy, fill = class)) +
  geom_histogram(binwidth = 5, # 階級幅
                 position = "dodge", # 横並びポジション
                 color = "black", # 線の色
                 size = 0.5) # 線の太さ


## ヒストグラム＆グループ化（積み上げ）
ggplot(data = mpg,
       mapping = aes(x = hwy, fill = class)) +
  geom_histogram(binwidth = 5, # 階級幅
                 position = "stack", # 積み上げポジション
                 color = "black", # 線の色
                 size = 0.5) # 線の太さ



# 密度グラフ geom_density() ----------------------------------------------------

## 密度グラフ
ggplot(data = mpg,
       mapping = aes(x = hwy)) +
  geom_density(kernel = "gaussian", # カーネル関数の種類
               color = "darkblue", # 線の色
               linetype = "solid", # 線の種類 (solid / dashed / dotted / dotdash / twodash / longdash)
               size = 1.0) # 線の太さ


## 密度グラフ＆グループ化（横並び）
ggplot(data = mpg,
       mapping = aes(x = hwy, color = class)) +
  geom_density(kernel = "gaussian", # カーネル関数の種類
               position = "dodge", # 横並びポジション
               linetype = "solid", # 線の種類 (solid / dashed / dotted / dotdash / twodash / longdash)
               size = 1.0) # 線の太さ


## 密度グラフ＆グループ化（積み上げ）
ggplot(data = mpg,
       mapping = aes(x = hwy, fill = class)) +
  geom_density(kernel = "gaussian", # カーネル関数の種類
               position = "stack", # 積み上げポジション
               color = "black", # 線の色
               linetype = "solid", # 線の種類 (solid / dashed / dotted / dotdash / twodash / longdash)
               size = 0.5) # 線の太さ



# 散布図・バブルチャート geom_point() geom_path() geom_smooth() geom_count() ---------------------------------------------------------------

## 散布図
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy)) +
  geom_point(alpha = 1.0, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             size = 2.0, # ポイントの大きさ
             stroke = 0.5) # 線の太さ


## 散布図＆直線
economics %>% 
  dplyr::filter(date >= "2000-01-01") %>% 
  ggplot(mapping = aes(x = unemploy, y = uempmed)) +
  geom_path(alpha = 1.0, # 塗りつぶしの透明度
            color = "darkblue", # 線の色
            size = 0.5) + # ポイントの大きさ
  geom_point(alpha = 1.0, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             size = 2.0, # ポイントの大きさ
             stroke = 0.5) # 線の太さ


## 散布図＆ラベル
mpg %>% 
  dplyr::group_by(manufacturer) %>% 
  dplyr::summarise_at(vars(cty, hwy), mean, na.rm = TRUE) %>% 
  ggplot(mapping = aes(x = cty, y = hwy)) +
  geom_point(alpha = 1.0, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             size = 2.0, # ポイントの大きさ
             stroke = 0.5) + # 線の太さ
  geom_text_repel(mapping = aes(label = manufacturer),
                  seed = NA, # テキストの配置を決定するランダムシード
                  direction = "both", # テキストの整列方向 (both / x / y)
                  hjust = 0.0, # 横方向の整列位置 (0-1) 
                  vjust = 0.5, # 縦方向の整列位置 (0-1)
                  nudge_x = NULL, # マーカーからの横方向のスペース (NULL, 0-)
                  nudge_y = NULL, # マーカーからの縦方向のスペース (NULL, 0-)
                  box.padding = 0.5, # テキスト周囲のスペース (0-)
                  point.padding = 0.1, # マーカー周囲のスペース (0-)
                  segment.alpha = 1.0, # 引き出し線の透明度
                  segment.color = "grey", # 引き出し線の色
                  segment.size = 0.5, # 引き出し線の太さ
                  min.segment.length = 0, # 引き出し線の最低長
                  color = "black", # テキストの色
                  family = "MEIRYO", # テキストのフォント
                  fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
                  size = 4.0) # テキストのサイズ


## 散布図＆近似曲線
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy)) +
  geom_point(alpha = 1.0, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             size = 2.0, # ポイントの大きさ
             stroke = 0.5) + # 線の太さ
  geom_smooth(formula = y ~ x,
              method = "loess", # 近似手法 (lm, glm, gam, loess)
              alpha = 0.5,
              color = "black",
              fill = "gray",
              linetype = "dashed",
              size = 1.0,
              weight = 1.0)


## バブルチャート
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy)) +
  geom_count(alpha = 0.5, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             stroke = 0.5) + # 線の太さ
  scale_size_area(max_size = 15) # 変量とポイントの面積を比例させる

