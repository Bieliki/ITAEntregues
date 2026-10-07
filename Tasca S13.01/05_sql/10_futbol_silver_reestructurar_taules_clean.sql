USE futbol_silver;

INSERT INTO clean_penals (lliga,temporada,equip)
SELECT clean_standard.lliga, clean_standard.temporada, clean_standard.equip
FROM clean_standard
LEFT JOIN clean_penals
    ON clean_standard.lliga = clean_penals.lliga AND clean_standard.temporada = clean_penals.temporada AND clean_standard.equip = clean_penals.equip
WHERE clean_penals.equip IS NULL;

ALTER TABLE clean_penals
    ADD COLUMN penals_marcats INT,
    ADD COLUMN penals_contra_defense INT,
    ADD COLUMN penals_encaixats_defense INT;

UPDATE clean_penals
JOIN clean_standard
    ON clean_penals.lliga = clean_standard.lliga AND clean_penals.temporada = clean_standard.temporada AND clean_penals.equip = clean_standard.equip
SET clean_penals.penals_marcats = clean_standard.penals_marcats;

UPDATE clean_penals
JOIN clean_standard
    ON clean_penals.lliga = clean_standard.lliga AND clean_penals.temporada = clean_standard.temporada AND clean_penals.equip = clean_standard.equip
SET clean_penals.penals_favor = clean_standard.penals_favor;

UPDATE clean_penals
JOIN clean_defense
    ON clean_penals.lliga = clean_defense.lliga AND clean_penals.temporada = clean_defense.temporada AND clean_penals.equip = clean_defense.equip
SET clean_penals.penals_contra_defense = clean_defense.penals_contra;

UPDATE clean_penals
SET clean_penals.penals_contra = COALESCE(clean_penals.penals_contra_defense, clean_penals.penals_contra);

UPDATE clean_penals
JOIN clean_defense
    ON clean_penals.lliga = clean_defense.lliga AND clean_penals.temporada = clean_defense.temporada AND clean_penals.equip = clean_defense.equip
SET clean_penals.penals_encaixats_defense = clean_defense.penals_encaixats;

UPDATE clean_penals
SET clean_penals.penals_encaixats = COALESCE(clean_penals.penals_encaixats_defense, clean_penals.penals_encaixats);

ALTER TABLE clean_xuts
    ADD COLUMN xuts_totals_porteria INT,
    ADD COLUMN xuts_rebuts_porteria INT;

UPDATE clean_xuts
JOIN clean_attack
    ON clean_xuts.lliga = clean_attack.lliga AND clean_xuts.temporada = clean_attack.temporada AND clean_xuts.equip = clean_attack.equip
SET clean_xuts.xuts_totals_porteria = clean_attack.xuts_porteria;

UPDATE clean_xuts
JOIN clean_defense
    ON clean_xuts.lliga = clean_defense.lliga AND clean_xuts.temporada = clean_defense.temporada AND clean_xuts.equip = clean_defense.equip
SET clean_xuts.xuts_rebuts_porteria = clean_defense.xuts_porteria_rebuts;

UPDATE clean_standard
JOIN clean_targetes
    ON clean_standard.lliga = clean_targetes.lliga AND clean_standard.temporada = clean_targetes.temporada AND clean_standard.equip = clean_targetes.equip
SET clean_standard.targetes_grogues = clean_targetes.targetes_grogues, clean_standard.targetes_vermelles = clean_targetes.targetes_vermelles;




