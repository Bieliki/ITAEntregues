from pathlib import Path
import soccerdata as sd

# Directori de sortida
CARPETA = Path(r"EL_TEU_PATH")
CARPETA.mkdir(parents=True, exist_ok=True)

# Competició agregada que inclou les cinc grans lligues europees
BIG5 = "Big 5 European Leagues Combined"

# Temporades analitzades (2014/2015 - 2025/2026)
TEMPORADES = ["1415", "1516", "1617", "1718", "1819", "1920", "2021", "2122", "2223", "2324", "2425", "2526"]

# Tipologies estadístiques que es descarregaran
TIPUS_ESTADISTIQUES = ["standard", "keeper", "shooting", "misc"]

# Assignació manual dels noms de les columnes
NOMS_COLUMNES = {
    "standard": ["players_used", "Age", "Poss", "MP", "Starts", "Min", "90s", "Gls", "Ast", "G+A", "G-PK", "PK", "PKatt", "CrdY", "CrdR",
        "P90_Gls", "P90_Ast", "P90_G+A", "P90_G-PK", "P90_G+A-PK", "url"],
    "keeper": ["players_used", "MP", "Starts", "Min", "90s", "GA", "GA90", "SoTA", "Saves", "Save%", "W", "D", "L", "CS", "CS%", "PKatt",
        "PKA", "PKsv", "PKm", "PK_Save%", "url"],
    "shooting": ["players_used", "90s", "Gls", "Sh", "SoT", "SoT%", "Sh/90", "SoT/90", "G/Sh", "G/SoT", "PK", "PKatt", "url"],
    "misc": ["players_used", "90s", "CrdY", "CrdR", "2CrdY", "Fls", "Fld", "Off", "Crs", "Int", "TklW", "PKwon", "PKcon", "OG", "url"]}

# Inicialització del connector FBref
print(f"Inicialitzant lector FBref: {BIG5}, temporades {TEMPORADES[0]} a {TEMPORADES[-1]}")
fbref = sd.FBref(leagues=BIG5, seasons=TEMPORADES)

# Descàrrega de cada grup d'estadístiques
for tipus in TIPUS_ESTADISTIQUES:
    print(f"\n--- Seccio: {tipus} ---")
    print("Descarregant...")
    df_estadistiques = fbref.read_team_season_stats(stat_type=tipus)

    df_estadistiques.columns = NOMS_COLUMNES[tipus]
    df_estadistiques = df_estadistiques.reset_index()

    abans = df_estadistiques["league"].isna().sum()
    df_estadistiques.loc[df_estadistiques["league"].isna(), "league"] = "GER-Bundesliga"
    print(f"{abans} files de Bundesliga etiquetades correctament")

    print("Comprovacio -- files per lliga i temporada:")
    print(df_estadistiques.groupby(["league", "season"]).size().unstack(fill_value=0))

    out_path = CARPETA / f"team_season_{tipus}_final.csv"
    df_estadistiques.to_csv(out_path, index=False)
    print(f"-> guardat a {out_path}")

print("\nFet.")

