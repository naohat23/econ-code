# 04_plot.R ---------------------------------------------------------------

## Rで図表を作成する方法



# パッケージのインポート・設定------------------------------------------------------

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



# サンプルデータの確認・読み込み -----------------------------------------------------------

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

## X軸：連続型変数
## Y軸：なし

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

## X軸：連続型変数
## Y軸：なし

## 密度グラフ
ggplot(data = mpg,
       mapping = aes(x = hwy)) +
  geom_density(kernel = "gaussian", # カーネル関数の種類
               color = "darkblue", # 線の色
               linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
               size = 1.0) # 線の太さ


## 密度グラフ＆グループ化（横並び）
ggplot(data = mpg,
       mapping = aes(x = hwy, color = class)) +
  geom_density(kernel = "gaussian", # カーネル関数の種類
               position = "dodge", # 横並びポジション
               linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
               size = 1.0) # 線の太さ


## 密度グラフ＆グループ化（積み上げ）
ggplot(data = mpg,
       mapping = aes(x = hwy, fill = class)) +
  geom_density(kernel = "gaussian", # カーネル関数の種類
               position = "stack", # 積み上げポジション
               color = "black", # 線の色
               linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
               size = 0.5) # 線の太さ



# 頻度棒グラフ geom_bar() ---------------------------------------------------------

## X軸：離散型変数
## Y軸：なし

## 縦棒グラフ
ggplot(data = mpg,
       mapping = aes(x = manufacturer)) + 
  geom_bar(alpha = 1.0, # 塗りつぶしの透明度
           color = "darkblue", # 線の色
           fill = "lightblue", # 塗りつぶしの色
           size = 0.5, # 線の太さ
           width = 0.9) # 棒の幅 (0-1)



# 頻度バブルチャート geom_count() -----------------------------------------------------------

## X軸：離散型変数
## Y軸：離散型変数

## バブルチャート（頻度）
ggplot(data = mpg,
       mapping = aes(x = manufacturer, y = class)) +
  geom_count(alpha = 0.5, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             stroke = 0.5) + # 線の太さ
  scale_size_area(max_size = 15) # 変量とポイントの面積を比例させる



# 散布図 geom_point() geom_path() geom_smooth() ---------------------------------------------------------------

## X軸：連続型変数
## Y軸：連続型変数

## サンプルデータの作成
data_mpg_point <- mpg %>% 
  dplyr::group_by(manufacturer) %>% 
  dplyr::summarise(across(c(displ, cty, hwy), mean, na.rm = TRUE))

View(data_mpg_point)


## 散布図
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy)) +
  geom_point(alpha = 1.0, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             size = 2.0, # ポイントの大きさ
             stroke = 0.5) # 線の太さ


## 散布図＆補助線
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy)) +
  geom_hline(yintercept = 20, # 水平線の縦軸との交点
             color = "Tomato", # 水平線の色
             size = 0.5) + # 水平線の太さ
  geom_vline(xintercept = 20, # 垂直線の横軸との交点
             color = "Forestgreen", # 垂直線の色
             size = 0.5) + # 垂直線の太さ
  geom_abline(intercept = 0, # 直線の切片
              slope = 1, # 直線の傾き
              color = "gold", # 直線の色
              size = 0.5) + # 直線の太さ
  geom_point(alpha = 1.0, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             size = 2.0, # ポイントの大きさ
             stroke = 0.5) # 線の太さ


## 散布図＆コネクタ
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


## 散布図＆近似曲線
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy)) +
  geom_point(alpha = 1.0, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             size = 2.0, # ポイントの大きさ
             stroke = 0.5) + # 線の太さ
  geom_smooth(formula = y ~ x, # 近似曲線の推計式
              method = "loess", # 近似手法 (lm, glm, gam, loess)
              alpha = 0.5, # 誤差範囲の透明度
              color = "black", # 近似曲線の色
              fill = "gray", # 誤差範囲の色
              linetype = "dashed", # 近似曲線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
              size = 1.0) # 近似曲線の太さ


