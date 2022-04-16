# 03_tidyverse.R -------------------------------------------------------

## tidyverseを使用したデータベース操作

library(magrittr)
library(tidyverse)
library(tidyquant)



# サンプルデータを読み込み ------------------------------------------------------------

## Our World in Dataの新型コロナデータをtibble型で読み込み
data_owid <- readr::read_csv(file = "https://covid.ourworldindata.org/data/owid-covid-data.csv", # ファイルパス／URL
                             col_names = TRUE, # ヘッダー（列名データ）の有無
                             col_types = NULL, # 各列の型の指定（c：文字列型、d：数値型、D：日付型、l：論理値型）
                             skip = 0) # 読み込み時に上からスキップする行数

data_owid

View(data_owid)



# 列を選択 dplyr::select() ----------------------------------------------------------------

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



# 列の名前を変更 dplyr::rename() ----------------------------------------------------------------
data_owid %>% 
  dplyr::rename(country = location)



# 行をフィルタ dplyr::filter() ----------------------------------------------------------------

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



# 行を並べ替え dplyr::arrange() ----------------------------------------------------------------

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



# 列を追加・修正 dplyr::mutate() ----------------------------------------------------------------

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


## lag() 関数で変化率を計算
data_owid_jp %>% 
  dplyr::mutate(new_cases_chg = new_cases / dplyr::lag(new_cases, n = 1)) 


## rollmean() 関数で移動平均系列を作成（後方7日移動平均の例）
data_owid_jp %>% 
  dplyr::mutate(new_cases_7dma = zoo::rollmean(new_cases, k = 7, na.pad = TRUE, align = "right")) 


## case_when() 関数で条件別の系列を作成
data_owid_jp %>% 
  dplyr::mutate(case = case_when(new_cases < 1000 ~ "A",
                                 (new_cases >= 5000 & new_cases < 8000 ~ "B"),
                                 TRUE ~ "other"))


## mutate() 関数内で across() 関数を用い、対象の変数を複数指定して一括処理
## ~ {} は無名関数（ラムダ式）を表し、内部のドットはチルダの左側の値を代入することを意味する
data_owid_jp %>% 
  dplyr::mutate(across(new_cases:new_deaths, ~ {. / 1000}))

data_owid_jp %>% 
  dplyr::mutate(across(new_cases:new_deaths, ~ {. / dplyr::lag(., n = 1)})) 


# 既存の列の修正
data_owid %>% 
  dplyr::mutate(location = factor(location))



# グループ化 dplyr::group_by() ----------------------------------------------------------------

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



# 集計 dplyr::summarise() ----------------------------------------------------------------

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


## summarise() 関数内で across() 関数を用い、集計対象の変数を複数指定して一括処理
data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise(across(c(new_cases, new_deaths), sum, na.rm = TRUE)) 

data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise(across(ends_with("cases"), sum, na.rm = TRUE),
                   across(ends_with("per_million"), mean, na.rm = TRUE))

data_owid %>% 
  dplyr::group_by(location) %>% 
  dplyr::summarise(across(is.double, mean, na.rm = TRUE)) 



# 縦型・横型を変換 tidyr::pivot_*() ----------------------------------------------------------------

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



# 重複処理 dplyr::distinct() -------------------------------------------------------------

## 指定した列について重複している行を削除
data_owid %>% 
  dplyr::distinct(iso_code, location)



# 欠損値処理 drop_na() replace_na() fill() ----------------------------------------------------------------

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



# 時系列データの頻度変換 tidyquant::tq_transmute()  ----------------------------------

## サンプルデータを作成（日次データ）
data_owid_cases_wide <- data_owid %>% 
  dplyr::select(location, date, new_cases) %>% 
  dplyr::filter(date >= "2021-01-01") %>% 
  dplyr::arrange(date) %>% 
  tidyr::pivot_wider(id_cols = "date", names_from = "location", values_from = "new_cases")


## 日次データを週次データに変換
## 月曜～日曜のデータがFUNに指定した関数で集計され、日曜の日付で記録される
data_owid_cases_wide %>% 
  tidyquant::tq_transmute(select = -date, mutate_fun = apply.weekly, FUN = mean, na.rm = TRUE)


## 日曜～土曜のデータを集計し日曜の日付で記録するには、以下の方法で前方7日移動平均を計算し、日曜の値を抽出する
data_owid_cases_wide %>%
  dplyr::mutate(across(-date, rollmean, k = 7, na.pad = TRUE, align = "left")) %>% 
  dplyr::filter(lubridate::wday(date) == 1)


## 日次データを月次データに変換
## 月初～月末のデータがFUNに指定した関数で集計され、月末の日付で記録される
data_owid_cases_wide %>% 
  tidyquant::tq_transmute(select = -date, mutate_fun = apply.monthly, FUN = mean, na.rm = TRUE)


## 日次データを四半期データに変換
## 期初～期末のデータがFUNに指定した関数で集計され、期末の日付で記録される
data_owid_cases_wide %>% 
  tidyquant::tq_transmute(select = -date, mutate_fun = apply.quarterly, FUN = mean, na.rm = TRUE)
