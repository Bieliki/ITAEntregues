USE futbol_silver;

ALTER TABLE clean_attack
    DROP COLUMN noranta_minuts,
    DROP COLUMN jugadors_utilitzats,
    DROP COLUMN xuts_totals_90,
    DROP COLUMN xuts_porteria_90,
    DROP COLUMN url,
    DROP COLUMN penals_favor,
    DROP COLUMN penals_marcats,
    DROP COLUMN gols,
    DROP COLUMN xuts_totals;

ALTER TABLE clean_class
    DROP COLUMN maxim_golejador,
    DROP COLUMN porter_titular;

ALTER TABLE clean_defense
    DROP COLUMN porters_utilitzats,
    DROP COLUMN partits_jugats,
    DROP COLUMN titularitats,
    DROP COLUMN minuts,
    DROP COLUMN noranta_minuts,
    DROP COLUMN gols_encaixats_90,
    DROP COLUMN victories,
    DROP COLUMN empats,
    DROP COLUMN derrotes,
    DROP COLUMN penals_aturats,
    DROP COLUMN penals_fallats_rival,
    DROP COLUMN percentatge_aturades_penal,
    DROP COLUMN url,
    DROP COLUMN penals_contra,
    DROP COLUMN penals_encaixats;

ALTER TABLE clean_misc
    DROP COLUMN noranta_minuts,
    DROP COLUMN segona_groga,
    DROP COLUMN url,
    DROP COLUMN targetes_grogues,
    DROP COLUMN targetes_vermelles,
    DROP COLUMN faltes_comeses,
    DROP COLUMN faltes_rebudes,
    DROP COLUMN penals_favor,
    DROP COLUMN penals_contra;

ALTER TABLE clean_penals
    DROP COLUMN equip_understat,
    DROP COLUMN penals_contra_defense,
    DROP COLUMN penals_encaixats_defense;

ALTER TABLE clean_standard
    DROP COLUMN jugadors_utilitzats,
    DROP COLUMN edat_mitja,
    DROP COLUMN partits_jugats,
    DROP COLUMN titularitats,
    DROP COLUMN minuts,
    DROP COLUMN noranta_minuts,
    DROP COLUMN gols_90,
    DROP COLUMN assistencies_90,
    DROP COLUMN gols_assistencies_90,
    DROP COLUMN gols_sense_penal_90,
    DROP COLUMN gols_assistencies_sense_penal_90,
    DROP COLUMN url,
    DROP COLUMN penals_favor,
    DROP COLUMN penals_marcats,
    DROP COLUMN targetes_grogues,
    DROP COLUMN targetes_vermelles;

ALTER TABLE clean_xuts
    DROP COLUMN equip_understat,
    DROP COLUMN xuts_totals_porteria,
    DROP COLUMN xuts_rebuts_porteria;

ALTER TABLE clean_targetes
    DROP COLUMN equip_understat;

ALTER TABLE clean_faltes
    DROP COLUMN equip_footballdata;




