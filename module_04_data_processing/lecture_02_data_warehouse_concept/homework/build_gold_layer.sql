/*
Скрипт создания схемы gold layer.
*/

CREATE SCHEMA gold;

-- Создание таблицы измерений dim.shop
CREATE TABLE gold.dim_shop (
	shop_sk SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	shop_id SMALLINT NOT NULL UNIQUE REFERENCES silver.silver_shops(shop_id),
	shop_address VARCHAR(50) NOT NULL,
	shop_city_name VARCHAR(50) NOT NULL,
	shop_country_name VARCHAR(50) NOT NULL
);
-- Наполнение таблицы измерений dim.shop данными из таблицы серебряного слоя silver_shops, silver_cities и silver_countries
INSERT INTO gold.dim_shop (
	shop_id,
	shop_address,
	shop_city_name,
	shop_country_name
)
SELECT
	silver.silver_shops.shop_id,
	silver.silver_shops.address,
	silver.silver_cities.city_name,
	silver.silver_countries.country_name
FROM
	silver.silver_shops
INNER JOIN 
	silver.silver_cities ON silver.silver_shops.city_id = silver.silver_cities.city_id
INNER JOIN
	silver.silver_countries ON silver.silver_cities.country_id = silver.silver_countries.country_id
-- Условие обеспечения идемпотентности запроса:
ON CONFLICT (shop_id) 
DO UPDATE SET 
    shop_address = EXCLUDED.shop_address,
    shop_city_name = EXCLUDED.shop_city_name,
    shop_country_name = EXCLUDED.shop_country_name
-- Проверка на изменения, чтобы не обновлять идентичные строки
WHERE (
	gold.dim_shop.shop_address IS DISTINCT FROM EXCLUDED.shop_address
	OR
	gold.dim_shop.shop_city_name IS DISTINCT FROM EXCLUDED.shop_city_name
	OR
	gold.dim_shop.shop_country_name IS DISTINCT FROM EXCLUDED.shop_country_name
);

-- Создание таблицы измерений dim.customer
CREATE TABLE gold.dim_customer (
	customer_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	customer_id INT NOT NULL UNIQUE REFERENCES silver.silver_customers(customer_id),
	customer_first_name VARCHAR(50) NOT NULL,
	customer_middle_initial CHAR(1) NOT NULL,
	customer_last_name VARCHAR(50) NOT NULL,
	customer_address VARCHAR(50) NOT NULL,
	customer_city_name VARCHAR(50) NOT NULL,
	customer_country_name VARCHAR(50) NOT NULL
);
-- Наполнение таблицы измерений dim.customer данными из таблицы серебряного слоя silver_customers, silver_cities и silver_countries
INSERT INTO gold.dim_customer (
	customer_id,
	customer_first_name,
	customer_middle_initial,
	customer_last_name,
	customer_address,
	customer_city_name,
	customer_country_name
)
SELECT
	customer_id,
	first_name,
	middle_initial,
	last_name,
	address,
	city_name,
	country_name
FROM
	silver.silver_customers
INNER JOIN
	silver.silver_cities ON silver.silver_customers.city_id = silver.silver_cities.city_id
INNER JOIN
	silver.silver_countries ON silver.silver_cities.country_id = silver.silver_countries.country_id
-- Условие обеспечения идемпотентности запроса:
ON CONFLICT (customer_id) 
DO UPDATE SET 
    customer_first_name = EXCLUDED.customer_first_name,
    customer_middle_initial = EXCLUDED.customer_middle_initial,
    customer_last_name = EXCLUDED.customer_last_name,
    customer_address = EXCLUDED.customer_address,
    customer_city_name = EXCLUDED.customer_city_name,
    customer_country_name = EXCLUDED.customer_country_name
