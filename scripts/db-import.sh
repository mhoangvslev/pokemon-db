#!/bin/bash

PGUSERNAME="postgres"
DBNAME="vgsales-db"
HOSTNAME="localhost"
PORT="5432"
export PGPASSWORD="postgres"

echo "\n ====== (Re)creating tables..."
psql --username="$PGUSERNAME" --host="$HOSTNAME" --dbname="$DBNAME" --file="$(realpath ./sql/create.sql)"

echo "
-- Import
COPY PublisherDecoy (ID_PUBLISHER, PUBLISHER, HEADQUARTERS_COUNTRY, HEADQUARTERS_CITY, CREATION_DATE, NOTES)
FROM '$(realpath ./dataset/clean/publisher.csv)' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

COPY DeveloperDecoy (ID_DEVELOPPER, DEVELOPPER, ACTIVE, HEADQUARTERS_CITY, HEADQUARTERS_COUNTRY, CREATION_DATE, NOTES)
FROM '$(realpath ./dataset/clean/developer.csv)' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

COPY PlatformDecoy (PLATFORM, DEVELOPPER, MANUFACTURER, GAMES_COUNT, EU_RELEASE, USA_RELEASE, JP_RELEASE, GENERATION)
FROM '$(realpath ./dataset/clean/plateform.csv)' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

COPY SalesDecoy (ID_GAME, GAME, ID_PLATFORM, YEAR_RELEASE, GENRE, ID_PUBLISHER, PUBLISHER, NA_SALES, EU_SALES, JP_SALES, OTHER_SALES, GLOBAL_SALES, CRITIC_SCORE, CRITIC_COUNT, USER_SCORE, USER_COUNT, ID_DEVELOPPER, DEVELOPPER, RATING)
FROM '$(realpath ./dataset/clean/vgsales.csv)' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

DROP TABLE IF EXISTS SalesDecoy;
DROP TABLE IF EXISTS DeveloperDecoy;
DROP TABLE IF EXISTS PublisherDecoy;
DROP TABLE IF EXISTS PlatformDecoy;

DROP FUNCTION IF EXISTS proc_publisher_clean;
DROP FUNCTION IF EXISTS proc_developer_clean;
DROP FUNCTION IF EXISTS proc_platform_clean;
DROP FUNCTION IF EXISTS proc_sales_clean;

" > ./sql/import.sql

echo "\n ==== Create tables and decoy tables"
psql --username="$PGUSERNAME" --host="$HOSTNAME" --dbname="$DBNAME" --file="$(realpath ./sql/create.sql)"

echo "\n ==== Add triggers for decoy tables"
psql --username="$PGUSERNAME" --host="$HOSTNAME" --dbname="$DBNAME" --file="$(realpath ./sql/triggers.sql)"

echo "\n ==== Import and delete decoys"
psql --username="$PGUSERNAME" --host="$HOSTNAME" --dbname="$DBNAME" --file="$(realpath ./sql/import.sql)"
