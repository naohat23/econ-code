# 02_introduction.R -------------------------------------------------------

## Rの基本的な使用方法

library(tidyverse)
library(tidyquant)



# 主要ショートカットキー ---------------------------------------------------------------

## Alt + Shit + K：キーボードショートカット表示

## 編集
## Ctrl + S：保存
## Ctrl + Shift + R：セクション区切り
## Ctrl + Shift + C：選択範囲をコメントアウト／コメントアウト解除
## Ctrl + Shift + M：パイプオペレータを挿入

## 実行
## Ctrl + Enter：カーソルがある行／選択している行のコードを実行
## Ctrl + Alt + T：カーソルがあるセクションのコードをすべて実行
## Ctrl + Alt + R：すべてのコードを実行

## その他
## F1：カーソルがある関数のヘルプを表示



# 基本操作・ベクトル・リスト・関数 ------------------------------------------------------------

## パッケージのインポート
library(tidyverse)


## 単純計算
1 + 1
1 - 1
2 * 3
10 / 5
3 ** 3


## ベクトル
x <- c(11, 12, 13, 14, 15)
x
x[1]
x[5]
x[2:4]
rev(x)[1]

hello <- c("Hello", "World")
hello


## リスト
y <- list(x, hello)
y
y[1]
y[[1]]
y[[1]][1:3]


## R標準関数
z <- seq(from = 1, to = 5, by = 1)
z 

mean(z)


## 外部パッケージで提供される関数（パッケージのインポートが必要）
stringr::str_c(hello, collapse = "")
str_c(hello, collapse = ", ")



## 変数の削除
rm(
  x,
  y,
  z
)



# データを読み込み ----------------------------------------------------------------

## データをtibble型で読み込み
data_owid <- readr::read_csv(file = "https://covid.ourworldindata.org/data/owid-covid-data.csv", # ファイルパス／URL
                             col_names = TRUE, # ヘッダー（列名データ）の有無
                             col_types = NULL, # 各列の型の指定（c：文字列型、d：数値型、D：日付型、l：論理値型）
                             skip = 0) # 読み込み時に上からスキップする行数


## コンソールにデータ上部を表示
data_owid


## コンソールにデータ下部を表示
tail(data_owid)


## データを新しいタブに表示
View(data_owid)



# select() 関数で列（変数）を選択 ----------------------------------------------------------------

## 列名を入力して列を選択
data_owid %>% 
  dplyr::select(location, date, new_cases)


## ベクトルを用いて列を選択
cols <- c("location", "date", "new_cases")
data_owid %>% 
  dplyr::select(cols) 


## 列を削除
data_owid %>% 
  dplyr::select(-location) 


## 列名に特定の文字列を含む列を選択
data_owid %>% 
  dplyr::select(location, date, contains("cases")) 


## 列名が特定の文字列から始まる列を選択
data_owid %>% 
  dplyr::select(location, date, starts_with("new_cases")) 


## 列名が特定の文字列で終わる列を選択
data_owid %>% 
  dplyr::select(location, date, ends_with(c("cases", "deaths"))) 


## 特定の型の列を選択
data_owid %>% 
  dplyr::select(where(is.character) | where(is.logical)) 



# rename() 関数で列名（変数名）を変更 ----------------------------------------------------------------
data_owid %>% 
  dplyr::rename(country = location)



# filter() 関数で行をフィルタ ----------------------------------------------------------------

## 条件を入力して行をフィルタ
data_owid %>% 
  dplyr::filter(location == "Japan")


## NOT条件
data_owid %>% 
  dplyr::filter(continent != "Asia") 


## 複数条件を指定すると順番に適用
data_owid %>% 
  dplyr::filter(location == "Japan",
                date >= "2021-01-01",
                date <= "2021-01-07") 


## 順番に適用しないためには、AND条件・OR条件を明示的に指定
data_owid %>% 
  dplyr::filter((date == "2022-01-01") & (location == "Japan" | location == "United States")) 


## ベクトルと%in%演算子を用いてOR条件でフィルタ（日本と米国を抽出）
locations <- c("Japan", "United States")
data_owid %>% 
  dplyr::filter(location %in% locations, 
                date == "2021-01-01")


## OR条件のNOT条件（日本と米国以外を抽出）
data_owid %>% 
  dplyr::filter(!location %in% locations, 
                date == "2021-01-01")


## 関数を使用してフィルタ条件を指定
data_owid %>% 
  dplyr::filter(date == max(date)) 


## 論理値を返す関数は==がなくてもフィルタ条件として使用可能
data_owid %>% 
  dplyr::filter(is.na(new_cases)) 



# arrange() 関数で行を並べ替え（ソート） ----------------------------------------------------------------

## 昇順ソート
data_owid %>% 
  dplyr::arrange(new_cases) 


## 降順ソート
data_owid %>% 
  dplyr::arrange(-new_cases) 


## 降順ソート（日付型の変数は-演算子で降順ソートができない）
data_owid %>% 
  dplyr::arrange(desc(date)) 


## 複数条件の場合は左から順番に適用
data_owid %>% 
  dplyr::arrange(desc(date), -new_cases) 



# mutate() 関数で新しい列（変数）を追加／既存の列（変数）を修正 ----------------------------------------------------------------

