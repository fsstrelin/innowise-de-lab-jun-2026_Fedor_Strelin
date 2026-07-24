/*
Задача 6.
Найти выручку всех магазинов в Германии по месяцам и разницу с предыдущим месяцем.
Применить сортировку по месяцам по возрастанию.
*/
SELECT
	TO_CHAR(DATE_TRUNC('month', sales.sales_timestamp), 'FMMonth YYYY') AS sale_month,
	SUM(sales.total_price) AS monthly_revenue,
	
	LAG(SUM(sales.total_price), 1, 0) OVER( 
		ORDER BY DATE_TRUNC('month', sales.sales_timestamp)
	) AS previous_month_revenue,
	
	SUM(sales.total_price) - LAG(SUM(sales.total_price), 1, 0) OVER( 
		ORDER BY DATE_TRUNC('month', sales.sales_timestamp)
	) AS revenue_diff_vs_previous
FROM 
	sales
INNER JOIN employees ON sales.employee_id = employees.employee_id
INNER JOIN shops ON employees.shop_id = shops.shop_id
INNER JOIN cities ON shops.city_id = cities.city_id
INNER JOIN countries ON cities.country_id = countries.country_id
WHERE 
	countries.country_name = 'Germany'
GROUP BY
	DATE_TRUNC('month', sales.sales_timestamp)
ORDER BY 
	DATE_TRUNC('month', sales.sales_timestamp) ASC;
