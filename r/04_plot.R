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

## X軸：連続値
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

## X軸：連続値
## Y軸：なし

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



# 頻度棒グラフ geom_bar() ---------------------------------------------------------

## X軸：離散値
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

## X軸：離散値
## Y軸：離散値

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

## X軸：連続値
## Y軸：連続値

## サンプルデータの作成
data_mpg_point <- mpg %>% 
  dplyr::group_by(manufacturer) %>% 
  dplyr::summarise(across(c(displ, cty, hwy), mean, na.rm = TRUE))


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
  geom_smooth(formula = y ~ x,
              method = "loess", # 近似手法 (lm, glm, gam, loess)
              alpha = 0.5,
              color = "black",
              fill = "gray",
              linetype = "dashed",
              size = 1.0,
              weight = 1.0)


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
                  family = "MEIRYO", # テキストのフォント
                  fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
                  size = 4.0) # テキストのサイズ


## バブルチャート＆ラベル
ggplot(data = data_mpg_point,
       mapping = aes(x = cty, y = hwy, size = displ)) + # aes() 関数内のsize引数に連続値を指定
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
                  family = "MEIRYO", # テキストのフォント
                  fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
                  size = 4.0) + # テキストのサイズ
  scale_size_area(max_size = 15) # 変量とポイントの面積を比例させる



# 棒グラフ geom_col() ---------------------------------------------------------

## X軸が離散値
## Y軸が連続値

## サンプルデータの作成
data_mpg_col <- mpg %>% 
  dplyr::group_by(manufacturer) %>% 
  dplyr::summarise(across(c(cty, hwy), mean, na.rm = TRUE))