## 散布図＆ラベル
ggplot(data = data_mpg_point,
       mapping = aes(x = cty, y = hwy)) +
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
                  family = "YUGO", # テキストのフォント
                  fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
                  size = 4.0) # テキストのサイズ


## バブルチャート＆ラベル
ggplot(data = data_mpg_point,
       mapping = aes(x = cty, y = hwy, size = displ)) + # aes() 関数内のsize引数に連続型変数を指定
  geom_point(alpha = 1.0, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             stroke = 0.5) + # 線の太さ
  geom_text_repel(mapping = aes(label = manufacturer),
                  seed = NA, # テキストの配置を決定するランダムシード
                  direction = "both", # テキストの整列方向 (both / x / y)
                  hjust = 0.0, # 横方向の整列位置 (0-1) 
                  vjust = 0.5, # 縦方向の整列位置 (0-1)
                  nudge_x = NULL, # マーカーからの横方向のスペース (NULL, 0-)
                  nudge_y = NULL, # マーカーからの縦方向のスペース (NULL, 0-)
                  box.padding = 1.0, # テキスト周囲のスペース (0-)
                  point.padding = 0.1, # マーカー周囲のスペース (0-)
                  segment.alpha = 1.0, # 引き出し線の透明度
                  segment.color = "grey", # 引き出し線の色
                  segment.size = 0.5, # 引き出し線の太さ
                  min.segment.length = 0, # 引き出し線の最低長
                  color = "black", # テキストの色
                  family = "YUGO", # テキストのフォント
                  fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
                  size = 4.0) + # テキストのサイズ
  scale_size_area(max_size = 15) # 変量とポイントの面積を比例させる



# 棒グラフ geom_col() ---------------------------------------------------------

## X軸：離散型変数
## Y軸：連続型変数

## サンプルデータの作成
data_mpg_col <- mpg %>% 
  dplyr::group_by(manufacturer) %>% 
  dplyr::summarise(across(c(cty, hwy), mean, na.rm = TRUE))

View(data_mpg_col)

data_owid_col <- data_owid %>% 
  dplyr::select(location, date, new_cases) %>% 
  dplyr::filter(location %in% c("Japan", "United Kingdom", "Germany", "France", "Italy")) %>% 
  dplyr::mutate(year = str_c(lubridate::year(date), "年"), .after = "date") %>% 
  dplyr::group_by(location, year) %>% 
  dplyr::summarise(across(new_cases, sum, na.rm = TRUE))

View(data_owid_col)


## 縦棒グラフ
ggplot(data = data_mpg_col,
         mapping = aes(x = manufacturer, y = cty)) + 
  geom_col(alpha = 1.0, # 塗りつぶしの透明度
           color = "darkblue", # 線の色
           fill = "lightblue", # 塗りつぶしの色
           size = 0.5, # 線の太さ
           width = 0.9) # 棒の幅 (0-1)


