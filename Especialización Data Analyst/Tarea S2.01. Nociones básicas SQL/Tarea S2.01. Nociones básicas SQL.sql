USE transactions;

#Listado de los países que están generando ventas.
SELECT c.country, SUM(t.amount) AS total_ventas
FROM company c 
INNER JOIN transaction t 
	ON c.id = t.company_id
GROUP BY c.country
ORDER BY total_ventas DESC;

#Desde cuántos países se generan las ventas.
SELECT COUNT(DISTINCT c.country) AS cantidad_paises_activos
FROM company c 
INNER JOIN transaction t
	ON c.id = t.company_id
WHERE t.declined = 0;


#Identifica a la compañía con la mayor media de ventas.
SELECT c.company_name, AVG(t.amount) AS media_ventas
FROM company c 
INNER JOIN transaction t 
	ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.company_name
ORDER BY media_ventas DESC
LIMIT 1;

#Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT id
FROM transaction
WHERE company_id IN (
	SELECT id
    FROM company
    WHERE country = "Germany");
    
#Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
SELECT (
	SELECT company_name
    FROM company c
    WHERE c.id = t.company_id) AS company_name
FROM transaction t
WHERE t.amount > (
	SELECT AVG(amount)
    FROM transaction
    WHERE declined = 0) 
And declined = 0;

#Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
SELECT company_name, id
FROM company c
WHERE NOT EXISTS (
	SELECT company_id
    FROM transaction t
    WHERE t.company_id = c.id);
    
CREATE TABLE IF NOT EXISTS credit_card (  
id VARCHAR(15) PRIMARY KEY,     
iban VARCHAR(35),     
pan VARCHAR(25),     
pin INT,     
cvv INT,     
expiring_date VARCHAR(10)
); 

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

UPDATE credit_card
SET iban = "TR323456312213576817699999"
WHERE id = "CcU-2938";

SELECT *
FROM credit_card 
WHERE id = "CcU-2938"; 

INSERT INTO company(id, company_name, phone, email, country, website)
VALUES("b-9999", "Vizualab", "634650278", "vizualab@hotmail.com", "Italy", "www.vizualab.com");

INSERT INTO credit_card(id, iban, pan, pin, cvv, expiring_date)
VALUES("CcU-9999", "XX5559590368835304645278", "3140880819451394", 5711, 445, "04/25/26");

INSERT INTO transaction(id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined)
VALUES ("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", 9999, 829.999, -117.999, NULL, 111.11, 0); 

SELECT *
FROM transaction
WHERE user_id = 9999; 

ALTER TABLE credit_card DROP COLUMN pan;

SELECT *
FROM credit_card;

#Creo la base de dato analyses_transactions
CREATE DATABASE IF NOT EXISTS analyses_transactions; 

USE analyses_transactions;

#Creo la tabla companies
CREATE TABLE IF NOT EXISTS companies (
company_id VARCHAR(10) PRIMARY KEY,
company_name VARCHAR(255),
phone VARCHAR(35),
email VARCHAR(100),
country VARCHAR(100),
website VARCHAR(255),
merchant_category VARCHAR(100),
merchant_price_position VARCHAR(100)
); 

#Añado los datos a la tabla companies
LOAD DATA LOCAL INFILE 'C:/Users/Federica/Downloads/N1-Ex.8__companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

#Creo la tabla credit_cards
CREATE TABLE IF NOT EXISTS credit_cards (  
id VARCHAR(15) PRIMARY KEY,  
user_id VARCHAR(15),   
iban VARCHAR(40),     
pan VARCHAR(25),     
pin INT,     
cvv INT, 
track1 VARCHAR(255),
track2 VARCHAR(255),
expiring_date DATE,
card_type VARCHAR(100),
card_renewal_flag BOOLEAN
); 

#Añado los datos en la tabla credit_cards
LOAD DATA LOCAL INFILE 'C:/Users/Federica/Downloads/N1-Ex.8__credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, user_id, iban, pan, pin, cvv, track1, track2, @expiring_date, card_type, card_renewal_flag)
SET expiring_date = STR_TO_DATE(@expiring_date, '%m/%d/%Y');

