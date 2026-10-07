USE futbol_bronze;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

TRUNCATE TABLE futbol_bronze.raw_misc;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/team_season_misc_final.csv'
INTO TABLE futbol_bronze.raw_misc
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(league,season,team,players_used,`90s`,CrdY,@CrdR,@2CrdY,Fls,@Fld,@Off,@Crs,@Int,@TklW,@PKwon,@PKcon,@OG,url)
SET CrdR = NULLIF(@CrdR, ''), `2CrdY` = NULLIF(@2CrdY, ''), Fld = NULLIF(@Fld, ''), `Off` = NULLIF(@Off, ''),Crs = NULLIF(@Crs, ''), `Int`= NULLIF(@Int, ''),TklW = NULLIF(@TklW, ''),PKwon = NULLIF(@PKwon, ''), PKcon = NULLIF(@PKcon, ''), OG = NULLIF(@OG, '');

TRUNCATE TABLE futbol_bronze.raw_shooting;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/team_season_shooting_final.csv'
INTO TABLE futbol_bronze.raw_shooting
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(league,season,team,players_used,`90s`,Gls,@Sh,SoT,@SoT_,@Sh_90,`SoT/90`,@G_Sh,`G/SoT`,PK,PKatt,url)
SET Sh = NULLIF(@Sh, ''), `SoT%` = NULLIF(@SoT_, ''), `Sh/90` = NULLIF(@Sh_90, ''), `G/Sh` = NULLIF(@G_Sh, '');

TRUNCATE TABLE futbol_bronze.raw_standard;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/team_season_standard_final.csv'
INTO TABLE futbol_bronze.raw_standard
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(league,season,team,players_used,Age,Poss,MP,`Starts`,Min,`90s`,Gls,Ast,`G+A`,`G-PK`,PK,PKatt,CrdY,@CrdR,P90_Gls,P90_Ast,`P90_G+A`,`P90_G-PK`,`P90_G+A-PK`,url)
SET CrdR = NULLIF(@CrdR, '');

TRUNCATE TABLE futbol_bronze.raw_keeper;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/team_season_keeper_final.csv'
INTO TABLE futbol_bronze.raw_keeper
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(league,season,team,players_used,MP,`Starts`,Min,`90s`,GA,GA90,SoTA,Saves,`Save%`,W,D,L,CS,`CS%`,@PKatt,@PKA,@PKsv,@PKm,@PK_Save_,url)
SET PKatt = NULLIF(@PKatt, ''), PKA = NULLIF(@PKA, ''), PKsv = NULLIF(@PKsv, ''), PKm = NULLIF(@PKm, ''), `PK_Save%` = NULLIF(@PK_Save_, '');

TRUNCATE TABLE futbol_bronze.raw_class;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/big_5_final.csv'
INTO TABLE futbol_bronze.raw_class
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(league,season,Rk,Squad,MP,W,D,L,GF,GA,GD,Pts,`Pts/MP`,@Attendance,`Top Team Scorer`,Goalkeeper,Notes)
SET Attendance = NULLIF(@Attendance, '');

TRUNCATE futbol_bronze.raw_penals;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/penals_understat_forats.csv'
INTO TABLE futbol_bronze.raw_penals
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

TRUNCATE futbol_bronze.raw_xuts;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/xuts_understat_complet.csv'
INTO TABLE futbol_bronze.raw_xuts
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

TRUNCATE futbol_bronze.raw_targetes;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/targetes_understat_complet.csv'
INTO TABLE futbol_bronze.raw_targetes
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

TRUNCATE futbol_bronze.raw_faltes;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/faltes_footballdata_complet.csv'
INTO TABLE futbol_bronze.raw_faltes
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

TRUNCATE futbol_bronze.raw_finals;

LOAD DATA LOCAL INFILE 'EL_TEU_PATH/finals_UEFA.csv'
INTO TABLE futbol_bronze.raw_finals
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
