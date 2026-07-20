/*
Задача 2-1.
Вывести все магазины расположенные в стране Польша с указанием их адресов и городов -
необходимые колонки: shop_id, address, city_name, country_name. 
 */

SELECT
	shops.shop_id,
	shops.address,
	cities.city_name,
	countries.country_name
FROM 
	shops
INNER JOIN cities ON shops.city_id = cities.city_id
INNER JOIN countries ON cities.country_id = countries.country_id
WHERE country_name = 'Poland';