data_mpg_col_long <- data_mpg_col %>% 
  tidyr::pivot_longer(cols = -"manufacturer") %>% 
  dplyr::mutate(name = factor(name,
                              levels = c("cty", "hwy")))


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
       mapping = aes(x = manufacturer, y = cty)) + 
  geom_col(alpha = 1.0, # 塗りつぶしの透明度
           color = "darkblue", # 線の色
           fill = "lightblue", # 塗りつぶしの色
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  geom_text(mapping = aes(label = cty %>% sprintf(fmt = "%0.1f")), # sprintf() 関数で数値の表示形式を指定
            vjust = -1, # 縦方向の整列位置 (0-1)
            color = "black", # テキストの色
            family = "MEIRYO", # テキストのフォント
            fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
            size = 4.0) # テキストのサイズ


## 縦棒グラフ（横並び）
data_mpg_col_long %>% 
  ggplot(mapping = aes(x = manufacturer, y = value, fill = name, group = rev(name))) + 
  geom_col(position = position_dodge(width = 0.5), # 横並びポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) # 棒の幅 (0-1)


## 縦棒グラフ（積み上げ）
data_mpg_col_long %>% 
  ggplot(mapping = aes(x = manufacturer, y = value, fill = name, group = rev(name))) + 
  geom_col(position = position_stack(), # 積み上げポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  guides(fill = guide_legend(reverse = TRUE))


## 縦棒グラフ（積み上げ）＆ラベル
data_mpg_col_long %>% 
  ggplot(mapping = aes(x = manufacturer, y = value, fill = name, group = rev(name))) + 
  geom_col(position = position_stack(), # 積み上げポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  geom_text(mapping = aes(label = value %>% sprintf(fmt = "%0.1f")), # sprintf() 関数で数値の表示形式を指定
            position = position_stack(vjust = 0.5), # position_stack() 関数で積み上げ棒グラフ上のラベル位置を指定
            color = "white", # テキストの色
            family = "MEIRYO", # テキストのフォント
            fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
            size = 4.0) + # テキストのサイズ
  guides(fill = guide_legend(reverse = TRUE))


## 縦棒グラフ（割合）
data_mpg_col_long %>% 
  ggplot(mapping = aes(x = manufacturer, y = value, fill = name, group = rev(name))) + 
  geom_col(position = position_fill(), # 割合ポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  guides(fill = guide_legend(reverse = TRUE))


## 縦棒グラフ（割合）＆ラベル
data_mpg_col_long %>% 
  dplyr::group_by(manufacturer) %>% 
  dplyr::mutate(percent = value / sum(value)) %>% 
  ggplot(mapping = aes(x = manufacturer, y = value, fill = name, group = rev(name))) + 
  geom_col(position = position_fill(), # 割合ポジション
           alpha = 1.0, # 塗りつぶしの透明度
           size = 0.5, # 線の太さ
           width = 0.9) + # 棒の幅 (0-1)
  geom_text(mapping = aes(label = percent %>% sprintf(fmt = "%0.2f")), # sprintf() 関数で数値の表示形式を指定
            position = position_fill(vjust = 0.5), # position_fill() 関数で割合棒グラフ上のラベル位置を指定
            color = "white", # テキストの色
            family = "MEIRYO", # テキストのフォント
            fontface = "plain", # テキストの書体 (plain / bold / italic / bold.italic)
            size = 4.0) + # テキストのサイズ
  guides(fill = guide_legend(reverse = TRUE))



# 軸の設定・ラベル ---------------------------------------------------------------------

## サンプルデータの作成
data_owid_scale <- data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise(across(c(new_cases, new_deaths), mean, na.rm = TRUE))

summary(data_owid_scale)


## X軸：連続値、Y軸：連続値
ggplot(data = data_owid_scale,
       mapping = aes(x = new_cases, y = new_deaths)) +
  geom_point() +
  geom_smooth() +
  scale_x_continuous(breaks = breaks_x <- seq(0, 1e+06, 100000), # 目盛
                     labels = breaks_x, # 目盛ラベル
                     limits = c(0, 7e+05), # 下限・上限値
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  scale_y_continuous(breaks = breaks_y <- seq(0, 10000, 1000), # 目盛
                     labels = breaks_y, # 目盛ラベル
                     limits = c(0, 8000), # 下限・上限値
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  labs(x = "新規感染者数（1日当たり平均、人）", # X軸のラベル
       y = "新規死亡者数（1日当たり平均、人）") + # Y軸のラベル
  theme(axis.title = element_text(size = 8)) # 軸ラベルの大きさ


## 対数目盛
ggplot(data = data_owid_scale,
       mapping = aes(x = new_cases, y = new_deaths)) +
  geom_point() +
  geom_smooth() +
  scale_x_log10(breaks = breaks_x <- 10 ** seq(0, 6, 1), # 目盛
                     labels = c(breaks_x[1:4], "1万", "10万", "100万"), # 目盛ラベル
                     limits = c(1, 7e+05), # 下限・上限値
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  scale_y_log10(breaks = breaks_y <- 10 ** seq(0, 4, 1), # 目盛
                     labels = c(breaks_y[1:4], "1万"), # 目盛ラベル
                     limits = c(1, 8000), # 下限・上限値
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  labs(x = "新規感染者数（1日当たり平均、人）", # X軸のラベル
       y = "新規死亡者数（1日当たり平均、人）") + # Y軸のラベル
  theme(axis.title = element_text(size = 8)) # 軸ラベルの大きさ


## X軸：日付、Y軸：連続値（date_breaksを使用する場合）
ggplot(data = economics,
       mapping = aes(x = date, y = unemploy)) + 
  geom_line() +
  scale_x_date(date_breaks = "3 month",
               date_labels = "%y/%b", # %Y：4桁年、%y：2桁年、%m：2桁月、%b：1桁月、%d：日
               limits = c(as.Date("2000/01/01"), as.Date("2002/12/31")),
               expand = expansion(mult = c(0.00, 0.00), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  scale_y_continuous(breaks = breaks_y <- seq(0, 50000, 1000), # 目盛
                     labels = breaks_y, # 目盛ラベル
                     limits = c(5000, 10000), # 下限・上限値
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  labs(x = "日付（年/月）", # X軸のラベル
       y = "失業者数（千人）") + # Y軸のラベル
  theme(axis.title = element_text(size = 8)) # 軸ラベルの大きさ


## X軸：日付、Y軸：連続値（date_breaksを使用しない場合）
ggplot(data = economics,
       mapping = aes(x = date, y = unemploy)) + 
  geom_line() +
  scale_x_date(breaks = breaks_x <- seq(as.Date("1967-01-01"), max(economics$date), by = "3 months"),
               date_labels = str_c(str_sub(lubridate::year(breaks_x), 3, 4), "/", lubridate::month(breaks_x)),
               limits = c(as.Date("2000/01/01"), as.Date("2002/12/31")),
               expand = expansion(mult = c(0.00, 0.00), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  scale_y_continuous(breaks = breaks_y <- seq(0, 50000, 1000), # 目盛
                     labels = breaks_y, # 目盛ラベル
                     limits = c(5000, 10000), # 下限・上限値
                     expand = expansion(mult = c(0.05, 0.05), add = c(0, 0))) + # 下限・上限値からの余白（multは余白率、addは余白幅）
  labs(x = "日付（年/月）", # X軸のラベル
       y = "失業者数（千人）") + # Y軸のラベル
  theme(axis.title = element_text(size = 8)) # 軸ラベルの大きさ

  



