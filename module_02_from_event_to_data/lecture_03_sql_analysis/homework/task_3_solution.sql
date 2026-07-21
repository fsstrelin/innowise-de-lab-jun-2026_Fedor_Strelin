/*
Задача 3.
Вывести общее количество магазинов (total_shops) в каждой стране
и отсортировать результат по количеству магазинов по убыванию.
*/
SELECT
	countries.country_name,
	COUNT(shops) AS total_shops
FROM
	shops
INNER JOIN cities ON shops.city_id = cities.city_id
INNER JOIN countries ON cities.country_id = countries.country_id
GROUP BY 
	countries.country_name
ORDER BY 
	total_shops DESC;