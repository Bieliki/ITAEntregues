import time
from pathlib import Path
import pandas as pd
from understatapi import UnderstatClient
from understatapi.exceptions import InvalidTeam

# Directori de sortida
CARPETA = Path(r"EL_TEU_PATH")

# Fitxer d'origen amb els equips i temporades
FONT_EQUIPS = CARPETA / "team_season_standard_final.csv"

TEMPORADES_A_OMPLIR = {("ENG-Premier League", "1415"), ("ENG-Premier League", "1516"), ("ESP-La Liga", "1415"), ("GER-Bundesliga", "1415"),
    ("GER-Bundesliga", "1516"), ("ITA-Serie A", "1415"), ("ITA-Serie A", "1516"), ("FRA-Ligue 1", "1415"), ("FRA-Ligue 1", "1516")}

# Equivalències entre noms de lliga FBref i Understat
LLIGA_FBREF_A_UNDERSTAT = {"ENG-Premier League": "EPL", "ESP-La Liga": "La_liga", "GER-Bundesliga": "Bundesliga", "ITA-Serie A": "Serie_A", "FRA-Ligue 1": "Ligue_1"}

TEMPORADA_FBREF_A_ANY_INICI = {"1415": "2014", "1516": "2015"}

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
    "Paderborn": "Paderborn"}

df_equips = pd.read_csv(FONT_EQUIPS)

files_resultat = []

# Descàrrega de les estadístiques de penals
with UnderstatClient() as understat:
    for lliga, temporada in TEMPORADES_A_OMPLIR:
        equips = df_equips[(df_equips["league"] == lliga) & (df_equips["season"].astype(str) == temporada)]["team"].tolist()

        any_understat = TEMPORADA_FBREF_A_ANY_INICI[temporada]

        for equip_fbref in equips:
            equip_understat = CORRECCIONS_NOM.get(equip_fbref, equip_fbref.replace(" ", "_"))

            print(f"Descarregant: {lliga} {temporada} - {equip_fbref} (com a '{equip_understat}')")

            penals_favor = None
            penals_contra = None
            penals_encaixats = None

            try:
                context = understat.team(team=equip_understat).get_context_data(season=any_understat)
                penalty = context.get("situation", {}).get("Penalty", {})
                penals_favor = penalty.get("shots")
                penals_contra = penalty.get("against", {}).get("shots")
                penals_encaixats = penalty.get("against", {}).get("goals")
            except InvalidTeam:
                print(f"-> NOM NO TROBAT a Understat: '{equip_understat}'")

            files_resultat.append(
                {   "league": lliga,
                    "season": temporada,
                    "team": equip_fbref,
                    "team_understat": equip_understat,
                    "penals_favor_understat": penals_favor,
                    "penals_contra_understat": penals_contra,
                    "penals_encaixats_understat": penals_encaixats})

            time.sleep(14)

df_resultat = pd.DataFrame(files_resultat)
sortida = CARPETA / "penals_understat_forats.csv"
df_resultat.to_csv(sortida, index=False)
print(f"\nGuardat a: {sortida}")
print("\nEquips sense dades trobades:")
print(df_resultat[df_resultat["penals_favor_understat"].isna()][["league", "season", "team", "team_understat"]])
