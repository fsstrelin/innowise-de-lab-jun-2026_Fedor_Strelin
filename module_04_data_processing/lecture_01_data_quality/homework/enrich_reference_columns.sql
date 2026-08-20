/*
Скрипт заполнения колонок shop_id и city_id в таблице silver_sales.
*/

UPDATE silver.silver_sales 
SET 
	shop_id = ecomarket.bronze_shops.shop_id,   
	city_id = ecomarket.bronze_cities.city_id
FROM ecomarket.bronze_employees
INNER JOIN ecomarket.bronze_shops ON bronze_employees.shop_id = bronze_shops.shop_id
INNER JOIN ecomarket.bronze_cities ON bronze_shops.city_id = bronze_cities.city_id
WHERE silver_sales.employee_id = bronze_employees.employee_id;
