/*
Задача 1.
Вывести для каждой продажи (sales_id) название продукта и адрес магазина.
*/

SELECT
	sales.sales_id,
	products.product_name,
	shops.address
FROM
	sales
INNER JOIN employees ON sales.employee_id = employees.employee_id
INNER JOIN shops ON employees.shop_id = shops.shop_id
INNER JOIN products ON sales.product_id = products.product_id
AND sales.sales_id <= 10;
