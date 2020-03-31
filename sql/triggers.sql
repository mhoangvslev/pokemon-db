CREATE EXTENSION IF NOT EXISTS pg_trgm;

-----------------
-- PUBLISHERDECOY
-----------------
CREATE OR REPLACE FUNCTION proc_publisher_clean() 
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO Publisher (publisher_id, publisher_name, founded, city, country) 
        VALUES (NEW.ID_PUBLISHER, NEW.PUBLISHER, to_date(NEW.CREATION_DATE, 'DD/MM/YYYY'), NEW.HEADQUARTERS_CITY, NEW.HEADQUARTERS_COUNTRY)
        ON CONFLICT DO NOTHING;
        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS trgr_publisher_insert ON PublisherDecoy;
CREATE TRIGGER trgr_publisher_insert BEFORE INSERT
    ON PublisherDecoy
    FOR EACH ROW
        EXECUTE PROCEDURE proc_publisher_clean();

-----------------
-- DeveloperDecoy
-----------------
CREATE OR REPLACE FUNCTION proc_developer_clean() 
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO Developer (developer_id, developer_name, founded, city, country, active) 
        VALUES (NEW.ID_DEVELOPPER, NEW.DEVELOPPER, to_date(NEW.CREATION_DATE, 'DD/MM/YYYY'), NEW.HEADQUARTERS_CITY, NEW.HEADQUARTERS_COUNTRY, cast(NEW.ACTIVE as boolean))
        ON CONFLICT DO NOTHING;
        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS trgr_developer_insert ON DeveloperDecoy;
CREATE TRIGGER trgr_developer_insert BEFORE INSERT
    ON DeveloperDecoy
    FOR EACH ROW
        EXECUTE PROCEDURE proc_developer_clean();

-----------------
-- PlatformDecoy
-----------------
CREATE OR REPLACE FUNCTION proc_platform_clean() 
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO Platform (platform_id, platform_name, manufacturer, games_count, EU_release, NA_release, JP_release, generation)
        VALUES (NEW.PLATFORM, NEW.DEVELOPPER, NEW.MANUFACTURER, cast(NEW.GAMES_COUNT as INTEGER), 
            to_date(NEW.EU_RELEASE, 'DD/MM/YYYY'), to_date(NEW.USA_RELEASE, 'DD/MM/YYYY'), to_date(NEW.JP_RELEASE, 'DD/MM/YYYY'), 
            cast(NEW.GENERATION as INTEGER)
        )
        ON CONFLICT DO NOTHING;
        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS trgr_platform_insert ON PlatformDecoy;
CREATE TRIGGER trgr_platform_insert BEFORE INSERT
    ON PlatformDecoy
    FOR EACH ROW
        EXECUTE PROCEDURE proc_platform_clean();

-----------------
-- SalesDecoy
-----------------
CREATE OR REPLACE FUNCTION are_similar(TEXT, TEXT) 
RETURNS BOOLEAN AS $$
    BEGIN
        RETURN word_similarity($1, $2) >= 0.8 OR word_similarity($2, $1) >= 0.8;
    END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION proc_sales_clean() 
RETURNS TRIGGER AS $$
    DECLARE
        v_publisherId VARCHAR;
        v_developerId VARCHAR;
    BEGIN
        -- Insert into Game
        IF (NEW.ID_GAME IS NOT NULL) THEN 
            INSERT INTO Game (game_id, title, release_year, genre)
            VALUES (NEW.ID_GAME, NEW.GAME, to_date(NEW.YEAR_RELEASE, 'DD/MM/YYYY'), NEW.GENRE)
            ON CONFLICT DO NOTHING;

            SELECT INTO v_publisherId p.publisher_id FROM Publisher p WHERE are_similar(p.publisher_id, NEW.ID_PUBLISHER);
            SELECT INTO v_developerId d.developer_id FROM Developer d WHERE are_similar(d.developer_id, NEW.ID_DEVELOPPER);

            IF (
                NEW.ID_GAME IS NOT NULL AND 
                NEW.ID_PUBLISHER IS NOT NULL AND
                NEW.ID_DEVELOPPER IS NOT NULL AND 
                NEW.ID_PLATFORM IS NOT NULL AND
                v_publisherId IS NOT NULL AND
                v_developerId IS NOT NULL
            ) THEN
                -- Insert into Fact
                INSERT INTO Fact (
                    game_id, publisher_id, developer_id, platform_id, 
                    na_sales, jp_sales, eu_sales, other_sales, global_sales,
                    critic_score, critic_count, user_score, user_count,
                    rating 
                ) VALUES (
                    NEW.ID_GAME, v_publisherId, v_developerId, NEW.ID_PLATFORM, 
                    cast(NEW.NA_SALES as Integer), cast(NEW.JP_SALES as Integer), cast(NEW.EU_SALES as Integer), cast(NEW.OTHER_SALES as Integer), cast(NEW.GLOBAL_SALES as Integer),
                    cast(NEW.CRITIC_SCORE as NUMERIC), cast(NEW.CRITIC_COUNT as integer), 
                    cast(NEW.USER_SCORE as NUMERIC), cast(NEW.USER_COUNT as integer), 
                    NEW.RATING
                )
                ON CONFLICT DO NOTHING;
            END IF;
        END IF;        
        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS trgr_sales_insert ON SalesDecoy;
CREATE TRIGGER trgr_sales_insert BEFORE INSERT
    ON SalesDecoy
    FOR EACH ROW
        EXECUTE PROCEDURE proc_sales_clean();
