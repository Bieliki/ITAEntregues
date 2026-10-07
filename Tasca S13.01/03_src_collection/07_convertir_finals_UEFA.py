from pathlib import Path
import glob
import re
import pandas as pd

# Directori amb el contingut html
CARPETA_HTML = Path(r"EL_TEU_PATH\finals_html")

# Creació fitxer finals UEFA
def extreure_dades_partit(ruta_html):
    with open(ruta_html, encoding="utf-8") as f:
        html = f.read()

    # Extracció d'equips i marcador
    bloc_local = re.search(r'id="sb_team_0".*?(?=id="sb_team_1")', html, re.S).group()
    bloc_visitant = re.search(r'id="sb_team_1".*?(?=<div class="scorebox_meta")', html, re.S).group()

    equip_local = re.search(r'<strong>\s*<a href="[^"]*">([^<]+)</a>', bloc_local).group(1)
    equip_visitant = re.search(r'<strong>\s*<a href="[^"]*">([^<]+)</a>', bloc_visitant).group(1)

    gols_local = int(re.search(r'<div class="score">(\d+)</div>', bloc_local).group(1))
    gols_visitant = int(re.search(r'<div class="score">(\d+)</div>', bloc_visitant).group(1))

    # Determinació de l'equip guanyador
    if 'class="winner"' in bloc_local:
        guanyador = equip_local
    elif 'class="winner"' in bloc_visitant:
        guanyador = equip_visitant
    else:
        if gols_local > gols_visitant:
            guanyador = equip_local
        elif gols_visitant > gols_local:
            guanyador = equip_visitant
        else:
            guanyador = "Empat"

    # Identificació competició UEFA
    comp_match = re.search(r'>(UEFA[^<]+)</a>\s*\(Final\)', html)
    if comp_match:
        competicio = comp_match.group(1).strip()
    else:
        comp_match_alt = re.search(r'>(UEFA [^<]+League)[\s<]', html)
        competicio = comp_match_alt.group(1).strip() if comp_match_alt else None

    # Conversió any final a format temporada
    data_match = re.search(r'(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},\s+(\d{4})', html)

    if data_match:
        any_fi = int(data_match.group(1))
        any_inici = any_fi - 1
        temporada = f"{str(any_inici)[-2:]}{str(any_fi)[-2:]}"
    else:
        temporada = None

    # Extracció de la possessió
    possessio = re.findall(r"<strong>(\d+)%</strong>", html)
    possessio_local = int(possessio[0]) if len(possessio) > 0 else None
    possessio_visitant = int(possessio[1]) if len(possessio) > 1 else None

    return {
        "competicio": competicio,
        "temporada": temporada,
        "equip_local": equip_local,
        "equip_visitant": equip_visitant,
        "gols_local": gols_local,
        "gols_visitant": gols_visitant,
        "guanyador": guanyador,
        "possessio_local": possessio_local,
        "possessio_visitant": possessio_visitant}


fitxers_html = glob.glob(f"{CARPETA_HTML}/*.html")
print(f"Fitxers HTML trobats: {len(fitxers_html)}")

# Processament dels fitxers html
resultats = [extreure_dades_partit(ruta) for ruta in fitxers_html]

df_resultat = pd.DataFrame(resultats)
sortida = CARPETA_HTML / "finals_UEFA.csv"
df_resultat.to_csv(sortida, index=False)

print("\nProcés finalitzat!")
print(df_resultat)
