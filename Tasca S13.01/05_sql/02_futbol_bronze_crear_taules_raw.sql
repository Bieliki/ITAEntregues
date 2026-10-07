USE futbol_bronze;

CREATE TABLE IF NOT EXISTS raw_class (
    league VARCHAR(25),
    season CHAR(4),
    Rk INT,
    Squad VARCHAR(50),
    MP INT,
    W INT,
    D INT,
    L INT,
    GF INT,
    GA INT,
    GD INT,
    Pts INT,
    `Pts/MP` DECIMAL(3, 2),
    Attendance INT,
    `Top Team Scorer` VARCHAR(100),
    Goalkeeper VARCHAR(100),
    Notes VARCHAR(250));

CREATE TABLE IF NOT EXISTS raw_standard (
    league VARCHAR(25),
    season CHAR(4),
    team VARCHAR(50),
    players_used INT,
    Age DECIMAL(3, 1),
    Poss DECIMAL(3, 1),
    MP INT,
    Starts INT,
    Min INT,
    `90s` DECIMAL(3, 1),
    Gls INT,
    Ast INT,
    `G+A` INT,
    `G-PK` INT,
    PK INT,
    PKatt INT,
    CrdY INT,
    CrdR INT,
    P90_Gls DECIMAL(3, 2),
    P90_Ast DECIMAL(3, 2),
    `P90_G+A` DECIMAL(3, 2),
    `P90_G-PK` DECIMAL(3, 2),
    `P90_G+A-PK` DECIMAL(3, 2),
    url VARCHAR(255));

CREATE TABLE IF NOT EXISTS raw_keeper (
    league VARCHAR(25),
    season CHAR(4),
    team VARCHAR(50),
    players_used INT,
    MP INT,
    Starts INT,
    Min INT,
    `90s` DECIMAL(3, 1),
    GA INT,
    GA90 DECIMAL(3, 2),
    SoTA INT,
    Saves INT,
    `Save%` DECIMAL(3, 1),
    W INT,
    D INT,
    L INT,
    CS INT,
    `CS%` DECIMAL(3, 1),
    PKatt INT,
    PKA INT,
    PKsv INT,
    PKm INT,
    `PK_Save%` DECIMAL(4, 1),
    url VARCHAR(255));

CREATE TABLE IF NOT EXISTS raw_shooting (
    league VARCHAR(25),
    season CHAR(4),
    team VARCHAR(50),
    players_used INT,
    `90s` DECIMAL(3, 1),
    Gls INT,
    Sh INT,
    SoT INT,
    `SoT%` DECIMAL(3, 1),
    `Sh/90` DECIMAL(4, 2),
    `SoT/90` DECIMAL(3, 2),
    `G/Sh` DECIMAL(3, 2),
    `G/SoT` DECIMAL(3, 2),
    PK INT,
    PKatt INT,
    url VARCHAR(255));

CREATE TABLE IF NOT EXISTS raw_misc (
    league VARCHAR(25),
    season CHAR(4),
    team VARCHAR(50),
    players_used INT,
    `90s` DECIMAL(3, 1),
    CrdY INT,
    CrdR INT,
    `2CrdY` INT,
    Fls INT,
    Fld INT,
    `Off` INT,
    Crs INT,
    `Int` INT,
    TklW INT,
    PKwon INT,
    PKcon INT,
    OG INT,
    url VARCHAR(255));

CREATE TABLE IF NOT EXISTS raw_penals (
    league VARCHAR(25),
    season CHAR(4),
    team VARCHAR(50),
    team_understat VARCHAR(50),
    penals_favor_understat INT,
    penals_contra_understat INT,
    penals_encaixats_understat INT);

CREATE TABLE IF NOT EXISTS raw_xuts (
    league VARCHAR(25),
    season CHAR(4),
    team VARCHAR(50),
    team_understat VARCHAR(50),
    xuts_totals_understat INT,
    xuts_rebuts_understat INT);

CREATE TABLE IF NOT EXISTS raw_targetes (
    league VARCHAR(25),
    season CHAR(4),
    team VARCHAR(50),
    team_understat VARCHAR(50),
    targetes_grogues_understat INT,
    targetes_vermelles_understat INT);

CREATE TABLE IF NOT EXISTS raw_faltes (
    league VARCHAR(25),
    season CHAR(4),
    team_footballdata VARCHAR(50),
    faltes_comeses_footballdata INT,
    faltes_rebudes_footballdata INT,
    team VARCHAR(50));

CREATE TABLE IF NOT EXISTS raw_finals (
    competicio VARCHAR(30),
    temporada CHAR(4),
    equip_local VARCHAR(50),
    equip_visitant VARCHAR(50),
    gols_local INT,
    gols_visitant INT,
    guanyador VARCHAR(50),
    possessio_local DECIMAL(3,1),
    possessio_visitant DECIMAL(3,1));
