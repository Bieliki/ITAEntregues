-- NIVELL 1: Entorn i Ingesta Híbrida (Code-First)
-- Exercici 1: Arquitectura de Dades (Lògica vs. Física)

create schema if not exists `sprint3-analytics-bieldomenech.sprint3_silver`
options (location="EU");

-- Exercici 2: Ingesta en Capa Bronze (Connexió DDL)

create or replace external table `sprint3-analytics-bieldomenech.sprint3_bronze.transactions_raw`
options (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/ERP/transactions.csv'],
  field_delimiter = ';',
  skip_leading_rows = 1
);

-- Exercici 3: Càrrega de Dades Locals (Upload)

create or replace table `sprint3-analytics-bieldomenech.sprint3_bronze.products_raw`
(
  id string,
  product_name string,
  price string,
  colour string,
  weight string,
  warehouse_id string
);

-- Exercici 4: Arquitectura i Rendiment. Materialització de Dades (Assistit per IA)

create or replace table `sprint3-analytics-bieldomenech.sprint3_bronze.transactions_raw_native` as
select * from `sprint3-analytics-bieldomenech.sprint3_bronze.transactions_raw`;

select id
from `sprint3_bronze.transactions_raw`;

select id
from `sprint3_bronze.transactions_raw_native`;

SELECT * FROM sprint3_bronze.transactions_raw LIMIT 10;
SELECT * FROM sprint3_bronze.transactions_raw_native LIMIT 10;

-- Exercici 5: Adaptació de Sintaxi (Reporting)

select date(timestamp) as Dates, round(sum(amount), 2) as Total_Vendes
from `sprint3-analytics-bieldomenech.sprint3_bronze.transactions_raw_native`
where (declined = 0) and (timestamp >= '2022-01-01' and timestamp < '2022-01-01')
group by Dates
order by Total_Vendes desc
limit 5;

-- Exercici 6: Consultes Complexes

select c.company_name as Empresa, c.country as Pais,date(t.timestamp) as Data_Transaccio
from `sprint3-analytics-bieldomenech.sprint3_bronze.companies_raw` as c
join `sprint3-analytics-bieldomenech.sprint3_bronze.transactions_raw_native` as t
on c.company_id = t.business_id
where (t.declined = 0) and (t.amount between 100 and 200) and (date(t.timestamp) = '2015-04-29' or date(t.timestamp) = '2018-07-20' or date(t.timestamp) = '2024-03-13');

-- NIVELL 2: Neteja i Transformació (ELT)
-- Exercici 1: Neteja de Productes (Data Quality)

create or replace table `sprint3-analytics-bieldomenech.sprint3_silver.products_clean` as
select id as product_id,
product_name as name,
cast(regexp_replace(warehouse_id, r'^WH-+([0-9]+)$', r'\1') as int64) as warehouse_id,
price,
weight,
colour
from `sprint3-analytics-bieldomenech.sprint3_bronze.products_raw`;

-- Exercici 2: Creació de Transaccions Netes (Capa Silver)

create or replace table `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean` as
select id as transaction_id,
ifnull(safe_cast(amount as float64), 0) as amount,
safe_cast(timestamp as timestamp) as timestamp,
safe_cast(lat as float64) as lat,
safe_cast(longitude as float64) as longitude,
card_id,
business_id,
product_ids,
user_id,
declined
from `sprint3-analytics-bieldomenech.sprint3_bronze.transactions_raw`;

-- Exercici 3: Unificació d'Usuaris (UNION)

create or replace table `sprint3-analytics-bieldomenech.sprint3_silver.users_combined` as
select id as user_id,
name,
surname,
phone,
email,
birth_date,
country,
city,
postal_code,
address,
'America' as origin
from `sprint3-analytics-bieldomenech.sprint3_bronze.american_users_raw`

union all

select id as user_id,
name,
surname,
phone,
email,
birth_date,
country,
city,
postal_code,
address,
'Europe' as origin
from `sprint3-analytics-bieldomenech.sprint3_bronze.european_users_raw`;

-- Exercici 4: Materialització de Companyies i Targetes de Crèdit

create or replace table `sprint3-analytics-bieldomenech.sprint3_silver.companies_clean` as
select company_id,
company_name,
phone,
email,
country,
website
from `sprint3-analytics-bieldomenech.sprint3_bronze.companies_raw`;

create or replace table `sprint3-analytics-bieldomenech.sprint3_silver.credit_cards_clean` as
select id as card_id,
user_id,
iban,
pan,
pin,
cvv,
track1,
track2,
expiring_date
from `sprint3-analytics-bieldomenech.sprint3_bronze.credit_cards_raw`;

-- NIVELL 3: Presentació de Dades i Creació de Vistes
-- Exercici 1: La Vista de Màrqueting (Lògica de Negoci)

create or replace view `sprint3-analytics-bieldomenech.sprint3_gold.v_marketing_kpis` as
select c.company_name as Nom_Empresa,
c.phone as Telefon,
c.country as Pais,
round(avg(t.amount),2) as Preu_Mitja,
case when avg(t.amount) > 260 then 'Premium'
else 'Standard'
end as Nivell_Client
from `sprint3-analytics-bieldomenech.sprint3_silver.companies_clean` as c
left join `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean` as t
on c.company_id = t.business_id and t.declined = 0
group by c.company_name, c.phone, c.country;

select *
from `sprint3-analytics-bieldomenech.sprint3_gold.v_marketing_kpis`
order by Nivell_Client, Preu_Mitja desc;


-- Exercici 2: Rànquing de Productes (La Potència dels Arrays)

create or replace table `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean` as
select id as transaction_id, amount, timestamp, lat, longitude, card_id, business_id, user_id,
       declined,
       array(
           select cast(trim(id) as int64)
           from unnest(split(product_ids, ',')) id
       ) as product_ids
from `sprint3-analytics-bieldomenech.sprint3_bronze.transactions_raw`;

create or replace table `sprint3-analytics-bieldomenech.sprint3_gold.product_sales_ranking` as
with transaccions_aplanades as (
    select id as product_id
    from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean` as t
    cross join unnest(t.product_ids) as id
)
select p.product_id as Producte_id, p.name as Nom, p.price as Preu, p.colour as Color, count(e.product_id) as total_venut
from `sprint3-analytics-bieldomenech.sprint3_silver.products_clean` as p
left join transaccions_aplanades as e
on p.product_id = e.product_id
group by p.product_id, p.name, p.price, p.colour;

-- Exercici 3: Exportació de Resultats

select * from `sprint3-analytics-bieldomenech.sprint3_gold.product_sales_ranking`;
