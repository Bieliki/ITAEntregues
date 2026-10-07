from io import StringIO
from pathlib import Path
import pandas as pd
import requests

# Directori de sortida
CARPETA = Path(r"EL_TEU_PATH")
CARPETA.mkdir(parents=True, exist_ok=True)

HEADERS = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}

# Equivalència lliges projecte i Football-Data
LLIGA_CODI = {"ENG-Premier League": "E0", "ESP-La Liga": "SP1", "GER-Bundesliga": "D1", "ITA-Serie A": "I1", "FRA-Ligue 1": "F1"}

TEMPORADES = ["1415", "1516", "1617", "1718", "1819", "1920", "2021", "2122", "2223", "2324", "2425", "2526"]

files_resultat = []

total_combinacions = len(LLIGA_CODI) * len(TEMPORADES)
combinacio_actual = 0

# Descàrrega de les estadístiques de faltes
for lliga, codi in LLIGA_CODI.items():
    for temporada in TEMPORADES:
        combinacio_actual += 1
        url = f"https://football-data.co.uk/mmz4281/{temporada}/{codi}.csv"
        print(f"[{combinacio_actual}/{total_combinacions}] Descarregant {lliga} {temporada}: {url}")

        resposta = requests.get(url, headers=HEADERS, timeout=30)
        print(f"Codi de resposta HTTP: {resposta.status_code}")
        time.sleep(14)
        text_csv = resposta.content.decode("latin1")
        print(f"Primeres 300 caracters rebuts:\n{text_csv[:300]}\n")
        partits = pd.read_csv(StringIO(text_csv))

        equips = pd.concat([partits["HomeTeam"], partits["AwayTeam"]]).unique()

        for equip in equips:
            partits_local = partits[partits["HomeTeam"] == equip]
            partits_visitant = partits[partits["AwayTeam"] == equip]

            faltes_comeses = partits_local["HF"].sum() + partits_visitant["AF"].sum()
            faltes_rebudes = partits_local["AF"].sum() + partits_visitant["HF"].sum()

            files_resultat.append(
                {   "league": lliga,
                    "season": temporada,
                    "team_footballdata": equip,
                    "faltes_comeses_footballdata": faltes_comeses,
                    "faltes_rebudes_footballdata": faltes_rebudes})

df_resultat = pd.DataFrame(files_resultat)

# Equivalència noms FBref i Football-Data
CORRECCIONS_NOM_FBREF = {
    "Ath Bilbao": "Athletic Club",
    "Ath Madrid": "Atlético Madrid",
    "Alaves": "Alavés",
    "Almeria": "Almería",
    "Betis": "Real Betis",
    "Cadiz": "Cádiz",
    "Celta": "Celta Vigo",
    "Cordoba": "Córdoba",
    "Espanol": "Espanyol",
    "La Coruna": "Dep. La Coruña",
    "Leganes": "Leganés",
    "Malaga": "Málaga",
    "Sociedad": "Real Sociedad",
    "Sp Gijon": "Sporting Gijón",
    "Spal": "SPAL",
    "Vallecano": "Rayo Vallecano",
    "Ein Frankfurt": "Frankfurt",
    "Bielefeld": "Arminia",
    "M'gladbach": "Gladbach",
    "Fortuna Dusseldorf": "Düsseldorf",
    "FC Koln": "Köln",
    "Greuther Furth": "Greuther Fürth",
    "Hamburg": "Hamburger SV",
    "Hannover": "Hannover 96",
    "Hertha": "Hertha BSC",
    "Mainz": "Mainz 05",
    "Nurnberg": "Nürnberg",
    "Paderborn": "Paderborn 07",
    "Darmstadt": "Darmstadt 98",
    "Cardiff": "Cardiff City",
    "Hull": "Hull City",
    "Ipswich": "Ipswich Town",
    "Leeds": "Leeds United",
    "Leicester": "Leicester City",
    "Luton": "Luton Town",
    "Man City": "Manchester City",
    "Man United": "Manchester Utd",
    "Norwich": "Norwich City",
    "Nott'm Forest": "Nottingham",
    "Stoke": "Stoke City",
    "Swansea": "Swansea City",
    "Clermont": "Clermont Foot",
    "Evian Thonon Gaillard": "Evian",
    "Paris SG": "PSG",
    "St Etienne": "Saint-Étienne",
    "Verona": "Hellas Verona",
    "Nimes": "Nîmes",
    "Ajaccio GFCO": "Ajaccio"}

df_resultat = df_resultat.dropna(subset=["team_footballdata"])

df_resultat["team"] = df_resultat["team_footballdata"].replace(CORRECCIONS_NOM_FBREF)

sortida = CARPETA / "faltes_footballdata_complet.csv"
df_resultat.to_csv(sortida, index=False)
print(f"\nGuardat a: {sortida}")
print("\nEquips sense dades trobades (afegeix-los a CORRECCIONS_NOM i torna a executar):")
print(df_resultat[df_resultat["faltes_comeses_footballdata"].isna()][["league", "season", "team_footballdata", "team"]])
