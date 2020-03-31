
-- Import
COPY PublisherDecoy (ID_PUBLISHER, PUBLISHER, HEADQUARTERS_COUNTRY, HEADQUARTERS_CITY, CREATION_DATE, NOTES)
FROM '/home/minhhoangdang/Documents/ResearchProjects/vgsales-db/dataset/clean/publisher.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

COPY DeveloperDecoy (ID_DEVELOPPER, DEVELOPPER, ACTIVE, HEADQUARTERS_CITY, HEADQUARTERS_COUNTRY, CREATION_DATE, NOTES)
FROM '/home/minhhoangdang/Documents/ResearchProjects/vgsales-db/dataset/clean/developper.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

COPY PlatformDecoy (PLATFORM, DEVELOPPER, MANUFACTURER, GAMES_COUNT, EU_RELEASE, USA_RELEASE, JP_RELEASE, GENERATION)
FROM '/home/minhhoangdang/Documents/ResearchProjects/vgsales-db/dataset/clean/plateform.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

COPY SalesDecoy (ID_GAME, GAME, ID_PLATFORM, YEAR_RELEASE, GENRE, ID_PUBLISHER, PUBLISHER, NA_SALES, EU_SALES, JP_SALES, OTHER_SALES, GLOBAL_SALES, CRITIC_SCORE, CRITIC_COUNT, ID_DEVELOPPER, DEVELOPPER, RATING)
FROM '/home/minhhoangdang/Documents/ResearchProjects/vgsales-db/dataset/clean/vgsales.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF-8';

DROP TABLE IF EXISTS SalesDecoy;
DROP TABLE IF EXISTS DeveloperDecoy;
DROP TABLE IF EXISTS PublisherDecoy;
DROP TABLE IF EXISTS PlatformDecoy;