## サンプルデータを作成
data_owid_jp <- data_owid %>% 
  dplyr::select(location, date, new_cases, new_deaths) %>% 
  dplyr::filter(location == "Japan",
                date >= "2022-01-01")


## 既存の変数の計算結果として新しい変数を作成
data_owid_jp %>% 
  dplyr::mutate(death_rate = new_deaths / new_cases) 


## .after .before 引数で新しい変数を特定の位置に挿入
data_owid_jp %>% 
  dplyr::mutate(death_rate = new_deaths / new_cases,
                .after = "date") 


## lag() leag() 関数でラグ・リード系列を作成
data_owid_jp %>% 
  dplyr::mutate(new_cases_lag = dplyr::lag(new_cases, n = 1)) 


## rollmean() 関数で移動平均系列を作成
data_owid_jp %>% 
  dplyr::mutate(new_cases_7dma = zoo::rollmean(new_cases, k = 7, na.pad = TRUE, align = "right")) 


# 既存の列の修正
data_owid %>% 
  dplyr::mutate(location = factor(location))



# group_by() 関数でグループ化 ----------------------------------------------------------------

## グループの指定
## 見た目は変わらないが、出力の2行目にGroupsが追加されている
data_owid %>% 
  dplyr::group_by(location) 


## 複数のグループを指定
data_owid %>% 
  dplyr::group_by(continent, location)


## グループ化とフィルタを組み合わせて、各グループの最大値を抽出
data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::filter(new_cases == max(new_cases)) 


## ungroup() でグループ化解除
data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::ungroup() 



# summarise() 関数で集計 ----------------------------------------------------------------

## グループ化して指定した列の平均値を計算
data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise(new_cases_mean = mean(new_cases, na.rm = TRUE))


## グループ化して指定した列の最大値を計算
data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise(new_cases_max = max(new_cases, na.rm = TRUE))


## グループ化に複数条件を設定するとクロス集計が可能
data_owid %>% 
  dplyr::group_by(location, lubridate::year(date)) %>% 
  dplyr::summarise(new_cases_mean = mean(new_cases, na.rm = TRUE))


## summarise_at() 関数で集計対象の変数を複数指定して一括処理
data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise_at(vars(new_cases, new_deaths), sum, na.rm = TRUE) 


## summarise_at() 関数の vars() 関数内では変数選択用の関数も使用可能
data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise_at(vars(ends_with("cases")), sum, na.rm = TRUE) 


## summarise_if() 関数で集計対象の変数を条件指定して一括処理
data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise_if(is.double, mean, na.rm = TRUE) 



# pivot_longer() pivot_wider() 関数で縦型・横型を変換 ----------------------------------------------------------------

## サンプルデータを作成
data_owid_cases <- data_owid %>% 
  dplyr::select(location, date, new_cases) %>% 
  dplyr::filter(date >= "2021-01-01") %>% 
  dplyr::arrange(date)

data_owid_cases


## 縦型を横型に変換
data_owid_cases_wide <- data_owid_cases %>% 
  tidyr::pivot_wider(id_cols = "date", names_from = "location", values_from = "new_cases") 

data_owid_cases_wide


## 横型を縦型に変換
data_owid_cases_long <- data_owid_cases_wide %>% 
  tidyr::pivot_longer(cols = -"date", names_to = "location", values_to = "new_cases") 

data_owid_cases_long


## こうした複数の変数の縦型変換はggplotによる図表作成で多用する
data_owid %>% 
  dplyr::select(location, date, new_cases, new_deaths) %>% 
  tidyr::pivot_longer(cols = c("new_cases", "new_deaths")) 


# drop_na() replace_na() fill() 関数で欠損値処理 ----------------------------------------------------------------

## サンプルデータを作成
data_owid_vaccinated <- data_owid %>% 
  dplyr::select(location, date, people_fully_vaccinated) %>% 
  dplyr::filter(location %in% c("Japan", "United States", "United Kingdom"),
                date >= "2021-01-01") %>% 
  dplyr::arrange(date) %>% 
  tidyr::pivot_wider(id_cols = "date", names_from = "location", values_from = "people_fully_vaccinated")

tail(data_owid_vaccinated)


## 指定した列にNAが含まれている行を削除
data_owid_vaccinated %>% 
  tidyr::drop_na(Japan) %>%  
  tail()


## 少なくとも1つの列にNAが含まれている行を削除
data_owid_vaccinated %>% 
  tidyr::drop_na(everything()) %>%  
  tail()


## 指定した列のNAを別の値に置換
data_owid_vaccinated %>% 
  dplyr::mutate(Japan = tidyr::replace_na(data = Japan, replace = 0)) %>%  
  tail()


## mutate_at() 関数で対象変数を複数指定して一括処理
data_owid_vaccinated %>% 
  dplyr::mutate_at(vars(-date), tidyr::replace_na, replace = 0) %>% 
  tail()


## tidyr::fill() 関数で指定した列のNAの値を直前の値に置換
data_owid_vaccinated %>% 
  tidyr::fill(Japan, .direction = "down") %>% 
  tail()


## tidyr::fill() 関数ですべての列のNAの値を直前の値に置換
data_owid_vaccinated %>% 
  tidyr::fill(c(-date, everything()), .direction = "down") %>% 
  tail()



# distinct() 関数で重複処理 -------------------------------------------------------------

## 指定した列について重複している行を削除
data_owid %>% 
  dplyr::distinct(iso_code, location)



