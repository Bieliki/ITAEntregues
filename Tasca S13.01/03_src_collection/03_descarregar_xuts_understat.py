import time
from pathlib import Path
import pandas as pd
from understatapi import UnderstatClient
from understatapi.exceptions import InvalidTeam

# Directori de sortida
CARPETA = Path(r"EL_TEU_PATH")

# Fitxer d'origen amb els equips i temporades
FONT_EQUIPS = CARPETA / "team_season_standard_final.csv"

LLIGUES = ["ENG-Premier League", "ESP-La Liga", "GER-Bundesliga", "ITA-Serie A", "FRA-Ligue 1"]

TEMPORADES = ["1415", "1516", "1617", "1718", "1819", "1920", "2021", "2122", "2223", "2324", "2425", "2526"]

TEMPORADES_OMPLIR = {(lliga, temporada) for lliga in LLIGUES for temporada in TEMPORADES}

# Equivalència tenporades FBref i Understat
TEMPORADA_FBREF_A_ANY_INICI = {"1415": "2014", "1516": "2015", "1617": "2016", "1718": "2017", "1819": "2018", "1920": "2019", "2021": "2020", "2122": "2021", "2223": "2022",
    "2324": "2023", "2425": "2024", "2526": "2025"}

# Equivalència noms FBref i Understat
CORRECCIONS_NOM = {
    "Bastia": "SC_Bastia",
    "Dep. La Coruña": "Deportivo_La_Coruna",
    "Köln": "FC_Cologne",
    "Evian": "Evian_Thonon_Gaillard",
    "Milan": "AC_Milan",
    "Hellas Verona": "Verona",
    "Gazélec Ajaccio": "GFC_Ajaccio",
    "Dortmund": "Borussia_Dortmund",
    "Frankfurt": "Eintracht_Frankfurt",
    "Leverkusen": "Bayer_Leverkusen",
    "Stuttgart": "VfB_Stuttgart",
    "Manchester Utd": "Manchester_United",
    "Newcastle": "Newcastle_United",
    "West Brom": "West_Bromwich_Albion",
    "QPR": "Queens_Park_Rangers",
    "PSG": "Paris_Saint_Germain",
    "Darmstadt 98": "Darmstadt",
    "Gladbach": "Borussia_M.Gladbach",
    "Hertha BSC": "Hertha_Berlin",
    "Leicester City": "Leicester",
    "Norwich City": "Norwich",
    "Stoke City": "Stoke",
    "Swansea City": "Swansea",
    "Hull City": "Hull",
    "Paderborn": "Paderborn",
    "Arminia": "Arminia_Bielefeld",
    "Cardiff City": "Cardiff",
    "Düsseldorf": "Fortuna_Duesseldorf",
    "Greuther Fürth": "Greuther_Fuerth",
    "Heidenheim": "FC_Heidenheim",
    "Huesca": "SD_Huesca",
    "Ipswich Town": "Ipswich",
    "Leeds United": "Leeds",
    "Luton Town": "Luton",
    "Nottingham": "Nottingham_Forest",
    "Nürnberg": "Nuernberg",
    "Oviedo": "Real_Oviedo",
    "Paderborn 07": "Paderborn",
    "RB Leipzig": "RasenBallsport_Leipzig",
    "SPAL": "SPAL_2013",
    "St Pauli": "St._Pauli",
    "Valladolid": "Real_Valladolid",
    "Wolves": "Wolverhampton_Wanderers"}

df_equips = pd.read_csv(FONT_EQUIPS)

files_resultat = []

# Descàrrega de les estadístiques de xuts
with UnderstatClient() as understat:
    for lliga, temporada in TEMPORADES_OMPLIR:
        equips = df_equips[(df_equips["league"] == lliga) & (df_equips["season"].astype(str) == temporada)]["team"].tolist()

        any_understat = TEMPORADA_FBREF_A_ANY_INICI[temporada]

        for equip_fbref in equips:
            equip_understat = CORRECCIONS_NOM.get(equip_fbref, equip_fbref.replace(" ", "_"))

            print(f"Descarregant: {lliga} {temporada} - {equip_fbref} (com a '{equip_understat}')")

            xuts_totals = None
            xuts_rebuts = None

            try:
                context = understat.team(team=equip_understat).get_context_data(season=any_understat)
                situacions = context.get("situation", {})

                xuts_totals = sum(situacio.get("shots", 0) for situacio in situacions.values())
                xuts_rebuts = sum(situacio.get("against", {}).get("shots", 0) for situacio in situacions.values())
            except InvalidTeam:
                print(f"-> NOM NO TROBAT a Understat: '{equip_understat}'")

            files_resultat.append(
                {   "league": lliga,
                    "season": temporada,
                    "team": equip_fbref,
                    "team_understat": equip_understat,
                    "xuts_totals_understat": xuts_totals,
                    "xuts_rebuts_understat": xuts_rebuts})

            time.sleep(14)

df_resultat = pd.DataFrame(files_resultat)
sortida = CARPETA / "xuts_understat_complet.csv"
df_resultat.to_csv(sortida, index=False)
print(f"\nGuardat a: {sortida}")
print("\nEquips sense dades trobades (afegeix-los a CORRECCIONS_NOM i torna a executar):")
print(df_resultat[df_resultat["xuts_totals_understat"].isna()][["league", "season", "team", "team_understat"]])

