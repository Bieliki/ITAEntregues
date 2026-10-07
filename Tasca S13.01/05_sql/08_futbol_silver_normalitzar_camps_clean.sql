USE futbol_silver;

ALTER TABLE clean_class
    RENAME COLUMN league TO lliga,
    RENAME COLUMN season TO temporada,
    RENAME COLUMN Rk TO classificacio,
    RENAME COLUMN Squad TO equip,
    RENAME COLUMN MP TO partits_jugats,
    RENAME COLUMN W TO victories,
    RENAME COLUMN D TO empats,
    RENAME COLUMN L TO derrotes,
    RENAME COLUMN GF TO gols_favor,
    RENAME COLUMN GA TO gols_contra,
    RENAME COLUMN GD TO diferencia_gols,
    RENAME COLUMN Pts TO punts,
    RENAME COLUMN `Pts/MP` TO punts_partit,
    RENAME COLUMN Attendance TO espectadors,
    RENAME COLUMN `Top Team Scorer` TO maxim_golejador,
    RENAME COLUMN `Goalkeeper` TO porter_titular,
    RENAME COLUMN Notes TO notes;

ALTER TABLE clean_standard
    RENAME COLUMN league TO lliga,
    RENAME COLUMN season TO temporada,
    RENAME COLUMN team TO equip,
    RENAME COLUMN players_used TO jugadors_utilitzats,
    RENAME COLUMN Age TO edat_mitja,
    RENAME COLUMN Poss TO possessio,
    RENAME COLUMN MP TO partits_jugats,
    RENAME COLUMN `Starts` TO titularitats,
    RENAME COLUMN Min TO minuts,
    RENAME COLUMN `90s` TO noranta_minuts,
    RENAME COLUMN Gls TO gols,
    RENAME COLUMN Ast TO assistencies,
    RENAME COLUMN `G+A` TO gols_assistencies,
    RENAME COLUMN `G-PK` TO gols_sense_penal,
    RENAME COLUMN PK TO penals_marcats,
    RENAME COLUMN PKatt TO penals_favor,
    RENAME COLUMN CrdY TO targetes_grogues,
    RENAME COLUMN CrdR TO targetes_vermelles,
    RENAME COLUMN P90_Gls TO gols_90,
    RENAME COLUMN P90_Ast TO assistencies_90,
    RENAME COLUMN `P90_G+A` TO gols_assistencies_90,
    RENAME COLUMN `P90_G-PK` TO gols_sense_penal_90,
    RENAME COLUMN `P90_G+A-PK` TO gols_assistencies_sense_penal_90;

ALTER TABLE clean_defense
    RENAME COLUMN league TO lliga,
    RENAME COLUMN season TO temporada,
    RENAME COLUMN team TO equip,
    RENAME COLUMN players_used TO porters_utilitzats,
    RENAME COLUMN MP TO partits_jugats,
    RENAME COLUMN `Starts` TO titularitats,
    RENAME COLUMN Min TO minuts,
    RENAME COLUMN `90s` TO noranta_minuts,
    RENAME COLUMN GA TO gols_encaixats,
    RENAME COLUMN GA90 TO gols_encaixats_90,
    RENAME COLUMN SoTA TO xuts_porteria_rebuts,
    RENAME COLUMN Saves to aturades,
    RENAME COLUMN `Save%` TO percentatge_aturades,
    RENAME COLUMN W TO victories,
    RENAME COLUMN D TO empats,
    RENAME COLUMN L TO derrotes,
    RENAME COLUMN CS TO porteria_zero,
    RENAME COLUMN `CS%` TO percentatge_porteria_zero,
    RENAME COLUMN PKatt TO penals_contra,
    RENAME COLUMN PKA TO penals_encaixats,
    RENAME COLUMN PKsv TO penals_aturats,
    RENAME COLUMN PKm TO penals_fallats_rival,
    RENAME COLUMN `PK_Save%` TO percentatge_aturades_penal;

ALTER TABLE clean_attack
    RENAME COLUMN league TO lliga,
    RENAME COLUMN season TO temporada,
    RENAME COLUMN team TO equip,
    RENAME COLUMN players_used TO jugadors_utilitzats,
    RENAME COLUMN `90s` TO noranta_minuts,
    RENAME COLUMN Gls TO gols,
    RENAME COLUMN Sh TO xuts_totals,
    RENAME COLUMN SoT TO xuts_porteria,
    RENAME COLUMN `SoT%` TO percentatge_xuts_porteria,
    RENAME COLUMN `Sh/90` TO xuts_totals_90,
    RENAME COLUMN `SoT/90` TO xuts_porteria_90,
    RENAME COLUMN `G/Sh` TO gols_per_xut,
    RENAME COLUMN `G/SoT` TO gols_per_xut_porteria,
    RENAME COLUMN PK TO penals_marcats,
    RENAME COLUMN PKatt TO penals_favor;

ALTER TABLE clean_misc
    RENAME COLUMN league TO lliga,
    RENAME COLUMN season TO temporada,
    RENAME COLUMN team TO equip,
    RENAME COLUMN players_used TO jugadors_utilitzats,
    RENAME COLUMN `90s` TO noranta_minuts,
    RENAME COLUMN CrdY TO targetes_grogues,
    RENAME COLUMN CrdR TO targetes_vermelles,
    RENAME COLUMN `2CrdY` TO segona_groga,
    RENAME COLUMN Fls TO faltes_comeses,
    RENAME COLUMN Fld TO faltes_rebudes,
    RENAME COLUMN `Off` TO fores_de_joc,
    RENAME COLUMN Crs TO centrades,
    RENAME COLUMN `Int` TO intercepcions,
    RENAME COLUMN TklW TO entrades_recuperacio,
    RENAME COLUMN PKwon TO penals_favor,
    RENAME COLUMN PKcon TO penals_contra,
    RENAME COLUMN OG TO gols_propia_porta;

ALTER TABLE clean_penals
    RENAME COLUMN league TO lliga,
    RENAME COLUMN season TO temporada,
    RENAME COLUMN team TO equip,
    RENAME COLUMN team_understat TO equip_understat,
    RENAME COLUMN penals_favor_understat TO penals_favor,
    RENAME COLUMN penals_contra_understat TO penals_contra,
    RENAME COLUMN penals_encaixats_understat TO penals_encaixats;

ALTER TABLE clean_xuts
    RENAME COLUMN league TO lliga,
    RENAME COLUMN season TO temporada,
    RENAME COLUMN team TO equip,
    RENAME COLUMN team_understat TO equip_understat,
    RENAME COLUMN xuts_totals_understat TO xuts_totals,
    RENAME COLUMN xuts_rebuts_understat TO xuts_rebuts;

ALTER TABLE clean_targetes
    RENAME COLUMN league TO lliga,
    RENAME COLUMN season TO temporada,
    RENAME COLUMN team TO equip,
    RENAME COLUMN team_understat TO equip_understat,
    RENAME COLUMN targetes_grogues_understat TO targetes_grogues,
    RENAME COLUMN targetes_vermelles_understat TO targetes_vermelles;

ALTER TABLE clean_faltes
    RENAME COLUMN league TO lliga,
    RENAME COLUMN season TO temporada,
    RENAME COLUMN team_footballdata TO equip_footballdata,
    RENAME COLUMN faltes_comeses_footballdata TO faltes_comeses,
    RENAME COLUMN faltes_rebudes_footballdata TO faltes_rebudes,
    RENAME COLUMN team TO equip;
