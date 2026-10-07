INSERT INTO futbol_gold.dim_equip (equip) SELECT DISTINCT cls.equip FROM futbol_silver.clean_class AS cls;
INSERT INTO futbol_gold.dim_lliga (lliga) SELECT DISTINCT cls.lliga FROM futbol_silver.clean_class AS cls;
INSERT INTO futbol_gold.dim_temporada (temporada) SELECT DISTINCT cls.temporada FROM futbol_silver.clean_class AS cls;
INSERT INTO futbol_gold.dim_tram_possessio (tram, valor_min, valor_max)
VALUES ('Molt baixa', 0.0, 39.9), ('Baixa', 40.0, 44.9), ('Mitjana', 45.0, 54.9), ('Alta', 55.0, 64.9), ('Molt alta', 65.0, 100.0);

truncate futbol_gold.fact_finals_uefa;

INSERT INTO futbol_gold.fact_finals_uefa (
    competicio,
    temporada,
    equip_local,
    equip_visitant,
    gols_local,
    gols_visitant,
    guanyador,
    possessio_local,
    possessio_visitant)
SELECT
    fin.competicio,
    fin.temporada,
    fin.equip_local,
    fin.equip_visitant,
    fin.gols_local,
    fin.gols_visitant,
    fin.guanyador,
    fin.possessio_local,
    fin.possessio_visitant
FROM futbol_silver.clean_finals AS fin;

UPDATE fact_finals_uefa
SET possessio_guanyador = CASE
    WHEN equip_local = guanyador THEN possessio_local
    ELSE possessio_visitant
END;

UPDATE fact_finals_uefa AS uef
JOIN dim_tram_possessio AS dtp ON uef.possessio_guanyador >= dtp.valor_min
    AND uef.possessio_guanyador <= dtp.valor_max
SET uef.id_tram = dtp.id_tram;

INSERT INTO futbol_gold.fact_equip_temporada (
    id_equip,
    id_lliga,
    id_temporada,
    id_tram,
    targetes_grogues,
    targetes_vermelles,
    faltes_comeses,
    faltes_rebudes,
    penals_favor,
    penals_contra,
    xuts_realitzats,
    xuts_rebuts,
    gols_realitzats,
    gols_rebuts,
    possessio,
    classificacio,
    victories,
    empats,
    derrotes,
    punts,
    espectadors)
SELECT
    eqp.id_equip,
    lli.id_lliga,
    tmp.id_temporada,
    trm.id_tram,
    tar.targetes_grogues,
    tar.targetes_vermelles,
    fal.faltes_comeses,
    fal.faltes_rebudes,
    pen.penals_favor,
    pen.penals_contra,
    xut.xuts_totals AS xuts_realitzats,
    xut.xuts_rebuts AS xuts_rebuts,
    cls.gols_favor AS gols_realitzats,
    cls.gols_contra AS gols_rebuts,
    sta.possessio,
    cls.classificacio,
    cls.victories,
    cls.empats,
    cls.derrotes,
    cls.punts,
    cls.espectadors
FROM futbol_silver.clean_class AS cls

JOIN futbol_gold.dim_equip AS eqp ON cls.equip = eqp.equip
JOIN futbol_gold.dim_lliga AS lli ON cls.lliga = lli.lliga
JOIN futbol_gold.dim_temporada AS tmp ON cls.temporada = tmp.temporada

LEFT JOIN futbol_silver.clean_targetes AS tar ON cls.lliga = tar.lliga
    AND cls.temporada = tar.temporada
    AND cls.equip = tar.equip
LEFT JOIN futbol_silver.clean_faltes AS fal ON cls.lliga = fal.lliga
    AND cls.temporada = fal.temporada
    AND cls.equip = fal.equip
LEFT JOIN futbol_silver.clean_penals AS pen ON cls.lliga = pen.lliga
    AND cls.temporada = pen.temporada
    AND cls.equip = pen.equip
LEFT JOIN futbol_silver.clean_xuts AS xut ON cls.lliga = xut.lliga
    AND cls.temporada = xut.temporada
    AND cls.equip = xut.equip
LEFT JOIN futbol_silver.clean_standard AS sta ON cls.lliga = sta.lliga
    AND cls.temporada = sta.temporada
    AND cls.equip = sta.equip
LEFT JOIN futbol_gold.dim_tram_possessio AS trm ON sta.possessio
    BETWEEN trm.valor_min AND trm.valor_max;
