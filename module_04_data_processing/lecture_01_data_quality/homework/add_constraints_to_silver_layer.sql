/*
SQL-скрипт добавляет ограничения в очищенные таблицы серебряного слоя. 
 */

ALTER TABLE silver.silver_countries
ADD CONSTRAINT pk_silver_countries_country_id PRIMARY KEY (country_id);

ALTER TABLE silver.silver_cities
ADD CONSTRAINT pk_silver_cities_city_id PRIMARY KEY (city_id),
ADD CONSTRAINT fk_silver_cities_country_id FOREIGN KEY (country_id) REFERENCES silver.silver_countries(country_id);

ALTER TABLE silver.silver_categories 
ADD CONSTRAINT pk_silver_categories_category_id PRIMARY KEY (category_id);

ALTER TABLE silver.silver_products
ADD CONSTRAINT pk_silver_products_product_id PRIMARY KEY (product_id),
ADD CONSTRAINT fk_silver_products_category_id FOREIGN KEY (category_id) REFERENCES silver.silver_categories(category_id);

ALTER TABLE silver.silver_shops
ADD CONSTRAINT pk_silver_shops_shop_id PRIMARY KEY (shop_id),
ADD CONSTRAINT fk_silver_shops_city_id FOREIGN KEY (city_id) REFERENCES silver.silver_cities(city_id);

ALTER TABLE silver.silver_employees
ADD CONSTRAINT pk_silver_employees_employee_id PRIMARY KEY (employee_id),
ADD CONSTRAINT fk_silver_employees_shop_id FOREIGN KEY (shop_id) REFERENCES silver.silver_shops(shop_id),
ADD CONSTRAINT fk_silver_employees_city_id FOREIGN KEY (city_id) REFERENCES silver.silver_cities(city_id),
ADD CONSTRAINT chk_employees_dates CHECK (hire_date > birth_date);

ALTER TABLE silver.silver_customers
ADD CONSTRAINT pk_silver_customers_customer_id PRIMARY KEY (customer_id),
ADD CONSTRAINT fk_silver_customers_city_id FOREIGN KEY (city_id) REFERENCES silver.silver_cities(city_id);

ALTER TABLE silver.silver_sales
ADD CONSTRAINT pk_silver_sales_sales_id PRIMARY KEY (sales_id),
ADD CONSTRAINT fk_silver_sales_employee_id FOREIGN KEY (employee_id) REFERENCES silver.silver_employees(employee_id),
ADD CONSTRAINT fk_silver_sales_customer_id FOREIGN KEY (customer_id) REFERENCES silver.silver_customers(customer_id),
ADD CONSTRAINT fk_silver_sales_product_id FOREIGN KEY (product_id) REFERENCES silver.silver_products(product_id),
ADD CONSTRAINT fk_silver_sales_shop_id FOREIGN KEY (shop_id) REFERENCES silver.silver_shops(shop_id),
ADD CONSTRAINT fk_silver_sales_city_id FOREIGN KEY (city_id) REFERENCES silver.silver_cities(city_id);