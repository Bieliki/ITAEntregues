-- Nivell 1
-- Exercici 1
-- A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules.
-- Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen.
-- Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.


CREATE DATABASE IF NOT EXISTS transactions;
USE transactions;

CREATE TABLE IF NOT EXISTS company (
    id VARCHAR(15) PRIMARY KEY,
    company_name VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(100),
    country VARCHAR(100),
    website VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS transaction (
    id VARCHAR(255) PRIMARY KEY,
    credit_card_id VARCHAR(15) REFERENCES credit_card(id),
    company_id VARCHAR(20),
    user_id INT REFERENCES user(id),
    lat FLOAT,
    longitude FLOAT,
    timestamp TIMESTAMP,
    amount DECIMAL(10, 2),
    declined BOOLEAN,
    FOREIGN KEY (company_id) REFERENCES company(id)
);

SHOW COLUMNS FROM company;
SHOW COLUMNS FROM transaction;

SHOW CREATE TABLE transaction;

ALTER TABLE transaction DROP FOREIGN KEY transaction_ibfk_1;

ALTER TABLE company
    CHANGE COLUMN id company_id varchar(10) NOT NULL,
    MODIFY COLUMN company_name varchar(255) NOT NULL,
    MODIFY COLUMN phone varchar(20);

ALTER TABLE transaction
    CHANGE COLUMN id transaction_id varchar(36) NOT NULL,
    MODIFY COLUMN company_id varchar(10) NOT NULL,
    MODIFY COLUMN lat decimal(11,8),
    MODIFY COLUMN longitude decimal(11,8),
    MODIFY COLUMN amount decimal(10,2),
    MODIFY COLUMN timestamp timestamp NOT NULL,
    MODIFY COLUMN user_id int NOT NULL;

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_company
FOREIGN KEY (company_id) REFERENCES company (company_id);

-- Exercici 2
-- Utilitzant JOIN realitzaràs les següents consultes:
-- Llistat dels països que estan generant vendes.

SELECT DISTINCT c.country AS Països
FROM company AS c
JOIN transaction AS t ON c.company_id = t.company_id
WHERE t.declined = 0 AND c.country IS NOT NULL;

-- Des de quants països es generen les vendes.

SELECT COUNT(DISTINCT c.country) AS Total_Països
FROM company AS c
JOIN transaction AS t ON c.company_id =t.company_id
WHERE t.declined = 0;

-- Identifica la companyia amb la mitjana més gran de vendes.

SELECT c.company_id AS IDCompanyia, c.company_name AS Companyia, ROUND(AVG(t.amount),2) AS Mitjana_vendes
FROM company AS c
JOIN transaction AS t ON c.company_id =t.company_id
WHERE t.declined = 0
GROUP BY c.company_id, c.company_name
ORDER BY ROUND(AVG(t.amount),2) DESC
LIMIT 1;

-- Exercici 3
-- Utilitzant només subconsultes (sense utilitzar JOIN):
-- Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT t.transaction_id AS Transaccions
FROM transaction AS t
WHERE EXISTS (SELECT c.company_id
                FROM company AS c
                WHERE t.company_id = c.company_id AND c.country = 'Germany') AND t.declined = 0;

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT c.company_id AS IDCompanyia, c.company_name AS Companyia
FROM company AS c
WHERE EXISTS (SELECT t.company_id
                        FROM transaction AS t
                        WHERE t.company_id = c.company_id AND t.declined = 0 AND t.amount > (SELECT ROUND(AVG(t.amount), 2)
                                                                                                FROM transaction AS t
                                                                                                WHERE t.declined = 0));

-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT c.company_id AS IDCompanyia, c.company_name AS Companyia
FROM company AS c
WHERE NOT EXISTS (SELECT t.company_id
                            FROM transaction AS t
                            WHERE c.company_id = t.company_id);

-- Exercici 4
-- La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les
-- targetes de crèdit.
-- La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les
-- altres dues taules ("transaction" i "company").
-- Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit".
-- Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.

USE transactions;
CREATE TABLE IF NOT EXISTS credit_card (
    id varchar(15) PRIMARY KEY,
    iban varchar(34),
    pan varchar(20),
    pin varchar(4),
    cvv varchar(3),
    expiring_date varchar(10)
);

SHOW COLUMNS FROM credit_card;

UPDATE credit_card SET expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%y');
ALTER TABLE credit_card MODIFY expiring_date DATE;

ALTER TABLE credit_card CHANGE COLUMN id credit_card_id varchar(15);

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_creditcard
FOREIGN KEY (credit_card_id) REFERENCES credit_card (credit_card_id);

-- Exercici 5
-- El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit
-- amb ID CcU-2938.
-- La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999.
-- Recorda mostrar que el canvi es va realitzar.

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE credit_card.credit_card_id = 'CcU-2938';

SELECT iban
FROM credit_card
WHERE credit_card.credit_card_id = 'CcU-2938';

-- Exercici 6
-- En la taula "transaction" ingressa una nova transacció amb la següent informació:

-- Id
-- 108B1D1D-5B23-A76C-55EF-C568E49A99DD

-- credit_card_id
-- CcU-9999

-- company_id
-- b-9999

-- user_id
-- 9999

-- lat
-- 829.999

-- longitude
-- -117.999

-- amount
-- 111.11

-- declined
-- 0

INSERT INTO credit_card (credit_card_id)
VALUES ('CcU-9999');

INSERT INTO company (company_id, company_name)
VALUES ('b-9999', 'Inventa Turba');

INSERT INTO transaction
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, '829.999', '-117.999', NOW(), 111.11, 0);