#Creo la tabla users
CREATE TABLE IF NOT EXISTS users (  
id VARCHAR(15) PRIMARY KEY,  
name VARCHAR(30),   
surname VARCHAR(40),     
phone VARCHAR(30),     
email VARCHAR(40),
birth_date DATE,
country VARCHAR(100),
city VARCHAR(100),
postal_code VARCHAR(100),
address VARCHAR(255),
signup_date DATE,
user_segment VARCHAR(100),
income_band VARCHAR(100)
); 
#Añado los datos de la tabla american_users
LOAD DATA LOCAL INFILE "C:/Users/Federica/Downloads/N1-Ex.8__american_users.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    id,
    name,
    surname,
    phone,
    email,
    @birth_date,
    country,
    city,
    postal_code,
    address,
    signup_date,
    user_segment,
    income_band
)
SET birth_date = STR_TO_DATE(@birth_date, '%b %e, %Y'); 

#Añado los datos de la tabla european_users
LOAD DATA LOCAL INFILE "C:/Users/Federica/Downloads/N1-Ex.8__european_users.csv"
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    id,
    name,
    surname,
    phone,
    email,
    @birth_date,
    country,
    city,
    postal_code,
    address,
    signup_date,
    user_segment,
    income_band
)
SET birth_date = STR_TO_DATE(@birth_date, '%b %e, %Y'); 

#Creo la tabla transactions
CREATE TABLE IF NOT EXISTS transactions (  
id VARCHAR(100) PRIMARY KEY,  
card_id VARCHAR(15),   
business_id VARCHAR(10),     
timestamp TIMESTAMP,     
amount DECIMAL(10,2),
declined BOOLEAN,
product_ids VARCHAR(100),
user_id VARCHAR(15),
lat FLOAT,
longitude FLOAT,
discount_amount DECIMAL(10,2),
tax_amount DECIMAL(10,2),
shipping_amount DECIMAL(10,2),
channel VARCHAR(20),
campaign_id VARCHAR(40),
device_type VARCHAR(40),
is_international BOOLEAN,
decline_reason VARCHAR(500),
distance_km DECIMAL(10,2),

FOREIGN KEY (card_id)
	REFERENCES credit_cards(id),
    
FOREIGN KEY (business_id)
	 REFERENCES companies(company_id),
     
FOREIGN KEY (user_id)
	REFERENCES users(id)
); 

#Añado los datos en la tabla transactions
LOAD DATA LOCAL INFILE 'C:/Users/Federica/Downloads/N1-Ex.8__transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

USE analyses_transactions;

#Realiza una subconsulta que muestre a todos los usuarios con más de 80 transacciones utilizando al menos 2 tablas.
SELECT u.id, u.name, u.surname
FROM users u
WHERE u.id IN(
	SELECT t.user_id
    FROM transactions t
    GROUP BY t.user_id
    HAVING COUNT(t.id) > 80);
    
#Muestra la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd., utiliza por lo menos 2 tablas.
SELECT cc.iban, AVG(t.amount) AS importe_medio
FROM credit_cards cc
INNER JOIN transactions t
	ON cc.id = t.card_id
	INNER JOIN companies c
		ON t.business_id = c.company_id
WHERE t.declined = FALSE and c.company_name = "Donec Ltd"
GROUP BY cc.iban
ORDER BY importe_medio DESC; 

#Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
#Muestra la fecha de cada transacción junto con el total de las ventas.
SELECT DATE(timestamp) AS date, SUM(amount) AS total_amount
FROM transactions
WHERE declined = FALSE
GROUP BY date
ORDER BY total_amount DESC
LIMIT 5; 

#Presenta el nombre, teléfono, país, fecha y amount, 
#de aquellas empresas que realizaron transacciones con un valor comprendido entre 350 y 400 euros y 
#en alguna de estas fechas: 29 de abril de 2015, 20 de julio de 2018 y 13 de marzo de 2024. Ordena los resultados de mayor a menor cantidad.
SELECT c.company_name, 
	c.phone, 
	c.country, 
	DATE(t.timestamp)AS date, 
	t.amount
