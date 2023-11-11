# インターネットTV データベース作成

データベース作成の練習として,インターネットTVを題材に MySQL を用いてサンプルを作成した.

## 目次

- [概要](#概要)
- [要件](#要件)
- [step 1](#step-1)
- [step 2](#step-2)
- [step 3](#step-3)


## 概要

3 step でインターネットTVのデータベースを作成する。  

- step 1 ではテーブル設計を行う。
- step 2 では実際にMySQL上にテーブルを作成し、サンプルデータを入力する。また、その手順をドキュメント化する。
- step 3 では幾つかの条件でデータ抽出を行う。

## 要件

- ドラマ1、ドラマ2、アニメ1、アニメ2、スポーツ、ペットなど、複数のチャンネルがある
- 各チャンネルの下では時間帯ごとに番組枠が1つ設定されており、番組が放映される
- 番組はシリーズになっているものと単発ものがある。シリーズになっているものはシーズンが1つものと、シーズン1、シーズン2のように複数シーズンのものがある。各シーズンの下では各エピソードが設定されている
- 再放送もあるため、ある番組が複数チャンネルの異なる番組枠で放映されることはある
- 番組の情報として、タイトル、番組詳細、ジャンルが画面上に表示される
- 各エピソードの情報として、シーズン数、エピソード数、タイトル、エピソード詳細、動画時間、公開日、視聴数が画面上に表示される。単発のエピソードの場合はシーズン数、エピソード数は表示されない
- ジャンルとしてアニメ、映画、ドラマ、ニュースなどがある。各番組は1つ以上のジャンルに属する
- KPIとして、チャンネルの番組枠のエピソードごとに視聴数を記録する。なお、一つのエピソードは複数の異なるチャンネル及び番組枠で放送されることがあるので、属するチャンネルの番組枠ごとに視聴数がどうだったかも追えるようにする

## step 1

### channels テーブル

| カラム名    | データ型     | NULL | キー    | 初期値    | AUTO INCREMENT |
| ----------- | ------------ | ---- | ------- | --------- | -------------- |
| id          | integer      | NO   | PRIMARY | NULL      | YES            |
| name        | varchar(255) | NO   | INDEX   | NULL      | NO             |
| explanation | varchar(255) | NO   |         | NULL      | NO             |
| created_at  | datetime     | NO   |         | timestamp | NO             |
| updated_at  | datetime     | NO   |         | timestamp | NO             |

### programs テーブル

| カラム名    | データ型     | NULL | キー    | 初期値    | AUTO INCREMENT |
| ----------- | ------------ | ---- | ------- | --------- | -------------- |
| id          | bigint       | NO   | PRIMARY | NULL      | YES            |
| name        | varchar(255) | NO   | INDEX   | NULL      | NO             |
| explanation | varchar(255) | NO   |         | NULL      | NO             |
| created_at  | datetime     | NO   |         | timestamp | NO             |
| updated_at  | datetime     | NO   |         | timestamp | NO             |

### episodes テーブル

| カラム名     | データ型     | NULL | キー    | 初期値    | AUTO INCREMENT |
| ------------ | ------------ | ---- | ------- | --------- | -------------- |
| id           | bigint       | NO   | PRIMARY | NULL      | YES            |
| name         | varchar(255) | NO   |         | NULL      | NO             |
| explanation  | varchar(255) | NO   |         | NULL      | NO             |
| episode_no   | integer      | NO   | INDEX   | NULL      | NO             |
| release_data | date         | NO   |         | NULL      | NO             |
| created_at   | datetime     | NO   |         | timestamp | NO             |
| updated_at   | datetime     | NO   |         | timestamp | NO             |

### program_episodes テーブル

| カラム名   | データ型 | NULL | キー           | 初期値    | AUTO INCREMENT |
| ---------- | -------- | ---- | -------------- | --------- | -------------- |
| id         | bigint   | NO   | PRIMARY        | NULL      | YES            |
| season_no  | integer  | NO   |                | -1        | NO             |
| program_id | bigint   | NO   | FOREIGN        | NULL      | NO             |
| episode_id | bigint   | NO   | FOREIGN/UNIQUE | NULL      | NO             |
| created_at | datetime | NO   |                | timestamp | NO             |
| updated_at | datetime | NO   |                | timestamp | NO             |

### broadcasts テーブル

| カラム名       | データ型 | NULL | キー    | 初期値    | AUTO INCREMENT |
| -------------- | -------- | ---- | ------- | --------- | -------------- |
| id             | bigint   | NO   | PRIMARY | NULL      | YES            |
| channel_id     | integer  | NO   | FOREIGN | NULL      | NO             |
| episode_id     | bigint   | NO   | FOREIGN | NULL      | NO             |
| start_time     | datetime | NO   | INDEX   | NULL      | NO             |
| end_time       | datetime | NO   |         | NULL      | NO             |
| number_of_view | bigint   | NO   | INDEX   | 0         | NO             |
| created_at     | datetime | NO   |         | timestamp | NO             |
| updated_at     | datetime | NO   |         | timestamp | NO             |

### genres テーブル

| カラム名   | データ型    | NULL | キー    | 初期値    | AUTO INCREMENT |
| ---------- | ----------- | ---- | ------- | --------- | -------------- |
| id         | bigint      | NO   | PRIMARY | NULL      | YES            |
| program_id | bigint      | NO   | FOREIGN | NULL      | NO             |
| genre      | varchar(32) | NO   | INDEX   | NULL      | NO             |
| created_at | datetime    | NO   |         | timestamp | NO             |
| updated_at | datetime    | NO   |         | timestamp | NO             |

## step 2

下記ファイルに手順書を記した。  
[internet_tv手順書](/internet_tv_process_document.md)

## step 3

ある条件のデータを抽出するクエリを作成する。

### 1. 良く見られているエピソード

よく見られているエピソードを知りたいです。エピソード視聴数トップ3のエピソードタイトルと視聴数を取得してください

出力:
エピソードタイトル、視聴数

```mysql
SELECT e.name, SUM(b.number_of_view)
     FROM broadcasts AS b
          INNER JOIN episodes AS e
          ON b.episode_id = e.id
    GROUP BY e.name
    ORDER BY SUM(b.number_of_view) DESC
    LIMIT 3;
```

### 2. 番組情報とシーズン情報を合わせて

よく見られているエピソードの番組情報やシーズン情報も合わせて知りたいです。エピソード視聴数トップ3の番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数を取得してください。

出力:
番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数

```mysql
SELECT p.name, pe.season_no, e.episode_no, e.name, SUM(b.number_of_view)
     FROM broadcasts AS b
          INNER JOIN episodes AS e
          ON b.episode_id = e.id
          INNER JOIN program_episodes AS pe
          ON pe.episode_id = e.id
          INNER JOIN programs AS p
          ON p.id = pe.program_id
    GROUP BY e.name, p.name, pe.season_no, e.episode_no
    ORDER BY SUM(b.number_of_view) DESC
    LIMIT 3;
```

### 3. 本日の番組表

本日の番組表を表示するために、本日、どのチャンネルの、何時から、何の番組が放送されるのかを知りたいです。本日放送される全ての番組に対して、チャンネル名、放送開始時刻(日付+時間)、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を取得してください。なお、番組の開始時刻が本日のものを本日方法される番組とみなすものとします

出力:
チャンネル名,  放送開始時刻,  放送終了時刻,  シーズン数,  エピソード数, エピソードタイトル,  エピソード詳細

```mysql
SELECT c.name, b.start_time, b.end_time, pe.season_no, e.episode_no, e.name, e.explanation
     FROM broadcasts AS b
          INNER JOIN episodes AS e
          ON b.episode_id = e.id
          INNER JOIN channels AS c
          ON c.id = b.channel_id
          INNER JOIN program_episodes AS pe
          ON e.id = pe.episode_id
    WHERE CAST(b.start_time AS DATE) = CURDATE();
```

### 4. あるチャンネルの一週間分の番組表

ドラマというチャンネルがあったとして、ドラマのチャンネルの番組表を表示するために、本日から一週間分、何日の何時から何の番組が放送されるのかを知りたいです。ドラマのチャンネルに対して、放送開始時刻、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を本日から一週間分取得してください

出力:
放送開始時刻, 放送終了時刻, シーズン数, エピソード数, エピソードタイトル, エピソード詳細

```mysql
SELECT b.start_time, b.end_time, pe.season_no, e.episode_no, e.name, e.explanation
     FROM broadcasts AS b
          INNER JOIN episodes AS e
          ON b.episode_id = e.id
          INNER JOIN channels AS c
          ON b.channel_id = c.id
          INNER JOIN program_episodes AS pe
          ON e.id = pe.episode_id
    WHERE c.id = 1 AND CAST(b.start_time AS DATE) BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY;
```

### 5. 直近一週間で最も見られた番組

(advanced) 直近一週間で最も見られた番組が知りたいです。直近一週間に放送された番組の中で、エピソード視聴数合計トップ2の番組に対して、番組タイトル、視聴数を取得してください

出力:
番組タイトル, 視聴数

```mysql
SELECT p.name, SUM(b.number_of_view)
     FROM broadcasts AS b
          INNER JOIN episodes AS e
          ON b.episode_id = e.id
          INNER JOIN program_episodes AS pe
          ON pe.episode_id = e.id
          INNER JOIN programs AS p
          ON p.id = pe.program_id
    WHERE CAST(b.start_time AS DATE) BETWEEN CURDATE() - INTERVAL 7 DAY AND CURDATE()
    GROUP BY b.episode_id, p.name
    ORDER BY SUM(b.number_of_view) DESC
    LIMIT 2;
```

### 6. ジャンルごとの視聴数ランキング

(advanced) ジャンルごとの番組の視聴数ランキングを知りたいです。番組の視聴数ランキングはエピソードの平均視聴数ランキングとします。ジャンルごとに視聴数トップの番組に対して、ジャンル名、番組タイトル、エピソード平均視聴数を取得してください。

出力:
ジャンル名, 番組タイトル, エピソード平均視聴数

```mysql
CREATE VIEW max_par_genre (gen, num_view)
AS
SELECT g.genre AS gen, MAX(pnv.num_view) AS num_view
    FROM genres AS g
         INNER JOIN program_number_view AS pnv
         ON g.program_id = pnv.prog_id
    GROUP BY genre;


CREATE VIEW program_number_view (prog_id, num_view)
AS
SELECT p.id AS prog_id, SUM(number_of_view) / COUNT(e.id) AS num_view
    FROM broadcasts AS b
         INNER JOIN episodes AS e
         ON b.episode_id = e.id
         INNER JOIN program_episodes AS pe
         ON e.id = pe.episode_id
         INNER JOIN programs AS p
         ON pe.program_id = p.id
    GROUP BY p.id;

-- 本体
SELECT gen.genre, pro.name, mpg.num_view
     FROM genres AS gen
          INNER JOIN programs AS pro
          ON gen.program_id = pro.id
          INNER JOIN program_number_view AS pnv
          ON pro.id = pnv.prog_id
          INNER JOIN max_par_genre AS mpg
          ON pnv.num_view = mpg.num_view AND gen.genre = mpg.gen
    GROUP BY gen.genre, pro.name, mpg.num_view;
```