-- Exercici 7
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card.
-- Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card
DROP COLUMN pan;

SHOW COLUMNS FROM credit_card;

-- Exercici 8
-- Descarrega els arxius CSV que trobaràs a l'apartat de recursos:

-- american_users.csv
-- european_users.csv
-- companies.csv
-- credit_cards.csv
-- transactions.csv
-- Estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis
-- realitzar les següents consultes:

CREATE DATABASE if NOT EXISTS financial_db;

USE financial_db;

CREATE TABLE IF NOT EXISTS companies
(
    company_id varchar(255),
    company_name varchar(255),
    phone varchar(255),
    email varchar(255),
    country varchar(255),
    website varchar(255)
);
CREATE TABLE IF NOT EXISTS operations
(
    id varchar(255),
    card_id varchar(255),
    business_id varchar(255),
    timestamp varchar(255),
    amount varchar(255),
    declined varchar(255),
    product_ids varchar(255),
    user_id varchar(255),
    lat varchar(255),
    longitude varchar(255)
);

CREATE TABLE IF NOT EXISTS credit_cards
(
    id varchar(255),
    user_id varchar(255),
    iban varchar(255),
    pan varchar(255),
    pin varchar(255),
    cvv varchar(255),
    track1 varchar(255),
    track2 varchar(255),
    expiring_date varchar(255)
);

CREATE TABLE IF NOT EXISTS users
(
    id varchar(255),
    name varchar(255),
    surname varchar(255),
    phone varchar(255),
    email varchar(255),
    birth_date varchar(255),
    country varchar(255),
    city varchar(255),
    postal_code varchar(255),
    address varchar(255),
    region varchar(255)
);

LOAD DATA LOCAL INFILE 'C:/Users/USUARIO/Documents/ITADataAnalysis/Data/N1-Ex.8__american_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, surname, phone, email, birth_date, country, city, postal_code, address)
SET region = 'America';

SELECT COUNT(users.id)
FROM users;

SELECT COUNT(DISTINCT id)
FROM users;

LOAD DATA LOCAL INFILE 'C:/Users/USUARIO/Documents/ITADataAnalysis/Data/N1.Ex.8__european_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, surname, phone, email, birth_date, country, city, postal_code, address)
SET region = 'Europe';