FROM companies c
INNER JOIN transactions t
	ON c.company_id = t.business_id
WHERE (declined = FALSE) AND(t.amount BETWEEN 350 AND 400) 
	AND (DATE(t.timestamp) = "2025-04-29" 
		OR DATE(t.timestamp) = "2018-07-20" 
			OR DATE(t.timestamp) = "2024-03-13")
ORDER BY amount DESC;

#Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, 
#por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, 
#pero el departamento de recursos humanos es exigente y quiere un listado de las empresas en las que especifiques si tienen igual o 
#más de 400 transacciones o menos.
SELECT c.company_id, c.company_name, COUNT(t.id) AS quantity_transactions,
CASE 
    WHEN COUNT(t.id) >= 400 THEN "More 400"
    ELSE "Less 400"
END AS transaction_classification
FROM companies c
INNER JOIN transactions t 
	ON c.company_id = t.business_id
WHERE t.declined = FALSE
GROUP BY c.company_id
ORDER BY quantity_transactions DESC; 

DELETE FROM transactions WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD"; 

#La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas. 
#Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. 
#Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información: Nombre de la compañía. 
#Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía. 
#Presenta la vista creada, ordenando los datos de mayor a menor promedio de compra.

CREATE VIEW VistaMarketing AS
SELECT c.company_id, c.company_name, c.phone, c.country, ROUND(AVG(t.amount), 2) AS avg_amount
FROM companies c
INNER JOIN transactions t
	ON c.company_id = t.business_id
WHERE declined = FALSE
GROUP BY c.company_id
ORDER BY avg_amount DESC;

SELECT * FROM analyses_transactions.vistamarketing;


#Crea una nueva tabla que refleje el estado de las tarjetas de crédito 
#basado en si las tres últimas transacciones han sido declinadas entonces es inactivo, 
#si por lo menos una no es rechazada entonces es activo. Partiendo de esta tabla responde:
#👉 ¿Cuántas tarjetas están activas?
CREATE TABLE card_status AS
SELECT card_id,
CASE
	WHEN SUM(declined) = 3 THEN "Inactivo"
	ELSE "Activo"
END AS estado_tarjeta 
FROM (
    SELECT card_id, timestamp, declined,
	ROW_NUMBER()  OVER (
    PARTITION BY card_id
    ORDER BY timestamp DESC ) AS num_transaccion
FROM transactions) AS subconsulta
WHERE num_transaccion IN (1, 2, 3)
GROUP BY card_id; 

SELECT estado_tarjeta, COUNT(estado_tarjeta) AS cantidad_tarjetas
FROM card_status
WHERE estado_tarjeta = "Activo"; 


#Crea una tabla con la que podamos unir los datos del archivo de products.csv 
#con la base de datos creada (ya que hasta ahora no podíamos hacerlo), 
#teniendo en cuenta que desde transaction tienes product_ids. Genera la siguiente consulta:
#👉 Necesitamos conocer el número de veces que se ha vendido cada producto.
CREATE TABLE IF NOT EXISTS products (
	id VARCHAR(15) PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    colour VARCHAR(20),
    weight FLOAT,
    warehouse_id VARCHAR(30),
    category VARCHAR(30),
    brand VARCHAR(30),
    cost DECIMAL(10,2),
    launch_date DATE
); 

LOAD DATA LOCAL INFILE "C:/Users/Federica/Downloads/N1-Ex.8__products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
   id,
   product_name,
   @price,
   colour,
   weight,
   warehouse_id,
   category,
   brand,
   @cost,
   launch_date
)
SET 
price = REPLACE(REPLACE(@price, '$', ''), ',', ''),
cost = REPLACE(REPLACE(@cost, '$', ''), ',', ''); 

SELECT p.id, p.product_name, COUNT(t.id) AS total_ventas
FROM products p
LEFT JOIN transactions t
	ON FIND_IN_SET(p.id, REPLACE(t.product_ids, ' ', '')) > 0
GROUP BY p.id; 



    
