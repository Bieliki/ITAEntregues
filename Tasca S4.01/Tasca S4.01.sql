-- NIVELL 1 Entorn i Ingesta Híbrida (Code-First)
-- Exercici 1: Consulta sobre Taula no Optimitzada (Diagnòstic)

select t.transaction_id, t.timestamp, t.amount, c.company_name, c.country
from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean` as t
join `sprint3-analytics-bieldomenech.sprint3_silver.companies_clean` as c
on t.business_id= c.company_id
where t.timestamp = '2022-03-12' and c.country = 'Germany' and t.declined = 0;

-- Exercici 2: Re-arquitectura i Optimització de l'Emmagatzematge (Partition & Cluster)
-- Pas 1: Generació de Dades Recents (Mocking Data)

create or replace table 'sprint3-analytics-bieldomenech.sprint3_silver.transactions_recent' as
select * except(timestamp),
    timestamp_sub(
        current_timestamp(),
        interval cast (rand() * 50 as int64) day
    ) as timestamp
from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean`;

-- Pas 2: Creació de la Taula Optimitzada (Partitioning & Clustering)

create or replace table `sprint3-analytics-bieldomenech.sprint3_gold.fact_transactions_optimized`
partition by date(timestamp)
cluster by business_id as
select *
from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_recent`;

-- Exercici 3: La Prova del Cotó (Benchmark)

select *
from `sprint3-analytics-bieldomenech…`
where date(timestamp) >= date_sub(current_date(), interval 30 day) and declined = 0;

-- Pas 1 (Taula no optimitzada):

select *
from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_recent`
where date(timestamp) >= date_sub(current_date(), interval 30 day) and declined = 0;

-- Pas 2 (Taula optimitzada):

select *
from `sprint3-analytics-bieldomenech.sprint3_gold.fact_transactions_optimized`
where date(timestamp) >= date_sub(current_date(), interval 30 day) and declined = 0;

-- Exercici 4: Smart Caching (Vistes Materialitzades)

create or replace materialized view `sprint3-analytics-bieldomenech.sprint3_gold.mv_daily_sales` as
select date(timestamp) as Sale_Date, sum(amount) as Total_Sales
from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean`
where declined = 0
group by date(timestamp);


select Sale_Date, round(Total_Sales, 2) as Total_Sales
from `sprint3-analytics-bieldomenech.sprint3_gold.mv_daily_sales`
order by Sale_Date desc;

-- NIVELL 2 SQL Analític Avançat
-- Exercici 1: Perfilat de Clients VIP (Mètriques Agregades amb CTEs)

with vip_stats as (
  select tr.user_id, sum(tr.amount) as total_gastat, count(*) as num_compres, round(avg(tr.amount), 2) as tiquet_mig, max(tr.amount) as max_compra
  from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean` as tr
  where tr.declined = 0
  group by tr.user_id
  having sum(tr.amount) > 500
)

select v.user_id as Usuari_ID, concat(u.name, ' ', u.surname) as Nom_Complet, u.email, v.num_compres as Quantitat_de_Transaccions, v.tiquet_mig as Ticket_Mitja, v.max_compra as Compra_Maxima,
  round(v.total_gastat, 2) as Despesa_Total
from vip_stats as v
join `sprint3-analytics-bieldomenech.sprint3_silver.users_combined` as u
on v.user_id = u.user_id
order by v.total_gastat desc;

-- Exercici 2: Anàlisi de Tendències (Window Functions sobre Vistes)

select
  sale_date as Data,
  round(total_sales, 2) as Vendes_Avui,
  round(lag(total_sales) over (order by sale_date), 2) as Vendes_Ahir,
  round(
    ( (total_sales - lag(total_sales) over (order by sale_date))
      / lag(total_sales) over (order by sale_date) ) * 100, 2) as Diff_Percentual
from
  `sprint3-analytics-bieldomenech.sprint3_gold.mv_daily_sales`
order by sale_date;

-- Exercici 3: Totals Acumulats (Running Totals sobre Vistes)

select sale_date as Data,
  round(total_sales, 2) as Vendes_del_Dia,
  round(
    sum(total_sales) over (
      partition by extract(year from sale_date)
      order by sale_date
      rows between unbounded preceding and current row), 2) as Vendes_Acumulades_YTD
from `sprint3-analytics-bieldomenech.sprint3_gold.mv_daily_sales`
order by sale_date;

-- Exercici 4: Fidelització i Valor del Client (Filtratge Avançat)

with primeres_compres_usuari as (
  select
    t.user_id,
    concat(u.name, ' ', u.surname) as nom_complet,
    u.email,
    t.timestamp as data_compra,
    t.amount,
    row_number() over (
      partition by t.user_id
      order by t.timestamp
    ) as numero_compra
  from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean` as t
  join `sprint3-analytics-bieldomenech.sprint3_silver.users_combined` as u
  on t.user_id = u.user_id
  where t.declined = 0
  qualify numero_compra <= 3
),

tercera_compra_usuari as (
  select *
  from primeres_compres_usuari
  where numero_compra = 3
)

select
  p.user_id as Usuari_ID,
  p.nom_complet as Nom_Complet,
  p.email as Email,
  t.data_compra as Data_3a_Compra,
  round(t.amount, 2) as Import_3a_Compra,
  round(avg(p.amount), 2) as Mitjana_3_Primers
from primeres_compres_usuari as p
join tercera_compra_usuari as t
  on p.user_id = t.user_id
group by p.user_id, p.nom_complet, p.email, t.data_compra, t.amount
order by data_3a_compra;

-- NIVELL 3
-- Exercici 1: Desanidament i Aplanament de Dades (Unnesting)

create or replace table `sprint3-analytics-bieldomenech.sprint3_gold.dim_transactions_flat` as
select
  t.transaction_id as Transaccio,
  t.timestamp as Data,
  round(t.amount, 2) as Tickets_Totals,
  p.product_id as Producte_ID,
  p.name as Nom_Producte,
  p.price as Preu_Producte
from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean` as t
cross join unnest(t.product_ids) as product_id
join `sprint3-analytics-bieldomenech.sprint3_silver.products_clean` as p
on product_id = p.product_id
where t.declined = 0;

-- Exercici 2: El Rànquing de Vendes (Agregació Simple)

select Nom_Producte, count(*) as Unitats_Venudes
from `sprint3-analytics-bieldomenech.sprint3_gold.dim_transactions_flat`
group by Nom_Producte
order by Unitats_Venudes desc
limit 5;

-- Exercici 3: Automatització del Pipeline i Visualització

create schema if not exists `sprint3-analytics-bieldomenech.udf`
options (location="EU");

create or replace function `sprint3-analytics-bieldomenech.udf.calculate_tax`(amount FLOAT64)
returns FLOAT64
as (amount * 1.21);

create or replace table `sprint3-analytics-bieldomenech.sprint3_gold.dim_transactions_flat` as
select
  t.transaction_id as Transaccio,
  t.timestamp as Data,
  round(t.amount, 2) as Tickets_Totals,
  product_id as Producte_ID,
  p.name as Nom_Producte,
  p.price as Preu_Producte,
  round(`sprint3-analytics-bieldomenech.udf.calculate_tax`(p.price), 2) as Preu_Producte_IVA
from `sprint3-analytics-bieldomenech.sprint3_silver.transactions_clean` as t
cross join unnest(t.product_ids) as product_id
join `sprint3-analytics-bieldomenech.sprint3_silver.products_clean` as p
on product_id = p.product_id
where t.declined = 0;


