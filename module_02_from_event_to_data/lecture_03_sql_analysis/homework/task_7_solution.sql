/*
Задача 7.
Для каждого магазина рассчитать агрегаты продаж и аналитические показатели в разрезе страны.
Для каждого магазина, у которого не менее 2 продаж, посчитать:
>количество продаж COUNT(sales_id);
>общую сумму продаж SUM(total_price);
>долю оборота магазина от общего оборота страны;
>ранг магазина по сумме продаж внутри своей страны;
>накопительный оборот по стране, отсортированный по убыванию оборота магазина.

Отсортировать результат по стране и по рангу магазина.
*/

/*
 * Временный именованный подзапрос, который определяет ранги магазинов по их обороту по странам, где они расположены.
 * Далее колонка с полученными значениями рангов будет использована в оконной функции SUM() OVER для вычисления
 * накопительного оборота по странам. Сортировка по убыванию оборота магазина равносильна сортировке по рангам магазинов,
 * где первый ранг присвоен магазину с крупнейшим в стране оборотом - то есть оборот магазина находится в обратной зависимости
 * от ранга магазина.
 */

WITH shop_country_rank_evaluation AS (
	SELECT
		countries.country_name AS country_name,
		shops.shop_id AS shop_id,
		shops.address AS shop_address,
		COUNT(sales.sales_id) AS total_sales_count,
		SUM(sales.total_price) AS total_sales_amount,
		SUM(SUM(sales.total_price)) OVER(PARTITION BY countries.country_name) AS country_total,
		SUM(sales.total_price) / SUM(SUM(sales.total_price)) OVER(PARTITION BY countries.country_name) AS country_sales_share,
		DENSE_RANK() OVER (
			PARTITION BY countries.country_name
			ORDER BY SUM(sales.total_price) DESC
		) AS shop_country_rank
	FROM
		sales
	INNER JOIN employees ON sales.employee_id = employees.employee_id
	INNER JOIN shops ON employees.shop_id = shops.shop_id
	INNER JOIN cities ON shops.city_id = cities.city_id
	INNER JOIN countries ON cities.country_id = countries.country_id
	GROUP BY 
		countries.country_name, shops.shop_id
)
/* Основной запрос, который использует результат именованного подзапроса "shop_country_rank_evaluation". */
SELECT
	country_name,
	shop_id,
	shop_address,
	total_sales_count,
	total_sales_amount,
	country_total,
	country_sales_share,
	shop_country_rank,
	SUM(total_sales_amount) OVER(    
		PARTITION BY country_name   
		ORDER BY shop_country_rank
	) AS country_running_total
FROM 
	shop_country_rank_evaluation	
GROUP BY 
	country_name, shop_id, shop_address, total_sales_count, total_sales_amount, country_total, country_sales_share, shop_country_rank
ORDER BY 
	country_name, shop_country_rank ASC
LIMIT
	22;