# Projecte Final: Anàlisi de Dades del Futbol Europeu (2014–2026)

Aquest repositori conté el projecte final del **Bootcamp de Data Analytics d'ITAcademy**. El projecte consisteix en una pipeline end-to-end de dades esportives, des de l'extracció web i control de qualitat, passant per un modelatge de dades amb arquitectura Medallion en SQL, fins a l'anàlisi estadística avançada en Python, la generació de gràfics en Power BI i la visualització en Google Presentation.

---

## Pipeline del Projecte

El flux de treball s'estructura en les següents etapes:

1. **Extracció de Dades (`03_src_collection/`):** Scripts en Python per descarregar de manera automatitzada estadístiques multi-temporada de les grans lligues europeues des de FBref i altres webs.
2. **Validació i Control de Qualitat (`04_src_validation/`):** Script de validació prèvia per detectar valors nuls, duplicats, integritat d'equips, temporades faltants i consistència entre arxius abans de la càrrega.
3. **Emagatzematge i Normalització - Arquitectura Medallion (`05_sql/`):** Creació de l'estructura de base de dades i transformació de dades passant per capes (Bronze, Silver, Gold), normalitzant noms i tipus de dades.
4. **Anàlisi Estadística (`06_notebooks/`):** Jupyter Notebook dedicat a l'anàlisi exploratòria i de correlacions entre variables de rendiment dels equips.
5. **Visualització i Informes (`07_dashboards/` & `08_reports/`):** Quadre de comandament desenvolupat en Power BI, informe científic en format PDF i presentació en format .pptx.

---

## Estructura del Repositori

```text
Tasca S13.01/
├── 01_data_raw/            # Fitxers .csv originals descarregats
├── 02_data_processed/      # Fitxers resultants i transformats
├── 03_src_collection/      # Scripts Python d'extracció de dades
├── 04_src_validation/      # Script Python de validació de qualitat de dades
├── 05_sql/                 # Scripts SQL per a l'arquitectura Medallion
├── 06_notebooks/           # Jupyter Notebook (.ipynb) d'anàlisi de correlacions
├── 07_dashboards/          # Fitxer Power BI (.pbix)
├── 08_reports/             # Informe .pdf i presentació .pptx del projecte. Presentació .pdf i Mesures DAX .pdf
└── README.md               # Documentació del projecte
```
---

## Origen de les Dades i Flux de Treball

Degut a restriccions legals d'algunes de les fonts originals, el conjunt de dades inicial es va recopilar combinant scripts d'extracció i descàrregues manuals. Per facilitar la reproducció del projecte, els arxius CSV i HTML originals ja es proporcionen directament a la carpeta `01_data_raw` i els arxius processats a `02_data_processed`.

Si vols executar i verificar tot el procés a partir d'aquí, segueix aquests passos:

**Nota**: Abans d'executar els scripts de Python i SQL, recorda substituir la variable EL_TEU_PATH per la ruta absoluta de la teva màquina.

1. **Descarregar els fitxers**
   * Genera al teu equip l'estructura de carpetes desitjada i descarrega els fitxers CSV i HTML on correspongui.

2. **Control de qualitat (Data Quality):**
   * Executa l'script de validació ubicat a `04_src_validation` per comprovar valors nuls, duplicats, integritat d'equips i consistència entre arxius.

3. **Càrrega i transformació a MySQL (Arquitectura Medallion):**
   * Obre el teu gestor de MySQL i executa els scripts de la carpeta `05_sql` seguint la numeració dels fitxers (per crear les capes Bronze, Silver i Gold, i normalitzar les dades).

4. **Anàlisi de correlacions:**
   * Modifica primer l'arxiu `connexio.py` amb les dades pertinents. Obre el Jupyter Notebook `06_notebooks/09_analisis_correlacio_possessio.ipynb` per veure i executar l'anàlisi estadística i les matrius de correlació.

5. **Visualització i Informes:**
   * Obre el fitxer `07_dasboards/informe.pbix` amb Power BI Desktop per interactuar amb el dashboard.
   * Obre el fitxer `08_reports/informe.pptx` amb PowerPoint o Google Presentations per visualitzar la presentació a pantalla completa.
   * Consulta el document `08_reports/informe.pdf` per llegir l'informe executiu basat en l'anàlisi `06_notebooks/09_analisis_correlacio_possessio.ipynb`.

---

## Tecnologies i Eines Utilitzades

* **Llenguatges:** Python, SQL
* **Libreries Python:** `pandas`, `matplotlib`, `seaborn`, `soccerdata`, `understatapi`, `requests`, `scipy`, `sqlalchemy`
* **Base de Dades / Data Warehouse:** MySQL (Arquitectura Medallion)
* **Business Intelligence:** Power BI Desktop (DAX, visualitzacions interactives)
* **Presentació:** Google Presentation
* **Control de Versions:** Git & GitHub

---
*Autor: [Biel Domènech Vives] - ITAcademy Data Analytics Bootcamp (2026)*