-- Проверка на изменения, чтобы не обновлять идентичные строки
WHERE (
	gold.dim_customer.customer_first_name IS DISTINCT FROM EXCLUDED.customer_first_name
	OR
	gold.dim_customer.customer_middle_initial IS DISTINCT FROM EXCLUDED.customer_middle_initial
	OR
	gold.dim_customer.customer_last_name IS DISTINCT FROM EXCLUDED.customer_last_name
	OR
	gold.dim_customer.customer_address IS DISTINCT FROM EXCLUDED.customer_address
	OR
	gold.dim_customer.customer_city_name IS DISTINCT FROM EXCLUDED.customer_city_name
	OR
	gold.dim_customer.customer_country_name IS DISTINCT FROM EXCLUDED.customer_country_name
);

-- Создание таблицы измерений dim.employee
CREATE TABLE gold.dim_employee (
	employee_sk SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	employee_id SMALLINT NOT NULL UNIQUE REFERENCES silver.silver_employees(employee_id),
	employee_first_name VARCHAR(50) NOT NULL,
	employee_middle_initial CHAR(1) NOT NULL,
	employee_last_name VARCHAR(50) NOT NULL,
	employee_birth_date DATE NOT NULL,
	employee_gender CHAR(1) NOT NULL,
	employee_hire_date DATE NOT NULL CHECK (employee_hire_date > employee_birth_date),
	employee_workplace_address VARCHAR(50) NOT NULL,
	employee_city_name VARCHAR(50) NOT NULL,
	employee_country_name VARCHAR(50) NOT NULL
);
-- Наполнение таблицы измерений dim.employee данными из таблиц серебряного слоя silver_employees, silver_shops, silver_cities и silver_countries
INSERT INTO gold.dim_employee (
	employee_id,
	employee_first_name,
	employee_middle_initial,
	employee_last_name,
	employee_birth_date,
	employee_gender,
	employee_hire_date,
	employee_workplace_address,
	employee_city_name,
	employee_country_name
)
SELECT
	employee_id,
	first_name,
	middle_initial,
	last_name,
	birth_date,
	gender,
	hire_date,
	address,
	city_name,
	country_name
FROM
	silver.silver_employees
INNER JOIN
	silver.silver_shops ON silver.silver_employees.shop_id = silver.silver_shops.shop_id
INNER JOIN
	silver.silver_cities ON silver.silver_shops.city_id = silver.silver_cities.city_id
INNER JOIN
	silver.silver_countries ON silver.silver_cities.country_id = silver.silver_countries.country_id
-- Условие обеспечения идемпотентности данного запроса:
ON CONFLICT (employee_id) 
DO UPDATE SET 
    employee_first_name = EXCLUDED.employee_first_name,
    employee_middle_initial = EXCLUDED.employee_middle_initial,
    employee_last_name = EXCLUDED.employee_last_name,
    employee_birth_date = EXCLUDED.employee_birth_date,
    employee_gender = EXCLUDED.employee_gender,
    employee_hire_date = EXCLUDED.employee_hire_date,
    employee_workplace_address = EXCLUDED.employee_workplace_address,
    employee_city_name = EXCLUDED.employee_city_name,
    employee_country_name = EXCLUDED.employee_country_name
-- Проверка на изменения, чтобы не обновлять идентичные строки
WHERE (
	gold.dim_employee.employee_first_name IS DISTINCT FROM EXCLUDED.employee_first_name
	OR
	gold.dim_employee.employee_middle_initial IS DISTINCT FROM EXCLUDED.employee_middle_initial
	OR
	gold.dim_employee.employee_last_name IS DISTINCT FROM EXCLUDED.employee_last_name
	OR
	gold.dim_employee.employee_birth_date IS DISTINCT FROM EXCLUDED.employee_birth_date
	OR
	gold.dim_employee.employee_gender IS DISTINCT FROM EXCLUDED.employee_gender
	OR
	gold.dim_employee.employee_hire_date IS DISTINCT FROM EXCLUDED.employee_hire_date
	OR
	gold.dim_employee.employee_workplace_address IS DISTINCT FROM EXCLUDED.employee_workplace_address
	OR
	gold.dim_employee.employee_city_name IS DISTINCT FROM EXCLUDED.employee_city_name
	OR
	gold.dim_employee.employee_country_name IS DISTINCT FROM EXCLUDED.employee_country_name
);

