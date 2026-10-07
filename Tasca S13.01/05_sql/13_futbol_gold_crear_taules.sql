USE futbol_gold;

CREATE TABLE IF NOT EXISTS dim_equip (
    id_equip INT AUTO_INCREMENT,
    equip VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_equip));

CREATE TABLE IF NOT EXISTS dim_lliga (
    id_lliga INT AUTO_INCREMENT,
    lliga VARCHAR(25) NOT NULL,
    PRIMARY KEY (id_lliga));

CREATE TABLE IF NOT EXISTS dim_temporada (
    id_temporada INT AUTO_INCREMENT,
    temporada CHAR(4) NOT NULL,
    PRIMARY KEY (id_temporada));

CREATE TABLE IF NOT EXISTS dim_tram_possessio (
    id_tram INT AUTO_INCREMENT,
    tram VARCHAR(20),
    valor_min DECIMAL(4,1),
    valor_max DECIMAL(4,1),
    PRIMARY KEY (id_tram));

CREATE TABLE IF NOT EXISTS fact_finals_uefa (
    id_final INT AUTO_INCREMENT,
    id_tram INT,
    competicio VARCHAR(30),
    temporada CHAR(4),
    equip_local VARCHAR(50),
    equip_visitant VARCHAR(50),
    gols_local INT,
    gols_visitant INT,
    guanyador VARCHAR(50),
    possessio_local DECIMAL(4,1),
    possessio_visitant DECIMAL (4,1),
    possessio_guanyador DECIMAL(4,1),
    PRIMARY KEY (id_final));

CREATE TABLE IF NOT EXISTS fact_equip_temporada (
    id_fact INT AUTO_INCREMENT,
    id_equip INT,
    id_lliga INT,
    id_temporada INT,
    id_tram INT,
    targetes_grogues INT,
    targetes_vermelles INT,
    faltes_comeses INT,
    faltes_rebudes INT,
    penals_favor INT,
    penals_contra INT,
    xuts_realitzats INT,
    xuts_rebuts INT,
    gols_realitzats INT,
    gols_rebuts INT,
    possessio DECIMAL(4,1),
    classificacio INT,
    victories INT,
    empats INT,
    derrotes INT,
    punts INT,
    espectadors INT,
    PRIMARY KEY (id_fact),
    FOREIGN KEY (id_equip) REFERENCES dim_equip(id_equip),
    FOREIGN KEY (id_lliga) REFERENCES dim_lliga(id_lliga),
    FOREIGN KEY (id_temporada) REFERENCES dim_temporada(id_temporada),
    FOREIGN KEY (id_tram) REFERENCES dim_tram_possessio(id_tram));

