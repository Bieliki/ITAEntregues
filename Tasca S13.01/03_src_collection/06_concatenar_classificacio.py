import glob
import pandas as pd

# Directori de sortida
CARPETA = r"EL_TEU_PATH\bundesliga o EL_TEU_PATH\laliga o EL_TEU_PATH\ligue1 o EL_TEU_PATH\premier o EL_TEU_PATH\seriea"

FITXERS = glob.glob(CARPETA + r"\*.csv")
print(f"Fitxers trobats: {len(FITXERS)}")

llista_dfs = []

#Càrrega i unificació de fitxers
for fitxer in FITXERS:
    df_llista = pd.read_csv(fitxer)
    llista_dfs.append(df_llista)

df_final = pd.concat(llista_dfs, ignore_index=True)
print(f"Files totals despres d'ajuntar: {len(df_final)}")

print("\nLligues trobades:")
print(df_final["league"].value_counts())
print("\nTemporades trobades:")
print(df_final["season"].value_counts().sort_index())

sortida = CARPETA + r"EL_TEU_PATH\big_5_final.csv"
df_final.to_csv(sortida, index=False)
print(f"\nGuardat a: {sortida}")