SELECT COUNT(users.id)
FROM users
WHERE region = 'Europe';

LOAD DATA LOCAL INFILE 'C:/Users/USUARIO/Documents/ITADataAnalysis/Data/N1.Ex.8__companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(company_id)
FROM companies;

SELECT COUNT(DISTINCT company_id)
FROM companies;

LOAD DATA LOCAL INFILE 'C:/Users/USUARIO/Documents/ITADataAnalysis/Data/N1.Ex.8__credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(id)
FROM credit_cards;

SELECT COUNT(DISTINCT id)
FROM credit_cards;

LOAD DATA LOCAL INFILE 'C:/Users/USUARIO/Documents/ITADataAnalysis/Data/N1.Ex.8__transactions.csv'
INTO TABLE operations
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(id)
FROM operations;

SELECT COUNT(DISTINCT id)
FROM operations;

ALTER TABLE users RENAME COLUMN id TO user_id;

SHOW COLUMNS FROM users;

ALTER TABLE credit_cards RENAME COLUMN id TO card_id;

SHOW COLUMNS FROM credit_cards;

ALTER TABLE operations RENAME COLUMN id TO operation_id;

ALTER TABLE operations RENAME COLUMN business_id TO company_id;

SHOW COLUMNS FROM operations;

UPDATE Users
SET birth_date = DATE_FORMAT(STR_TO_DATE(birth_date, '%b %d, %Y'), '%Y-%m-%d')
WHERE birth_date LIKE '% % %';

UPDATE credit_cards
SET expiring_date = DATE_FORMAT(STR_TO_DATE(expiring_date, '%m/%d/%y'), '%Y-%m-%d')
WHERE expiring_date LIKE '%/%/%';

UPDATE users SET
    user_id = TRIM(user_id),
    name = TRIM(name),
    surname = TRIM(surname),
    phone = TRIM(phone),
    email = LOWER(TRIM(email)),
    birth_date = TRIM(birth_date),
    country = TRIM(country),
    city = TRIM(city),
    postal_code = TRIM(postal_code),
    address = TRIM(address),
    region = TRIM(region);

UPDATE companies SET
    company_id = TRIM(company_id),
    company_name = TRIM(company_name),
    phone = TRIM(phone),
    email = LOWER(TRIM(email)),
    country = TRIM(country),
    website = LOWER(TRIM(website));

UPDATE credit_cards SET
    card_id = TRIM(card_id),
    user_id = TRIM(user_id),
    iban = TRIM(iban),
    pan = TRIM(pan),
    pin = TRIM(pin),
    cvv = TRIM(cvv),
    track1 = TRIM(track1),
    track2 = TRIM(track2),
    expiring_date = TRIM(expiring_date);

UPDATE operations SET
    operation_id = TRIM(operation_id),
    card_id = TRIM(card_id),
    company_id = TRIM(company_id),
    timestamp = TRIM(timestamp),
    amount = TRIM(amount),
    declined = TRIM(declined),
    product_ids = TRIM(product_ids),
    user_id = TRIM(user_id),
    lat = TRIM(lat),
    longitude = TRIM(longitude);

ALTER TABLE users
    MODIFY COLUMN user_id int NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN name varchar(100) NOT NULL,
    MODIFY COLUMN surname varchar(100) NOT NULL,
    MODIFY COLUMN phone varchar(20),
    MODIFY COLUMN email varchar(150) NOT NULL,
    MODIFY COLUMN birth_date DATE NOT NULL,
    MODIFY COLUMN country varchar(100),
    MODIFY COLUMN city varchar(100),
    MODIFY COLUMN postal_code varchar(20),
    MODIFY COLUMN address varchar(255),
    MODIFY COLUMN region varchar(25),
    ADD PRIMARY KEY (user_id);

