/*
Представление (View): создать представление FullStatShops для суммарной статистики по магазинам
с колонками (shop_id, shop_address, country, total_sales_count, total_sales_amount).  

Функция: создать функцию AvgSalesPerEmployee (PL/pgSQL), для вычисления средней суммы продаж для сотрудника.
*/

--Создание представления FullStatShops.
CREATE VIEW FullStatShops AS
SELECT
	shops.shop_id,
	shops.shop_address,
	countries.country_name AS country,
	COUNT(sales.sales_id) AS total_sales_count,
	SUM(sales.total_price) AS total_sales_amount
FROM
	sales
INNER JOIN employees ON sales.employee_id = employees.employee_id
INNER JOIN shops ON employees.shop_id = shops.shop_id
INNER JOIN cities ON shops.city_id = cities.city_id
INNER JOIN countries ON cities.country_id = countries.country_id
GROUP BY 
	countries.country_name, shops.shop_id
ORDER BY 
	shop_id ASC;

SELECT
	* 
FROM 
	FullStatShops;

--Создание функции AvgSalesPerEmployee
CREATE OR REPLACE FUNCTION AvgSalesPerEmployee (employee_id_argument SMALLINT)
RETURNS DECIMAL AS $$
DECLARE
	avg_sales DECIMAL (10, 2);
BEGIN
	SELECT 
		COALESCE(AVG(total_price), 0.00) --COALESCE предотвращает использование NULL в качестве аргумента функции
		INTO avg_sales
		FROM ecomarket.sales
		WHERE employee_id = employee_id_argument;
	RETURN
		avg_sales;
END;
$$ LANGUAGE plpgsql;

--Далее проверка функции AvgSalesPerEmployee
SELECT
	AvgSalesPerEmployee(326::SMALLINT); -- Проверка для добавленного сотрудника Ivanov Ivan, у которого одна продажа, добавленная вручную

--Добавление второй продажи Ivanov Ivan
INSERT INTO sales (
	sales_id,
	employee_id,
	customer_id,
	product_id,
	quantity,
	discount,
	total_price,
	sales_timestamp,
	transaction_number
)
VALUES (
    2000003,
	326, 
	76435,
	153,
	4,
	0.08,
	191.24,
    LOCALTIMESTAMP, 
    'T0002000003'
);

SELECT
	AvgSalesPerEmployee(326::SMALLINT); -- Повторная проверка для сотрудника Ivanov Ivan, у которого теперь две продажи, добавленные вручную

	