/*
Задача 2-2.
Вывести все транзакции с суммой продажи выше 1500 (total_price > 1500) для продуктов класса A (class = 'A'),
выполнить сортировку по номеру транзакции.
*/
SELECT
	sales.transaction_number,
	products.product_name,
	products.class,
	sales.total_price,
	sales.sales_timestamp
FROM
	sales
INNER JOIN 
	products ON sales.product_id = products.product_id
WHERE
	sales.total_price > 1500 AND products.class = 'A'
ORDER BY
	sales.sales_id ASC
LIMIT 
	10;