/*
Задача 4.
Вывести по каждому продукту сумму всех продаж, где сумма продаж выше 400,000.00.
Вывести значения среднего чека для всех вышеуказанных товаров.
Отсортировать вывод по суммам продаж по убыванию.
*/
SELECT
	products.product_name,
	SUM(sales.total_price) AS total_revenue,
	ROUND(AVG(sales.total_price), 2) AS avg_sale
FROM
	sales
INNER JOIN products ON sales.product_id = products.product_id
GROUP BY 
	products.product_name
HAVING
	SUM(sales.total_price) > 400000.00
ORDER BY
	total_revenue DESC
LIMIT 
	10;