-- Создание таблицы измерений dim.location
CREATE TABLE gold.dim_location (
	location_sk INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	location_city_name VARCHAR(50) UNIQUE NOT NULL,
	location_country_name VARCHAR(50) NOT NULL
);
-- Наполнение таблицы измерений dim.location данными из таблиц серебряного слоя silver_cities и silver_countries
INSERT INTO gold.dim_location (
	location_city_name,
	location_country_name
)
SELECT
	city_name,
	country_name
FROM
	silver.silver_cities
INNER JOIN
	silver.silver_countries ON silver.silver_cities.country_id = silver.silver_countries.country_id
-- Условие обеспечения идемпотентности данного запроса:
ON CONFLICT (location_city_name) 
DO UPDATE SET
	location_city_name = EXCLUDED.location_city_name,
	location_country_name = EXCLUDED.location_country_name
WHERE (
	gold.dim_location.location_city_name IS DISTINCT FROM EXCLUDED.location_city_name
	OR
	gold.dim_location.location_country_name IS DISTINCT FROM EXCLUDED.location_country_name
);


-- Создание таблицы dim_date
CREATE TABLE gold.dim_date (
	date_sk INT PRIMARY KEY,
	full_date DATE NOT NULL,
	day_of_week SMALLINT NOT NULL,
	day_name VARCHAR(9) NOT NULL,
	is_weekend BOOLEAN NOT NULL,
	day_of_month SMALLINT NOT NULL,
	week_num SMALLINT NOT NULL,
	month_num SMALLINT NOT NULL,
	month_name VARCHAR(9) NOT NULL,
	quarter_num SMALLINT NOT NULL,
	year_num SMALLINT NOT NULL
);

-- Наполнение таблицы dim_date числовыми значениями
INSERT INTO gold.dim_date (
	date_sk,
	full_date,
	day_of_week,
	day_name,
	is_weekend,
	day_of_month,
	week_num,
	month_num,
	month_name,
	quarter_num,
	year_num
)
SELECT 
	-- "Умный" суррогатный ключ (формата YYYYMMDD)
	CAST(EXTRACT(YEAR FROM generate_series) * 10000 + EXTRACT(MONTH FROM generate_series) * 100 + EXTRACT(DAY FROM generate_series) AS INT),
	CAST(generate_series AS DATE),
	CAST(EXTRACT(ISODOW FROM generate_series) AS INT),
	TO_CHAR(generate_series, 'Day'),
	CASE WHEN EXTRACT(ISODOW FROM generate_series) IN (6, 7) THEN TRUE ELSE FALSE END,
	CAST(EXTRACT(DAY FROM generate_series) AS INT),
	CAST(EXTRACT(WEEK FROM generate_series) AS INT),
	CAST(EXTRACT(MONTH FROM generate_series) AS INT),
	TO_CHAR(generate_series, 'Month'),
	CAST(EXTRACT(QUARTER FROM generate_series) AS INT),
	CAST(EXTRACT(YEAR FROM generate_series) AS INT)
-- Границы временнного интервала (в днях) внутри которого могут вестись продажи (например, декада 2020 - 2029 год)
FROM generate_series(
	'2020-01-01'::TIMESTAMP, 
	'2029-12-31'::TIMESTAMP, 
	'1 day'::INTERVAL
);

-- Создание таблицы dim_time
CREATE TABLE gold.dim_time (
    time_sk CHAR(6) PRIMARY KEY,
    full_time TIME NOT NULL,
    "hour" SMALLINT NOT NULL,
    "minute" SMALLINT NOT NULL,
    "second" SMALLINT NOT NULL,
    day_part VARCHAR(50) NOT NULL
);

