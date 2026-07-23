/*
Задача 5.
Вывести имя и фамилию продавца, который совершил продажу с максимальной суммой
и вывести адрес магазина, в котором он работает.
*/
SELECT
	employees.first_name,
	employees.last_name,
	shops.address,
	sales.total_price AS max_amount
FROM sales
INNER JOIN employees ON sales.employee_id = employees.employee_id
INNER JOIN shops ON employees.shop_id = shops.shop_id
WHERE 
	sales.total_price = (
		SELECT
			MAX(sales.total_price)
		FROM
			sales
	);