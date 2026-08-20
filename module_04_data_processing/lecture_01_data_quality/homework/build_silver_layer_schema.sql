/*
SQL-скрипт создаёт схему и пустые таблицы серебряного слоя с корректными типами данных
для будущей работы базы данных.
 */

CREATE SCHEMA silver;

CREATE TABLE silver.silver_countries (
	country_id SMALLINT,
	country_name VARCHAR(50),
	country_code CHAR(2)
);

CREATE TABLE silver.silver_cities (
	city_id SMALLINT,
	city_name VARCHAR(50),
	zipcode INT,
	country_id SMALLINT
);

CREATE TABLE silver.silver_categories (
	category_id SMALLINT,
	category_name VARCHAR(50)
);

CREATE TABLE silver.silver_products (
	product_id SMALLINT,
	product_name VARCHAR(50),
	price NUMERIC(10, 2),
	category_id SMALLINT,
	"class" CHAR(1),
	modify_timestamp TIMESTAMP,
	resistant BOOLEAN,
	is_allergic BOOLEAN,
	vitality_days SMALLINT
);

CREATE TABLE silver.silver_shops (
	shop_id SMALLINT,
	city_id SMALLINT,
	address VARCHAR(50)
);

CREATE TABLE silver.silver_employees (
	employee_id SMALLINT,
	first_name VARCHAR(50),
	middle_initial CHAR(1),
	last_name VARCHAR(50),
	birth_date DATE,
	gender CHAR(1),
	city_id SMALLINT,
	shop_id SMALLINT,
	hire_date DATE
);

CREATE TABLE silver.silver_customers (
	customer_id INT,
	first_name VARCHAR(50),
	middle_initial CHAR(1),
	last_name VARCHAR(50),
	city_id SMALLINT,
	address VARCHAR(50)
);

CREATE TABLE silver.silver_sales (
	sales_id BIGINT,
	employee_id SMALLINT,
	customer_id INT,
	product_id SMALLINT,
	quantity SMALLINT,
	discount NUMERIC(10, 2),
	total_price NUMERIC(10, 2),
	sales_timestamp TIMESTAMP,
	transaction_number CHAR(11),
	shop_id SMALLINT,
	city_id SMALLINT
);
