DROP DATABASE IF EXISTS internet_tv;
CREATE DATABASE IF NOT EXISTS internet_tv;
USE internet_tv;

CREATE TABLE
    channels (
        PRIMARY KEY (id),
        id           INTEGER      NOT NULL AUTO_INCREMENT,
        name         VARCHAR(255) NOT NULL,
        explanation  VARCHAR(255) NOT NULL,
        created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_name (name)
    );

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

CREATE TABLE
    program_episodes (
        PRIMARY KEY (id),
        id         BIGINT   NOT NULL AUTO_INCREMENT,
        program_id BIGINT   NOT NULL,
        episode_id BIGINT   NOT NULL,
        season_no  INTEGER           DEFAULT -1,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY fk_program_id (program_id) REFERENCES programs(id),
        FOREIGN KEY fk_episode_id (episode_id) REFERENCES episodes(id),
        UNIQUE KEY (episode_id)
    );

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

SELECT 'LOADING channels' as 'INFO';
source load_channels.sql;
SELECT 'LOADING programs' as 'INFO';
source load_programs.sql;
SELECT 'LOADING episodes' as 'INFO';
source load_episodes.sql;
SELECT 'LOADING program_episodes' as 'INFO';
source load_program_episodes.sql;
SELECT 'LOADING broadcasts' as 'INFO';
source load_broadcasts.sql;
SELECT 'LOADING genres' as 'INFO';
source load_genres.sql;
