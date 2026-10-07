from pathlib import Path
import pandas as pd

# Directori de sortida
DATA_DIR = Path(r"EL_TEU_PATH")

SORTIDA_TXT = DATA_DIR / "resum_qualitat.txt"
fitxer_sortida = open(SORTIDA_TXT, "w", encoding="utf-8")


def log(text=""):
    print(text)
    fitxer_sortida.write(str(text) + "\n")

# Temporades esperades per a cada lliga
TEMPORADES_ESPERADES = ["1415", "1516", "1617", "1718", "1819", "1920", "2021", "2122", "2223", "2324", "2425", "2526"]

# Fitxers a validar
FITXERS = {
    "standard": "team_season_standard_final.csv",
    "keeper": "team_season_keeper_final.csv",
    "shooting": "team_season_shooting_final.csv",
    "misc": "team_season_misc_final.csv",
    "class": "big_5_final.csv"}

# Càrrega de toes les taules
taules = {nom: pd.read_csv(DATA_DIR / fitxer) for nom, fitxer in FITXERS.items()}

taules["class"] = taules["class"].rename(columns={"Squad": "team"})

# Validació de valors nuls
for nom, df in taules.items():
    log(f"\n=== {nom}: nulls per columna i temporada ===")
    cols_amb_nuls = df.columns[df.isna().any()]
    for col in cols_amb_nuls:
        buits = df.groupby(["league", "season"])[col].apply(lambda x: x.isna().sum())
        buits = buits[buits > 0]
        if not buits.empty:
            log(f"{col}:")
            log(buits.to_string())

# Validació de duplicats
for nom, df in taules.items():
    log(f"\n=== {nom}: duplicats ===")
    duplicats_exactes = df.duplicated().sum()
    duplicats_clau = df.duplicated(subset=["league", "season", "team"]).sum()
    log(f"Duplicats exactes (fila sencera repetida): {duplicats_exactes}")
    log(f"Duplicats per clau league+season+team: {duplicats_clau}")
    if duplicats_clau > 0:
        log("Files afectades:")
        log(df[df.duplicated(subset=["league", "season", "team"], keep=False)])

# Validació de nombre d'equips per lliga i temporada
for nom, df in taules.items():
    log(f"\n=== {nom}: nombre d'equips per lliga i temporada ===")
    log(df.groupby(["league", "season"]).size().unstack(fill_value=0))

# Validació de temporades absents
for nom, df in taules.items():
    log(f"\n=== {nom}: temporades absents per lliga ===")
    for league in df["league"].unique():
        temporades_presents = set(df[df["league"] == league]["season"].astype(str))
        absents = set(TEMPORADES_ESPERADES) - temporades_presents
        if absents:
            log(f"{league}: falten {sorted(absents)}")

# Validació de valors constants per lliga i temporada
for nom, df in taules.items():
    log(f"\n=== {nom}: columnes amb valor constant per a tot un grup lliga-temporada ===")
    columnes_numeriques = df.select_dtypes(include="number").columns
    for col in columnes_numeriques:
        variancia_per_grup = df.groupby(["league", "season"])[col].nunique()
        grups_sospitosos = variancia_per_grup[variancia_per_grup == 1]
        if len(grups_sospitosos) > 0:
            log(f"{col}: {len(grups_sospitosos)} grups amb un unic valor repetit -- revisar manualment")
            log(grups_sospitosos.to_string())

# Validació de consistencia entre taules
log("\n=== Consistencia PK/PKatt entre standard i shooting ===")
comparacio = taules["standard"].merge(taules["shooting"], on=["league", "season", "team"], suffixes=("_standard", "_shooting"))
for col in ["PK", "PKatt"]:
    coincideixen = (comparacio[f"{col}_standard"] == comparacio[f"{col}_shooting"]).all()
    log(f"{col}: {'coincideix a totes les files' if coincideixen else 'HI HA DISCREPANCIES'}")

log("\nFet.")

fitxer_sortida.close()
print(f"\nResum guardat tambe a: {SORTIDA_TXT}")