SHOW COLUMNS FROM users;

ALTER TABLE companies
    MODIFY COLUMN company_id varchar(10) NOT NULL,
    MODIFY COLUMN company_name varchar(100) NOT NULL,
    MODIFY COLUMN phone varchar(20),
    MODIFY COLUMN email varchar(150) NOT NULL,
    MODIFY COLUMN country varchar(100),
    MODIFY COLUMN website varchar(250),
    ADD PRIMARY KEY (company_id);

SHOW COLUMNS FROM companies;

ALTER TABLE credit_cards
    MODIFY COLUMN card_id varchar(10) NOT NULL,
    MODIFY COLUMN user_id int NOT NULL,
    MODIFY COLUMN iban varchar(34) NOT NULL,
    MODIFY COLUMN pan varchar(20) NOT NULL,
    MODIFY COLUMN pin varchar(5) NOT NULL,
    MODIFY COLUMN cvv varchar(4) NOT NULL,
    MODIFY COLUMN track1 varchar(250),
    MODIFY COLUMN track2 varchar(250),
    MODIFY COLUMN expiring_date DATE NOT NULL,
    ADD PRIMARY KEY (card_id);

SHOW COLUMNS FROM credit_cards;

ALTER TABLE operations
    MODIFY COLUMN operation_id varchar(40) NOT NULL,
    MODIFY COLUMN card_id varchar(10) NOT NULL,
    MODIFY COLUMN company_id varchar(10) NOT NULL,
    MODIFY COLUMN timestamp datetime NOT NULL,
    MODIFY COLUMN amount decimal(10,2) NOT NULL,
    MODIFY COLUMN declined boolean NOT NULL,
    MODIFY COLUMN product_ids varchar(250),
    MODIFY COLUMN user_id int NOT NULL,
    MODIFY COLUMN lat decimal(11,8),
    MODIFY COLUMN longitude decimal(11,8),
    ADD PRIMARY KEY (operation_id);

ALTER TABLE operations
    MODIFY COLUMN operation_id varchar(40) NOT NULL,
    MODIFY COLUMN card_id varchar(10) NOT NULL,
    MODIFY COLUMN company_id varchar(10) NOT NULL,
    MODIFY COLUMN timestamp datetime NOT NULL,
    MODIFY COLUMN amount decimal(10,2) NOT NULL,
    MODIFY COLUMN declined boolean NOT NULL,
    MODIFY COLUMN product_ids varchar(250),
    MODIFY COLUMN user_id int NOT NULL,
    MODIFY COLUMN lat decimal(18,15),
    MODIFY COLUMN longitude decimal(18,15);

SHOW COLUMNS FROM operations;

ALTER TABLE operations
    ADD CONSTRAINT fk_operations_users
    FOREIGN KEY (user_id) REFERENCES users(user_id);

ALTER TABLE operations
    ADD CONSTRAINT fk_operations_companies
    FOREIGN KEY (company_id) REFERENCES companies(company_id);

ALTER TABLE operations
    ADD CONSTRAINT fk_operations_cards
    FOREIGN KEY (card_id) REFERENCES credit_cards(card_id);

SHOW COLUMNS FROM operations;

USE financial_db;

-- Exercici 9
-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.

SELECT u.user_id AS ID_Usuari, u.name AS Nom, u.surname AS Cognom, t.Numero_Transaccions
FROM users AS u
JOIN (SELECT o.user_id, COUNT(o.operation_id) AS Numero_Transaccions
        FROM operations AS o
        WHERE o.declined = 0
        GROUP BY o.user_id
        HAVING COUNT(o.operation_id) > 80) AS t
ON u.user_id = t.user_id;

-- Exercici 10
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

