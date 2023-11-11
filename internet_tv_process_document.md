# インターネットTVデータベース作成手順書

## 1. 改訂履歴

- 1.3:
  - 作成日時: 2023-11-11
  - 更新内容: seasons テーブルの削除

## 2. 目次

- [1. 改訂履歴](#1-改訂履歴)
- [2. 目次](#2-目次)
- [3. 目的・概要](#3-目的概要)
- [4. 要件](#4-要件)
- [5. 前提条件](#5-前提条件)
- [6. 作業完了条件](#6-作業完了条件)
- [7. 手順書](#7-手順書)
- [8. テスト (step 3)](#8-テスト-step-3)

## 3. 目的・概要

アプレンティスシップ DEV CAMP データベース・SQL の課題インターネットTVを作成するための手順書。
MySQLを使用し、インターネットTVのデータベース構築を行う。

## 4. 要件

- ドラマ1、ドラマ2、アニメ1、アニメ2、スポーツ、ペットなど、複数のチャンネルがある
- 各チャンネルの下では時間帯ごとに番組枠が1つ設定されており、番組が放映される
- 番組はシリーズになっているものと単発ものがある。シリーズになっているものはシーズンが1つものと、シーズン1、シーズン2のように複数シーズンのものがある。各シーズンの下では各エピソードが設定されている
- 再放送もあるため、ある番組が複数チャンネルの異なる番組枠で放映されることはある
- 番組の情報として、タイトル、番組詳細、ジャンルが画面上に表示される
- 各エピソードの情報として、シーズン数、エピソード数、タイトル、エピソード詳細、動画時間、公開日、視聴数が画面上に表示される。単発のエピソードの場合はシーズン数、エピソード数は表示されない
- ジャンルとしてアニメ、映画、ドラマ、ニュースなどがある。各番組は1つ以上のジャンルに属する
- KPIとして、チャンネルの番組枠のエピソードごとに視聴数を記録する。なお、一つのエピソードは複数の異なるチャンネル及び番組枠で放送されることがあるので、属するチャンネルの番組枠ごとに視聴数がどうだったかも追えるようにする

## 5. 前提条件

- MySQLを使用する

## 6. 作業完了条件

### 6.1 MySQLのクエリを使って作成する方法

### 6.1.1 データベースの作成

- internet_tv データベースが作成されていること

### 6.1.2 データベース内のテーブル作成

以下の各テーブルが internet_tv データベース内に作成されていること

1. channels
2. programs
3. episodes
4. program_episodes
5. broadcasts
6. genre

### 6.1.3 サンプルデータの挿入

上記各テーブルにランダムなサンプルデータが挿入されていること

## 7. 手順書

### 7.1 リポジトリのダウンロード

ターミナルを開き適切なディレクトリへ移動する。  
その後下記コマンドを実行する。

```bash
git clone https://github.com/pandaFive/sql-practice-internet-tv.git
```

### 7.2 internet_tv.sql ファイルからデータベースを作成する方法

ダウンロードしたディレクトリに移動し、下記コマンドを実行する。

```bash
sudo mysql < internet_tv.sql
```

### 7.3 MySQLクエリを用いる方法

#### 7.3.1 データベースの作成

#### 7.3.1.1 MySQLへのログイン

ターミナルを開き下記コマンドを実行

```bach
mysql -u username -p
```

*username は MySQL に登録されているユーザー名に適宜変換*
パスワードの入力が求められるので入力したユーザーのパスワードを入力

ターミナルに下記が表示されたら成功

```bash
mysql>
```

#### 7.3.1.2 データベースの作成

internet_tv データベースを作成する前に,
下記コマンドで internet_tv データベースが存在しないことを確認する.

```mysql
SHOW DATABASES;
```

もし、既に同名のデータベースが存在している場合は、これから作成するデータベースの名前を internet_tv2等に変更する。  
もしくは、既に存在しているデータベースを消去してもよい場合は下記コマンドで消去する

```mysql
DROP DATABASE internet_tv;
```

internet_tv データベースを作成します。
下記コマンドを実行する

```mysql
CREATE DATABASE internet_tv;
```

上記コマンドを実行後、internet_tv データベースが作成されていることを確認する。

```mysql
SHOW DATABASES;
```

#### 7.3.2 テーブルの作成

下記コマンドを実行し internet_tv データベースへアクセスする

```mysql
USE internet_tv;
```

#### 7.3.2.1 channels テーブルの作成

下記コマンドを実行実行する

```mysql
CREATE TABLE
    channels (
        PRIMARY KEY (id),
        id           INTEGER      NOT NULL AUTO_INCREMENT,
        name         VARCHAR(255) NOT NULL,
        explanation  VARCHAR(255) NOT NULL,
        created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );
```

下記コマンドで結果を確認する

```mysql
SHOW COLUMNS FROM channels;
```

#### 7.3.2.2 programs テーブルの作成

下記コマンドを実行する

```mysql
CREATE TABLE
    programs (
        PRIMARY KEY (id),
        id          BIGINT       NOT NULL AUTO_INCREMENT,
        name        VARCHAR(255) NOT NULL,
        explanation VARCHAR(255) NOT NULL,
        created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_program_name (name)
    );
```

下記コマンドで結果を確認する

```mysql
SHOW COLUMNS FROM programs;
```

#### 7.3.2.3 episodes テーブルの作成

下記コマンドを実行する

```mysql
CREATE TABLE
    episodes (
        PRIMARY KEY (id),
        id             BIGINT       NOT NULL AUTO_INCREMENT,
        name           VARCHAR(255) NOT NULL,
        explanation    VARCHAR(255) NOT NULL,
        episode_no     BIGINT       NOT NULL,
        release_date   DATE         NOT NULL,
        video_sec_time BIGINT       NOT NULL,
        created_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_episode_no (episode_no)
    );
```

下記コマンドで結果を確認する

```mysql
SHOW COLUMNS FROM episodes;
```

#### 7.3.2.4 program_episodes テーブルの作成

下記コマンドを実行する

```mysql
CREATE TABLE
    program_episodes (
        PRIMARY KEY (id),
                id BIGINT   NOT NULL AUTO_INCREMENT,
        program_id BIGINT   NOT NULL,
        episode_id BIGINT   NOT NULL,
        season_no  INTEGER           DEFAULT -1,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY fk_program_id (program_id) REFERENCES programs(id),
        FOREIGN KEY fk_episode_id (episode_id) REFERENCES episodes(id),
        UNIQUE KEY (episode_id)
    );
```

下記コマンドで結果を確認する

```mysql
SHOW COLUMNS FROM program_episodes;
```

#### 7.3.2.5 broadcasts テーブルの作成

下記コマンドを実行する

```mysql
CREATE TABLE
    broadcasts (
        PRIMARY KEY (id),
        id             BIGINT   NOT NULL AUTO_INCREMENT,
        channel_id     INTEGER  NOT NULL,
        episode_id     BIGINT   NOT NULL,
        start_time     DATETIME NOT NULL,
        end_time       DATETIME NOT NULL,
        number_of_view BIGINT   NOT NULL DEFAULT 0,
        created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY fk_channel_id (channel_id) REFERENCES channels (id),
        FOREIGN KEY fk_episode_id (episode_id) REFERENCES episodes (id),
        INDEX idx_start_time (start_time),
        INDEX idx_number_of_view (number_of_view)
    );
```

下記コマンドで結果を確認する

```mysql
SHOW COLUMNS FROM broadcasts;
```

#### 7.3.2.6 genres テーブルの作成

下記コマンドを実行する

```mysql
CREATE TABLE
    genres (
        PRIMARY KEY (id),
        id         BIGINT      NOT NULL AUTO_INCREMENT,
        program_id BIGINT      NOT NULL,
        genre      VARCHAR(32) NOT NULL,
        created_at DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY fk_program_id (program_id) REFERENCES programs (id),
        INDEX idx_genre (genre)
    );
```

下記コマンドで結果を確認する

```mysql
SHOW COLUMNS FROM genres;
```

#### 7.3.3 サンプルデータの入力

#### 7.3.4.1 channels サンプルデータの入力

load_channels.sql を読み込む

```mysql
mysql> source /path/load_channels.sql
```

*/path/ の部分は load_channels.sql の path に置き換える*

#### 7.3.4.2 programs サンプルデータの入力

load_programs.sql を実行する

```mysql
mysql> source /path/load_programs.sql
```

*/path/ の部分は load_programs.sql の path に置き換える*

#### 7.3.4.3 program_episode.sql サンプルデータの入力

load_program_episodes.sql を実行する

```mysql
mysql> source /path/load_program_episodes.sql
```

*/path/ の部分は load_program_episodes.sql の path に置き換える*

#### 7.3.4.4 episodes サンプルデータの入力

load_episodes.sql を実行する

```mysql
mysql> source /path/load_episodes.sql
```

*/path/ の部分は load_episodes.sql の path に置き換える*

#### 7.3.4.5 broadcasts サンプルデータの入力

load_broadcasts を実行する

```mysql
mysql> source /path/load_broadcasts.sql
```

*/path/ の部分は load_broadcasts.sql の path に置き換える*

#### 7.3.4.6 genres サンプルデータの入力

load_genres.sql を実行する

```mysql
mysql> source /path/load_genres.sql
```

*/path/ の部分は load_genres.sql の path に置き換える*

## 8. テスト (step 3)

### 8.1. 良く見られているエピソード

```mysql
SELECT e.name, SUM(b.number_of_view)
     FROM broadcasts AS b
          INNER JOIN episodes AS e
          ON b.episode_id = e.id
    GROUP BY e.name
    ORDER BY SUM(b.number_of_view) DESC
    LIMIT 3;
```

### 8.2. 番組情報とシーズン情報を合わせて

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

### 8.3. 本日の番組表

本日放送されるすべての番組の,  
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

### 8.4. あるチャンネルの一週間分の番組表

本日から一週間分の特定のチャンネル  
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

### 8.5. 直近一週間で最も見られた番組

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

### 8.6. ジャンルごとの視聴数ランキング

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
