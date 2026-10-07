USE futbol_silver;

CREATE TABLE futbol_silver.clean_class LIKE futbol_bronze.raw_class;
CREATE TABLE futbol_silver.clean_keeper LIKE futbol_bronze.raw_keeper;
CREATE TABLE futbol_silver.clean_misc LIKE futbol_bronze.raw_misc;
CREATE TABLE futbol_silver.clean_penals LIKE futbol_bronze.raw_penals;
CREATE TABLE futbol_silver.clean_shooting LIKE futbol_bronze.raw_shooting;
CREATE TABLE futbol_silver.clean_standard LIKE futbol_bronze.raw_standard;
CREATE TABLE futbol_silver.clean_xuts LIKE futbol_bronze.raw_xuts;
CREATE TABLE futbol_silver.clean_targetes LIKE futbol_bronze.raw_targetes;
CREATE TABLE futbol_silver.clean_faltes LIKE futbol_bronze.raw_faltes;
CREATE TABLE futbol_silver.clean_finals LIKE futbol_bronze.raw_finals;

