-- DBMS: PostgreSQL
-- IMPORT CSVs


-- CREATE TABLE Fait

-- CREATE TABLE Pokemon
CREATE TABLE pokemon (
    pokemon_id int primary key not null,
    nom varchar(255) not null,
    legendaire int not null,
    generation int not null,
    poids int not null,
    taille int not null,
    type_1 varchar(255) not null,
    type_2 varchar(255) not null,
    hp int not null,
    atk int not null,
    def int not null,
    vit int not null,
    sp_def int not null,
    sp_atk int not null,
    pourcentage_male int not null,
    xp_max int not null,
    classification varchar(255) not null,
    taux_capture int not null,
    base_bonheur int not null,
    base_pas_oeuf int not null
)


-- Appeller un autre fichier SQL qui fait tout le traitement, cad, select, clean, inserer dans Pokemon 

-- CREATE TABLE Localisation

-- CREATE TABLE Date

-- DELETE les CSVs