## 横棒グラフ
ggplot(data = data_mpg_col,
       mapping = aes(x = manufacturer, y = cty)) + 
  geom_col(alpha = 1.0, # 塗りつぶしの透明度
           color = "darkblue", # 線の色
           fill = "lightblue", # 塗りつぶしの色
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  coord_flip()


## 縦棒グラフの並べ替え
ggplot(data = data_mpg_col,
       mapping = aes(x = fct_reorder(manufacturer, -cty), y = cty)) + 
  geom_col(alpha = 1.0, # 塗りつぶしの透明度
           color = "darkblue", # 線の色
           fill = "lightblue", # 塗りつぶしの色
           size = 0.5, # 線の太さ
           width = 0.9) # 棒の幅 (0-1)


## 縦棒グラフ＆ラベル
ggplot(data = data_mpg_col,
       mapping = aes(x = fct_reorder(manufacturer, -cty), y = cty)) + 
  geom_col(alpha = 1.0, # 塗りつぶしの透明度
           color = "darkblue", # 線の色
           fill = "lightblue", # 塗りつぶしの色
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  geom_text(mapping = aes(label = cty %>% sprintf(fmt = "%0.1f")), # sprintf() 関数で数値の表示形式を指定
            vjust = -1, # 縦方向の整列位置 (0-1)
            color = "black", # テキストの色
            family = "YUGO", # テキストのフォント
            fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
            size = 4.0) # テキストのサイズ


## 縦棒グラフ（横並び）
ggplot(data = data_owid_col,
       mapping = aes(x = location, y = new_cases, fill = year, group = rev(year))) + 
  geom_col(position = position_dodge(width = 0.5), # 横並びポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) # 棒の幅 (0-1)


## 縦棒グラフ（積み上げ）
ggplot(data = data_owid_col,
       mapping = aes(x = location, y = new_cases, fill = year, group = rev(year))) + 
  geom_col(position = position_stack(), # 積み上げポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  guides(fill = guide_legend(reverse = TRUE))


## 縦棒グラフ（積み上げ）＆ラベル
ggplot(data = data_owid_col,
       mapping = aes(x = location, y = new_cases, fill = year, group = rev(year))) + 
  geom_col(position = position_stack(), # 積み上げポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  geom_text(mapping = aes(label = new_cases %>% sprintf(fmt = "%0.1f")), # sprintf() 関数で数値の表示形式を指定
            position = position_stack(vjust = 0.5), # position_stack() 関数で積み上げ棒グラフ上のラベル位置を指定
            color = "white", # テキストの色
            family = "YUGO", # テキストのフォント
            fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
            size = 4.0) + # テキストのサイズ
  guides(fill = guide_legend(reverse = TRUE))


## 縦棒グラフ（割合）
ggplot(data = data_owid_col,
       mapping = aes(x = location, y = new_cases, fill = year, group = rev(year))) + 
  geom_col(position = position_fill(), # 割合ポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  guides(fill = guide_legend(reverse = TRUE))


## 縦棒グラフ（割合）＆ラベル
data_owid_col %>% 
  dplyr::group_by(location) %>% 
  dplyr::mutate(percent = new_cases / sum(new_cases)) %>% 
  ggplot(mapping = aes(x = location, y = new_cases, fill = year, group = rev(year))) + 
  geom_col(position = position_fill(), # 割合ポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  geom_text(mapping = aes(label = percent %>% sprintf(fmt = "%0.2f")), # sprintf() 関数で数値の表示形式を指定
            position = position_fill(vjust = 0.5), # position_fill() 関数で割合棒グラフ上のラベル位置を指定
            color = "white", # テキストの色
            family = "YUGO", # テキストのフォント
            fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
            size = 4.0) + # テキストのサイズ
  guides(fill = guide_legend(reverse = TRUE))



# 折れ線・面・ステップグラフ geom_line() geom_area() geom_ribbon() geom_step() ------------------------------------------------------

## X軸：日付型変数
## Y軸：連続型変数

## サンプルデータの作成

data_owid_line <- data_owid %>%
  dplyr::select(location, date, new_cases_smoothed) %>% 
  dplyr::filter(location %in% c("Japan", "United Kingdom", "Germany", "France", "Italy"),
                date >= "2022-01-01") %>% 
  tidyr::drop_na(everything())

View(data_owid_line)

data_owid_step <- data_owid %>% 
  dplyr::select(location, date, stringency_index) %>% 
  dplyr::filter(location %in% c("Japan", "United Kingdom", "Germany", "France", "Italy"))

View(data_owid_step)


## 折れ線グラフ
ggplot(data = economics,
       mapping = aes(x = date, y = unemploy)) +
  geom_line(alpha = 1.0, # 線の透明度
            color = "darkblue", # 線の色
            linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
            size = 1.0) # 線の太さ


## 折れ線グラフ＆マーカー
ggplot(data = economics,
       mapping = aes(x = date, y = unemploy)) +
  geom_line(alpha = 1.0, # 線の透明度
            color = "darkblue", # 線の色
            linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
            size = 1.0) + # 線の太さ
  geom_point(alpha = 1.0, # 塗りつぶしの透明度
             color = "darkblue", # 線の色
             fill = "lightblue", # 塗りつぶしの色
             shape = 21, # ポイントの種類
             size = 2.0, # ポイントの大きさ
             stroke = 0.5) # 線の太さ


## 折れ線グラフ＆系列ラベル
ggplot(data = data_owid_line,
       mapping = aes(x = date, y = new_cases_smoothed, color = location)) +
  geom_line(alpha = 1.0, # 線の透明度
            linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
            size = 1.0) + # 線の太さ
  geom_text_repel(data = data_owid_line %>%
                    dplyr::group_by(location) %>% 
                    dplyr::filter(date == max(date)),
                  mapping = aes(x = date, y = new_cases_smoothed, label = location),
                  seed = NA, # テキストの配置を決定するランダムシード
                  direction = "y", # テキストの整列方向 (both / x / y)
                  hjust = 0.0, # 横方向の整列位置 (0-1) 
                  vjust = 0.5, # 縦方向の整列位置 (0-1)
                  nudge_x = 5, # マーカーからの横方向のスペース (NULL, 0-)
                  nudge_y = NULL, # マーカーからの縦方向のスペース (NULL, 0-)
                  box.padding = 0.1, # テキスト周囲のスペース (0-)
                  point.padding = 0.1, # マーカー周囲のスペース (0-)
                  segment.alpha = 1.0, # 引き出し線の透明度
                  segment.color = "grey", # 引き出し線の色
                  segment.size = 0.5, # 引き出し線の太さ
                  min.segment.length = Inf, # 引き出し線の最低長
                  family = "YUGO", # テキストのフォント
                  fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
                  size = 3.0) + # テキストのサイズ
  scale_x_date(date_breaks = "1 month",　# 日付目盛の周期
               date_labels = "%y/%b", # %Y：4桁年、%y：2桁年、%m：2桁月、%b：1桁月、%d：日
               limits = c(as.Date("2022/01/01"), NA), # 始期・終期（指定しない場合はNA）
               expand = expansion(mult = c(0.00, 0.2), add = c(0, 0))) + # 始期・終期からの余白（multは余白率、addは余白幅）
  theme(legend.position = "none")


## 面グラフ
ggplot(data = economics,
       mapping = aes(x = date, y = unemploy)) +
  geom_area(alpha = 1.0, # 線の透明度
            color = "darkblue", # 線の色
            fill = "lightblue", # 塗りつぶしの色
            linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
            size = 1.0) # 線の太さ


## 面グラフ（積み上げ）
data_owid_line %>% 
  dplyr::mutate(location = factor(location,
                                  levels = c("Japan", "United Kingdom", "Germany", "France", "Italy") %>% rev())) %>% 
  ggplot(mapping = aes(x = date, y = new_cases_smoothed, fill = location)) +
  geom_area(position = position_stack(),
            alpha = 1.0, # 線の透明度
            linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
            size = 1.0) # 線の太さ


## リボングラフ
data_owid_line %>% 
  dplyr::group_by(date) %>% 
  dplyr::summarise(new_cases_max = max(new_cases_smoothed, na.rm = TRUE),
                   new_cases_min = min(new_cases_smoothed, na.rm = TRUE)) %>% 
  ggplot(mapping = aes(x = date, ymin = new_cases_min, ymax = new_cases_max)) +
  geom_ribbon(alpha = 1.0, # 線の透明度
              color = "darkblue", # 線の色
              fill = "lightblue", # 塗りつぶしの色
              linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
              size = 0.5) # 線の太さ


## ステップグラフ
ggplot(data = data_owid_step,
       mapping = aes(x = date, y = stringency_index, color = location)) +
  geom_step(alpha = 1.0, # 線の透明度
            linetype = "solid", # 線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
            size = 1.0) # 線の太さ



# 箱ひげ・ヴァイオリングラフ geom_boxplot() geom_violin() geom_dotplot() geom_jitter() geom_dotplot() ---------------------------

## X軸：離散型変数
## Y軸：連続型変数

## 箱ひげグラフ
ggplot(data = mpg,
       mapping = aes(x = class, y = hwy)) +
  geom_boxplot(outlier.alpha = 1.0, # 外れ値マーカーの塗りつぶしの透明度
               outlier.color = "darkblue", # 外れ値マーカーの線の色
               outlier.fill = "lightblue", # 外れ値マーカーの塗りつぶしの色
               outlier.shape = 21, # 外れ値マーカーの種類（外れ値を表示しない場合はNA）
               outlier.size = 2.0, # 外れ値マーカーの大きさ
               outlier.stroke = 0.5, # 外れ値マーカーの線の太さ
               alpha = 0.5, # 箱の塗りつぶしの透明度
               color = "darkblue", # 箱ひげの線の色
               fill = "lightblue", # 箱の塗りつぶしの色
               size = 0.5) # 箱ひげの線の太さ


## 箱ひげグラフ＆ジッターグラフ
ggplot(data = mpg,
       mapping = aes(x = class, y = hwy)) +
  geom_boxplot(outlier.shape = NA, # 外れ値マーカーの種類（外れ値を表示しない場合はNA）
               alpha = 0.5, # 箱の塗りつぶしの透明度
               color = "darkblue", # 箱ひげの線の色
               fill = "lightblue", # 箱の塗りつぶしの色
               size = 0.5) + # 箱ひげの線の太さ
  geom_jitter(height = 0.3, # マーカーの縦方向の分布範囲
              width = 0.3, # マーカーの横方向の分布範囲
              alpha = 1.0, # マーカーの塗りつぶしの透明度
              color = "darkblue", # マーカーの線の色
              fill = "darkblue", # マーカーの塗りつぶしの色
              shape = 21, # マーカーの種類
              size = 1.0, # マーカーの大きさ
              stroke = 0.5) # マーカーの線の太さ


## ヴァイオリングラフ
ggplot(data = mpg,
       mapping = aes(x = class, y = hwy)) +
  geom_violin(scale = "area", # ヴァイオリンの大きさ（area：すべての面積が同じ、count：サンプル個数に比例、width：すべての幅が同じ）
              alpha = 0.5, # ヴァイオリンの塗りつぶしの透明度
              color = "darkblue", # ヴァイオリンの線の色
              fill = "lightblue", # ヴァイオリンの塗りつぶしの色
              linetype = "solid", # ヴァイオリンの線の種類
              size = 0.5) # ヴァイオリンの線の太さ


## ヴァイオリングラフ
ggplot(data = mpg,
       mapping = aes(x = class, y = hwy)) +
  geom_violin(scale = "area", # ヴァイオリンの大きさ（area：すべての面積が同じ、count：サンプル個数に比例、width：すべての幅が同じ）
              alpha = 0.5, # ヴァイオリンの塗りつぶしの透明度
              color = "darkblue", # ヴァイオリンの線の色
              fill = "lightblue", # ヴァイオリンの塗りつぶしの色
              linetype = "solid", # ヴァイオリンの線の種類
              size = 0.5) + # ヴァイオリンの線の太さ
  geom_jitter(height = 0.4, # マーカーの縦方向の分布範囲
              width = 0.4, # マーカーの横方向の分布範囲
              alpha = 1.0, # マーカーの塗りつぶしの透明度
              color = "darkblue", # マーカーの線の色
              fill = "darkblue", # マーカーの塗りつぶしの色
              shape = 21, # マーカーの種類
              size = 1.0, # マーカーの大きさ
              stroke = 0.5) # マーカーの線の太さ


## ドットプロット
ggplot(data = mpg,
       mapping = aes(x = class, y = hwy)) +
  geom_dotplot(binaxis = "y",
               binwidth = 0.5,
               stackdir = "center",
               alpha = 1.0, # マーカーの塗りつぶしの透明度
               color = "darkblue", # マーカーの線の色
               fill = "lightblue", # マーカーの塗りつぶしの色
               stroke = 0.5) # マーカーの線の太さ



# 軸の設定 ---------------------------------------------------------------------

## サンプルデータの作成
data_owid_scale <- data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise(across(c(new_cases, new_deaths), mean, na.rm = TRUE))

View(data_owid_scale)
summary(data_owid_scale)


## X軸：連続型変数、Y軸：連続型変数
ggplot(data = data_owid_scale,
       mapping = aes(x = new_cases, y = new_deaths)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous(breaks = breaks_x <- seq(0, 1e+06, 100000), # 目盛
                     labels = breaks_x, # 目盛ラベル
                     limits = c(0, 7e+05), # 下限・上限値（指定しない場合はNA）
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  scale_y_continuous(breaks = breaks_y <- seq(0, 10000, 1000), # 目盛
                     labels = breaks_y, # 目盛ラベル
                     limits = c(0, 8000), # 下限・上限値（指定しない場合はNA）
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  labs(x = "新規感染者数（1日当たり平均、人）", # X軸のタイトル
       y = "新規死亡者数（1日当たり平均、人）") + # Y軸のタイトル
  theme(axis.title = element_text(size = 8)) # 軸タイトルの文字サイズ


## 対数目盛
ggplot(data = data_owid_scale,
       mapping = aes(x = new_cases, y = new_deaths)) +
  geom_point() +
  geom_smooth() +
  scale_x_log10(breaks = breaks_x <- 10 ** seq(0, 6, 1), # 目盛
                     labels = c(breaks_x[1:4], "1万", "10万", "100万"), # 目盛ラベル
                     limits = c(1, 7e+05), # 下限・上限値（指定しない場合はNA）
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  scale_y_log10(breaks = breaks_y <- 10 ** seq(0, 4, 1), # 目盛
                     labels = c(breaks_y[1:4], "1万"), # 目盛ラベル
                     limits = c(1, 8000), # 下限・上限値（指定しない場合はNA）
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  labs(x = "新規感染者数（1日当たり平均、人）", # X軸のタイトル
       y = "新規死亡者数（1日当たり平均、人）") + # Y軸のタイトル
  theme(axis.title = element_text(size = 8)) # 軸タイトルの文字サイズ


## X軸：日付、Y軸：連続型変数（date_breaksを使用する場合）
ggplot(data = economics,
       mapping = aes(x = date, y = unemploy)) + 
  geom_line() +
  scale_x_date(date_breaks = "3 month",　# 日付目盛の周期
               date_labels = "%y/%b", # 日付フォーマット（%Y：4桁年、%y：2桁年、%m：2桁月、%b：1桁月、%d：日）
               limits = c(as.Date("2000/01/01"), as.Date("2002/12/31")), # 始期・終期（指定しない場合はNA）
               expand = expansion(mult = c(0.00, 0.00), add = c(0, 0))) + # 始期・終期からの余白（multは余白率、addは余白幅）
  scale_y_continuous(breaks = breaks_y <- seq(0, 50000, 1000), # 目盛
                     labels = breaks_y, # 目盛ラベル
                     limits = c(5000, 10000), # 下限・上限値（指定しない場合はNA）
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  labs(x = "日付（年/月）", # X軸のタイトル
       y = "失業者数（千人）") + # Y軸のタイトル
  theme(axis.title = element_text(size = 8)) # 軸タイトルの文字サイズ


## X軸：日付、Y軸：連続型変数（date_breaksを使用しない場合）
ggplot(data = economics,
       mapping = aes(x = date, y = unemploy)) + 
  geom_line() +
  scale_x_date(breaks = breaks_x <- seq(as.Date("1967-01-01"), max(economics$date), by = "3 months"), # 日付目盛ベクトル
               date_labels = str_c(str_sub(lubridate::year(breaks_x), 3, 4), "/", lubridate::month(breaks_x)), # 日付目盛ベクトルをラベル用に加工
               limits = c(as.Date("2000/01/01"), as.Date("2002/12/31")), # 始期・終期（指定しない場合はNA）
               expand = expansion(mult = c(0.00, 0.00), add = c(0, 0))) + # 始期・終期からの余白（multは余白率、addは余白幅）
  scale_y_continuous(breaks = breaks_y <- seq(0, 50000, 1000), # 目盛
                     labels = breaks_y, # 目盛ラベル
                     limits = c(5000, 10000), # 下限・上限値（指定しない場合はNA）
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  labs(x = "日付（年/月）", # X軸のタイトル
       y = "失業者数（千人）") + # Y軸のタイトル
  theme(axis.title = element_text(size = 8)) # 軸タイトルの文字サイズ



# タイトル・目盛線・凡例・保存 theme() ggsave() -------------------------------------------------------------------

## タイトル・キャプション
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy, fill = class)) +
  geom_point(shape = 21,
             size = 2.0) +
  labs(title = "車体クラス別の一般道燃費と高速道燃費", # 図表タイトル
       caption = "（出所）EPA.gov", # キャプション
       fill = "車体クラス")　+ # 凡例に使用するscaleのタイトル
  theme(plot.title = element_text(size = 10, # 図表タイトルの文字サイズ
                                  face = "bold", # 図表タイトルの書体
                                  hjust = 0.5), # 図表タイトルの横整列位置
        plot.caption = element_text(size = 8, # キャプションの文字サイズ
                                    face = "plain", # キャプションの書体
                                    hjust = 0.0)) # キャプションの横整列位置


## パネル目盛線
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy, fill = class)) +
  geom_point(shape = 21,
             size = 2.0) +
  theme(panel.grid.major = element_line(color = "grey", # 主目盛線の色
                                        linetype = "dashed", # 主目盛線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
                                        size = 0.2), # 主目盛線の太さ
        panel.grid.minor = element_blank()) # 補助目盛り線は表示しない


## 凡例
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy, fill = class)) +
  geom_point(shape = 21,
             size = 2.0) +
  theme(legend.title = element_text(size = 8, # 凡例タイトルの文字サイズ
                                    face = "bold", # 凡例タイトルの書体
                                    hjust = 0.0), # 凡例タイトルの横整列位置
        legend.text = element_text(size = 6), # 凡例ラベルの文字サイズ
        legend.box.background = element_rect(color = "grey", # 凡例の枠線の色
                                             size = 0.5), # 凡例の枠線の太さ
        legend.margin = margin(t = 1, # 凡例の上マージン
                               b = 1, # 凡例の下マージン
                               r = 1, # 凡例の右マージン
                               l = 1, # 凡例の左マージン
                               unit = "mm"), # 凡例マージンの単位
        legend.justification = c(1.0, 0.0), # 凡例の横整列位置・縦整列位置
        legend.position = c(0.95, 0.05)) + # 凡例の横位置・縦位置
  guides(fill = guide_legend(keywidth = unit(3, units = "mm"), # 凡例キーの幅
                             keyheight = unit(3, units = "mm"), # 凡例キーの高さ
                             direction = "vertical", # 凡例の整列方向（horizontal / vertical）
                             nrow = 3, # 凡例の行数
                             ncol = 3, # 凡例の列数
                             reverse = FALSE)) # 凡例順序の逆転


## その他設定
ggplot(data = mpg,
       mapping = aes(x = cty, y = hwy, fill = class)) +
  geom_point(shape = 21,
             size = 2.0) +
  theme(text = element_text(family = "YUGO", # 図表全体のフォント
                            size = 8), # 図表全体の無事サイズ
        plot.margin = margin(t = 1, # 図表の上マージン
                             b = 1, # 図表の下マージン
                             r = 1, # 図表の右マージン
                             l = 1, # 図表の左マージン
                             unit = "mm")) # 図表マージンの単位


## 保存
ggsave(filename = "plot/04_plot_theme.png", # 図表のファイル名
       width = 12.00, # 図表の横サイズ
       height = 9.00, # 図表の縦サイズ
       units = "cm", # 図表のサイズ単位
       dpi = 300) # 図表の解像度



# 実例 ----------------------------------------------------------------------

## 実例1：世界の新型コロナ死亡率のボックスプロット

data_plot <- data_owid %>% 
  dplyr::select(location, date, new_cases, new_deaths) %>% 
  dplyr::filter(date <= max(date) - 28) %>% 
  dplyr::mutate(year = lubridate::year(date)) %>% 
  dplyr::group_by(location, year) %>% 
  dplyr::summarise(across(c(new_cases, new_deaths), mean, na.rm = TRUE)) %>% 
  dplyr::mutate(mort_rate = 100 * new_deaths / new_cases,
                year = str_c(year, "年"))

View(data_plot)

ggplot(data = data_plot,
       mapping = aes(x = year, y = mort_rate, color = year, fill = year)) +
  geom_hline(yintercept = 0, # 水平線の縦軸との交点
             color = "gray", # 水平線の色
             size = 0.5) + # 水平線の太さ
  geom_boxplot(outlier.shape = NA, alpha = 0.25, size = 0.5) +
  geom_jitter(alpha = 0.5, size = 1.0, shape = 21) +
  scale_y_continuous(breaks = breaks_y <- seq(0, 100, 0.5), # 目盛
                     labels = breaks_y %>% sprintf(fmt = "%0.1f"), # 目盛ラベル
                     limits = c(0, 5), # 下限・上限値（指定しない場合はNA）
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  labs(x = element_blank(), # X軸のタイトル
       y = "新型コロナ感染者の致死率（％）") + # Y軸のタイトル
  theme(axis.title = element_text(size = 8)) + # 軸タイトルの文字サイズ
  labs(title = "世界各国の新型コロナ感染者の致死率（年別）", # 図表タイトル
       caption = "（注）箱の中の横線は中央値を示す。2022年は直近4週間のサンプルを除外。\n（出所）Our World in Data、@naohat23") + # キャプション
  theme(plot.title = element_text(size = 10, # 図表タイトルの文字サイズ
                                  face = "bold", # 図表タイトルの書体
                                  hjust = 0.5), # 図表タイトルの横整列位置
        plot.caption = element_text(size = 8, # キャプションの文字サイズ
                                    face = "plain", # キャプションの書体
                                    hjust = 0.0)) + # キャプションの横整列位置
  theme(panel.grid.major = element_line(color = "grey", # 主目盛線の色
                                        linetype = "dashed", # 主目盛線の種類（solid / dashed / dotted / dotdash / twodash / longdash）
                                        size = 0.2), # 主目盛線の太さ
        panel.grid.minor = element_blank()) + # 補助目盛り線は表示しない
  theme(legend.position = "none") + # 凡例の横位置・縦位置
  theme(text = element_text(family = "YUGO", # 図表全体のフォント
                            size = 8), # 図表全体の無事サイズ
        plot.margin = margin(t = 1, # 図表の上マージン
                             b = 1, # 図表の下マージン
                             r = 1, # 図表の右マージン
                             l = 1, # 図表の左マージン
                             unit = "mm")) # 図表マージンの単位


## 保存
ggsave(filename = "plot/04_plot_sample_1.png", # 図表のファイル名
       width = 12.00, # 図表の横サイズ
       height = 9.00, # 図表の縦サイズ
       units = "cm", # 図表のサイズ単位
       dpi = 600) # 図表の解像度

  