-- DBMS: PostgreSQL

-- CREATE TABLE Publisher
DROP TABLE IF EXISTS Publisher CASCADE;
CREATE TABLE Publisher (
    publisher_id VARCHAR,
    publisher_name VARCHAR,
    founded DATE,
    city VARCHAR,
    country VARCHAR,
    active BOOLEAN
);
ALTER TABLE Publisher ADD CONSTRAINT pk_publisher PRIMARY KEY (publisher_id);

-- Platform
DROP TABLE IF EXISTS Platform CASCADE; 
CREATE TABLE Platform (
    platform_id VARCHAR,
    platform_name VARCHAR,
    initial VARCHAR,
    manufacturer VARCHAR,
    games_count INTEGER,
    EU_release DATE,
    NA_release DATE,
    JP_release DATE,
    generation INTEGER
);
ALTER TABLE Platform ADD CONSTRAINT pk_platform PRIMARY KEY (platform_id);

-- Game
DROP TABLE IF EXISTS Game CASCADE;
CREATE TABLE Game (
    game_id VARCHAR,
    title VARCHAR,
    release_year DATE,
    genre VARCHAR
);

ALTER TABLE Game ADD CONSTRAINT pk_game PRIMARY KEY (game_id);

-- Developer
DROP TABLE IF EXISTS Developer CASCADE;
CREATE TABLE Developer (
    developer_id VARCHAR,
    developer_name VARCHAR,
    founded DATE,
    city VARCHAR,
    country VARCHAR,
    active BOOLEAN
);

ALTER TABLE Developer ADD CONSTRAINT pk_developer PRIMARY KEY (developer_id);

-- CREATE TABLE Fait
DROP TABLE IF EXISTS Fact CASCADE;
CREATE TABLE Fact (
    game_id VARCHAR,
    publisher_id VARCHAR,
    developer_id VARCHAR,
    platform_id VARCHAR,
    na_sales INTEGER,
    jp_sales INTEGER,
    eu_sales INTEGER,
    other_sales INTEGER,
    global_sales INTEGER,
    critic_score INTEGER,
    critic_count INTEGER,
    rating VARCHAR
);

ALTER TABLE Fact ADD CONSTRAINT pk_fact PRIMARY KEY (game_id, publisher_id, developer_id, platform_id);
ALTER TABLE Fact ADD CONSTRAINT fk_fact_game FOREIGN KEY (game_id) REFERENCES Game (game_id);
ALTER TABLE Fact ADD CONSTRAINT fk_fact_publisher FOREIGN KEY (publisher_id) REFERENCES Publisher (publisher_id);
ALTER TABLE Fact ADD CONSTRAINT fk_fact_platform FOREIGN KEY (platform_id) REFERENCES Platform (platform_id);
ALTER TABLE Fact ADD CONSTRAINT fk_fact_developer FOREIGN KEY (developer_id) REFERENCES Developer (developer_id);

-------------------
-- Decoy Tables
-------------------

-- Publisher
DROP TABLE IF EXISTS PublisherDecoy;
CREATE TABLE PublisherDecoy(
    ID_PUBLISHER VARCHAR,
    PUBLISHER VARCHAR,
    HEADQUARTERS_COUNTRY VARCHAR,
    HEADQUARTERS_CITY VARCHAR,
    CREATION_DATE VARCHAR,
    NOTES VARCHAR
);

-- Developer
DROP TABLE IF EXISTS DeveloperDecoy;
CREATE TABLE DeveloperDecoy(
    ID_DEVELOPPER VARCHAR,
    DEVELOPPER VARCHAR,
    ACTIVE VARCHAR,
    HEADQUARTERS_CITY VARCHAR,
    HEADQUARTERS_COUNTRY VARCHAR, 
    CREATION_DATE VARCHAR,
    NOTES VARCHAR
);

-- Platform
DROP TABLE IF EXISTS PlatformDecoy;
CREATE TABLE PlatformDecoy(
    PLATFORM VARCHAR,
    DEVELOPPER VARCHAR,
    MANUFACTURER VARCHAR,
    GAMES_COUNT VARCHAR,
    EU_RELEASE VARCHAR,
    USA_RELEASE VARCHAR,
    JP_RELEASE VARCHAR,
    GENERATION VARCHAR
);

-- VGSALES
DROP TABLE IF EXISTS SalesDecoy;
CREATE TABLE SalesDecoy(
    ID_GAME VARCHAR,
    GAME VARCHAR,
    ID_PLATFORM VARCHAR,
    YEAR_RELEASE VARCHAR,
    GENRE VARCHAR,
    ID_PUBLISHER VARCHAR,
    PUBLISHER VARCHAR,
    NA_SALES VARCHAR,
    EU_SALES VARCHAR,
    JP_SALES VARCHAR,
    OTHER_SALES VARCHAR,
    GLOBAL_SALES VARCHAR,
    CRITIC_SCORE VARCHAR,
    CRITIC_COUNT VARCHAR,
    ID_DEVELOPPER VARCHAR,
    DEVELOPPER VARCHAR,
    RATING VARCHAR
);


-- Appeller un autre fichier SQL qui fait tout le traitement, cad, select, clean, inserer dans Pokemon 

-- CREATE TABLE Localisation

-- CREATE TABLE Date

-- DELETE les CSVs