-- Наполнение таблицы dim_time числовыми значениями
INSERT INTO gold.dim_time (
	time_sk,
	full_time,
	"hour",
	"minute",
	"second",
	day_part
)
SELECT 
	-- "Умный" суррогатный ключ (формата HHMMSS)
	TO_CHAR(('00:00:00'::TIME + (sec * '1 second'::INTERVAL)), 'HH24MISS'),
	-- full_time
	('00:00:00'::TIME + (sec * '1 second'::INTERVAL)),
	-- часы
	EXTRACT(HOUR FROM ('00:00:00'::TIME + (sec * '1 second'::INTERVAL)))::INT,
	-- минуты
	EXTRACT(MINUTE FROM ('00:00:00'::TIME + (sec * '1 second'::INTERVAL)))::INT,
	-- секунды
	EXTRACT(SECOND FROM ('00:00:00'::TIME + (sec * '1 second'::INTERVAL)))::INT,
	-- часть дня
	CASE 
		WHEN EXTRACT(HOUR FROM ('00:00:00'::TIME + (sec * '1 second'::INTERVAL)))::INT BETWEEN 7 AND 9 THEN 'Утренний час-пик (7-9)'
		WHEN EXTRACT(HOUR FROM ('00:00:00'::TIME + (sec * '1 second'::INTERVAL)))::INT BETWEEN 9 AND 12 THEN 'Позднее утро 9-12'
		WHEN EXTRACT(HOUR FROM ('00:00:00'::TIME + (sec * '1 second'::INTERVAL)))::INT BETWEEN 12 AND 17 THEN 'Дневное время (12-17)'
		WHEN EXTRACT(HOUR FROM ('00:00:00'::TIME + (sec * '1 second'::INTERVAL)))::INT BETWEEN 17 AND 19 THEN 'Вечерний час-пик (17-19)'
		WHEN EXTRACT(HOUR FROM ('00:00:00'::TIME + (sec * '1 second'::INTERVAL)))::INT BETWEEN 12 AND 17 THEN 'Поздний вечер (19-23)'
		ELSE 'Ночное время'
    END
FROM generate_series(0, 86399) sec;

-- Создание таблицы dim_product (тип SCD2, учитывает возможность изменения имени продукта)
CREATE TABLE gold.dim_product (
	product_sk SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_id SMALLINT NOT NULL REFERENCES silver.silver_products(product_id),
	product_name VARCHAR(50) NOT NULL,
	product_category_name VARCHAR(50) NOT NULL,
	product_class CHAR(1) NOT NULL,
	product_resistant BOOLEAN NOT NULL,
	product_is_allergic BOOLEAN NOT NULL,
	product_vitality_days SMALLINT NOT NULL,
	valid_from TIMESTAMP NOT NULL,
	valid_to TIMESTAMP,
	is_current BOOLEAN NOT NULL
);

------------------------------------------------------------------------------------------------------------------------

-- Запрос для деактивации старых записей в dim_product при изменении имени продукта
UPDATE
	gold.dim_product
SET
	valid_to = LOCALTIMESTAMP,
	is_current = FALSE
FROM
	silver.silver_products
WHERE
	gold.dim_product.product_id = silver.silver_products.product_id
	AND gold.dim_product.is_current = TRUE
	AND gold.dim_product.product_name <> silver.silver_products.product_name; -- Отслеживание изменения имени продукта


-- Загрузка/обновление записей в dim_product
INSERT INTO gold.dim_product (
	product_id,
	product_name, 
	product_category_name, 
	product_class, 
	product_resistant,
	product_is_allergic,
	product_vitality_days,
	valid_from, 
	valid_to, 
	is_current
)
SELECT 
	silver.silver_products.product_id,
	silver.silver_products.product_name,
	silver.silver_categories.category_name, 
	silver.silver_products."class", 
	silver.silver_products.resistant,
	silver.silver_products.is_allergic,
	silver.silver_products.vitality_days,
	LOCALTIMESTAMP AS valid_from,
	NULL AS valid_to,
	TRUE AS is_current
FROM
	silver.silver_products
LEFT JOIN
	gold.dim_product ON silver.silver_products.product_id = gold.dim_product.product_id
	AND gold.dim_product.is_current = TRUE
INNER JOIN
	silver.silver_categories ON silver.silver_products.category_id = silver.silver_categories.category_id