SELECT c.company_name AS Nom_Empresa, cc.card_id AS ID_Targeta, cc.iban AS IBAN, ROUND(AVG(o.amount),2) AS Mitjana_Quantitat
FROM credit_cards AS cc
JOIN operations AS o ON cc.card_id = o.card_id
JOIN companies AS c ON c.company_id = o.company_id
WHERE c.company_name = 'Donec Ltd' AND o.declined = 0
GROUP BY cc.card_id,c.company_name, cc.iban;

-- Nivell 2
-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes.
-- Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE(o.timestamp) AS Dies, ROUND(SUM(o.amount),2) AS Total_Vendes
FROM operations AS o
WHERE o.declined = 0
GROUP BY DATE (o.timestamp)
ORDER BY Total_Vendes DESC
LIMIT 5;

-- Exercici 2
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès
-- entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024.
-- Ordena els resultats de major a menor quantitat.

SELECT c.company_name AS Companyia, c.phone AS Telèfon, c.country AS País, DATE(o.timestamp) AS Data, ROUND(o.amount,2) AS Quantitat
FROM companies AS c
JOIN operations AS o ON c.company_id = o.company_id
WHERE (ROUND(o.amount,2) BETWEEN 350 AND 400) AND (DATE(o.timestamp) = '2015-04-29' OR DATE(o.timestamp) = '2018-07-20' OR DATE(o.timestamp) = '2024-03-13') AND o.declined = 0
ORDER BY ROUND(o.amount,2) DESC;

-- Exercici 3
-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
-- per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses,
-- però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de
-- 400 transaccions o menys.

SELECT c.company_id AS ID_Empresa, c.company_name AS Nom, COUNT(o.operation_id) AS Operacions,
       CASE
            WHEN COUNT(o.operation_id) < 400 THEN 'Menys de 400 transaccions'
            WHEN COUNT(o.operation_id) = 400 THEN '400 transaccions'
            ELSE 'Més de 400 transaccions'
       END AS Transaccions
FROM companies AS c
JOIN operations AS o ON c.company_id = o.company_id
WHERE o.declined = 0
GROUP BY c.company_id, c.company_name;

-- Exercici 4
-- Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE FROM operations WHERE operation_id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT * FROM operations WHERE operation_id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

-- Exercici 5
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives.
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions.
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació:
-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia.
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS
SELECT c.company_id AS ID_Empresa, c.company_name AS Nom, c.phone AS Telèfon, c.country AS País, ROUND(AVG(o.amount),2) AS Mitjana_de_Compra
FROM companies AS c
JOIN operations AS o ON c.company_id = o.company_id
WHERE o.declined = 0
GROUP BY c.company_id, c.company_name, c.phone, c.country
ORDER BY Mitjana_de_Compra DESC;

SELECT * FROM VistaMarketing;

-- Nivell 3
-- Exercici 1
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han
-- estat declinades aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:

WITH OrdreOperacions AS (SELECT card_id, declined,
                                ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS posicio
                                FROM operations),
EstatTargetes AS (SELECT card_id,
                    CASE
                        WHEN SUM(declined) = 3 AND COUNT(*) = 3 THEN 'Inactiva'
                        ELSE 'Activa'
                    END AS estat
                    FROM OrdreOperacions
                    WHERE posicio <= 3
                    GROUP BY card_id)

-- 👉 Quantes targetes estan actives?

SELECT COUNT(*) AS Total_Targetes_Actives
FROM EstatTargetes
WHERE estat = 'Activa';

-- Exercici 2
-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, tenint en
-- compte que des de transaction tens product_ids. Genera la següent consulta:

USE financial_db;
CREATE TABLE IF NOT EXISTS products
(
    id varchar(255),
    product_name varchar(255),
    price varchar(255),
    colour varchar(255),
    weight varchar(255),
    warehouse_id varchar(255)
);

LOAD DATA LOCAL INFILE 'C:/Users/USUARIO/Documents/ITADataAnalysis/Data/N3.Ex.2__products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(id)
FROM products;

SELECT COUNT(DISTINCT id)
FROM products;

