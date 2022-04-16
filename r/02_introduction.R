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



# データを読み込み・セーブ・ロード ----------------------------------------------------------------

## Our World in Dataの新型コロナデータをtibble型で読み込み
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


## データをセーブ
save(data_owid, # セーブするデータ
     file = "data/data_owid.RData") # セーブ先ファイルパス


## データをロード
load(file = "data/data_owid.RData") # ロード元ファイルパス


## CSV形式でデータをセーブ
write.csv(data_owid, # セーブするデータ
          file = "data/data_owid.csv", # セーブ先ファイルパス
          row.names = FALSE) # 行番号を付与するか