WHERE gold.dim_product.product_id IS NULL	-- Вариант 1: новый продукт
	OR gold.dim_product.product_name <> silver.silver_products.product_name; -- Вариант 2: существующий продукт с изменившимся именем

------------------------------------------------------------------------------------------------------------------------

-- Создание таблицы fact_sales
CREATE TABLE gold.fact_sales (
	sales_sk BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	sales_id BIGINT NOT NULL REFERENCES silver.silver_sales(sales_id),
	product_sk SMALLINT NOT NULL REFERENCES gold.dim_product(product_sk),
	shop_sk SMALLINT NOT NULL REFERENCES gold.dim_shop(shop_sk),
	customer_sk INT NOT NULL REFERENCES gold.dim_customer(customer_sk),
	employee_sk SMALLINT NOT NULL REFERENCES gold.dim_employee(employee_sk),
	time_sk CHAR(6) NOT NULL REFERENCES gold.dim_time(time_sk),
	date_sk INT NOT NULL REFERENCES gold.dim_date(date_sk),
	location_sk INT NOT NULL REFERENCES gold.dim_location(location_sk),
	transaction_number CHAR(11) NOT NULL,
	price NUMERIC(10,2) NOT NULL,
	quantity SMALLINT NOT NULL,
	discount NUMERIC(10,2) NOT NULL,
	total_price NUMERIC(10,2) NOT NULL,
	-- судя по значениям price и total_price и необходимости вычисления revenue на их основе, 
	-- первая является закупочной (фермерской) ценой, а последняя - розничной ценой
	total_revenue NUMERIC(15,2) GENERATED ALWAYS AS (
		total_price * quantity
	) STORED,
	net_revenue NUMERIC(15,2) GENERATED ALWAYS AS (
		(total_price * quantity) - (total_price * quantity * discount)
	) STORED,
	-- вычисление маржинальности с обработкой потенциального деления на 0
	margin NUMERIC(15,2) GENERATED ALWAYS AS (
		COALESCE(((total_price * quantity) / (NULLIF(((total_price * quantity) - (total_price * quantity * discount)), 0))), 0)
	) STORED
);

-- Добавление данных в fact_sales из таблиц серебряного слоя silver_sales и silver_products, а также внешних ключей всех таблиц измерений
INSERT INTO gold.fact_sales (
	sales_id,
	product_sk,
	shop_sk,
	customer_sk,
	employee_sk,
	time_sk,
	date_sk,
	location_sk,
	transaction_number,
	price,
	quantity,
	discount,
	total_price
)
SELECT
	sales_id,
	product_sk,
	shop_sk,
	customer_sk,
	employee_sk,
	time_sk,
	date_sk,
	location_sk,
	transaction_number,
	price,
	quantity,
	discount,
	total_price
FROM
	silver.silver_sales
INNER JOIN
	silver.silver_products ON silver.silver_sales.product_id = silver.silver_products.product_id
INNER JOIN
	gold.dim_date ON TO_CHAR(silver.silver_sales.sales_timestamp, 'YYYYMMDD')::INT = gold.dim_date.date_sk
INNER JOIN
	gold.dim_time ON TO_CHAR(silver.silver_sales.sales_timestamp, 'HHMMSS') = gold.dim_time.time_sk
INNER JOIN
	gold.dim_location ON silver.silver_sales.city_id = gold.dim_location.location_sk
INNER JOIN
	gold.dim_product ON silver.silver_sales.product_id = gold.dim_product.product_id
INNER JOIN
	gold.dim_shop ON silver.silver_sales.shop_id = gold.dim_shop.shop_id
INNER JOIN
	gold.dim_customer ON silver.silver_sales.customer_id = gold.dim_customer.customer_id
INNER JOIN
	gold.dim_employee ON silver.silver_sales.employee_id = gold.dim_employee.employee_id
-- Условие обеспечения идемпотентности данного запроса через инкрементальную загрузку данных (уже записанные транзакции не меняются)
WHERE
	silver.silver_sales.sales_id > COALESCE((SELECT MAX(sales_id) FROM gold.fact_sales), 0)
ORDER BY
	sales_id ASC;

	