UPDATE products SET price = REPLACE(price, '$', '')
WHERE LOCATE('$', price) > 0;

SELECT price
FROM products;

UPDATE products SET warehouse_id = REPLACE(warehouse_id, '--', '-')
WHERE LOCATE('--', warehouse_id) > 0;

SELECT warehouse_id
FROM products;

UPDATE products SET
    id = TRIM(id),
    product_name = TRIM(product_name),
    price = TRIM(price),
    colour = TRIM(colour),
    weight = TRIM(weight),
    warehouse_id = TRIM(warehouse_id)
WHERE
    LENGTH(id) <> LENGTH(TRIM(id)) OR
    LENGTH(product_name) <> LENGTH(TRIM(product_name)) OR
    LENGTH(price) <> LENGTH(TRIM(price)) OR
    LENGTH(colour) <> LENGTH(TRIM(colour)) OR
    LENGTH(weight) <> LENGTH(TRIM(weight)) OR
    LENGTH(warehouse_id) <> LENGTH(TRIM(warehouse_id));

ALTER TABLE products RENAME COLUMN id TO product_id;

SHOW COLUMNS FROM products;

ALTER TABLE products
    MODIFY COLUMN product_id int NOT NULL AUTO_INCREMENT,
    MODIFY COLUMN product_name varchar(100) NOT NULL,
    MODIFY COLUMN price decimal(10,2) NOT NULL ,
    MODIFY COLUMN colour varchar(10) NOT NULL,
    MODIFY COLUMN weight decimal(10,2),
    MODIFY COLUMN warehouse_id varchar(10),
    ADD PRIMARY KEY (product_id);

SHOW COLUMNS FROM products;

CREATE TABLE IF NOT EXISTS operations_products
(
    operation_product_id int AUTO_INCREMENT,
    operation_id varchar(40),
    product_id int,
    PRIMARY KEY (operation_product_id)
);

SELECT MAX(LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',', '')) + 1) AS max_productes
FROM operations;

START TRANSACTION;
INSERT INTO operations_products (operation_id, product_id)
SELECT operation_id, TRIM(SUBSTRING_INDEX(product_ids, ',', 1))
FROM operations
WHERE product_ids IS NOT NULL AND product_ids <> '';

INSERT INTO operations_products (operation_id, product_id)
SELECT operation_id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 2), ',', -1))
FROM operations
WHERE (LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',', ''))) >= 1;

INSERT INTO operations_products (operation_id, product_id)
SELECT operation_id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 3), ',', -1))
FROM operations
WHERE (LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',', ''))) >= 2;

INSERT INTO operations_products (operation_id, product_id)
SELECT operation_id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 4), ',', -1))
FROM operations
WHERE (LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',', ''))) >= 3;

INSERT INTO operations_products (operation_id, product_id)
SELECT operation_id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', 5), ',', -1))
FROM operations
WHERE (LENGTH(product_ids) - LENGTH(REPLACE(product_ids, ',', ''))) >= 4;
COMMIT;

SELECT *
FROM operations_products
ORDER BY operation_product_id DESC
LIMIT 100;

ALTER TABLE operations_products
    ADD CONSTRAINT fk_operations_products_operations
    FOREIGN KEY (operation_id) REFERENCES operations(operation_id);

ALTER TABLE operations_products
    ADD CONSTRAINT fk_operations_products_products
    FOREIGN KEY (product_id) REFERENCES products(product_id);

SHOW COLUMNS FROM operations_products;

ALTER TABLE operations
DROP COLUMN product_ids;

SHOW COLUMNS FROM operations;

-- 👉 Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

SELECT p.product_id AS ID_Producte, p.product_name AS Nom_Producte, COUNT(op.product_id) AS Total_Vendes
FROM products AS p
JOIN operations_products AS op ON p.product_id = op.product_id
GROUP BY p.product_id, p.product_name
ORDER BY Total_Vendes DESC;