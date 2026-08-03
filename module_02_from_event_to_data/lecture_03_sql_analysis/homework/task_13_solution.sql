/*
Найти сотрудников с продажами > 1000.

Обновить класс продуктов на 'A' для категорий с общей выручкой > 5000.

Установить modify_timestamp (функция NOW()) для продуктов без даты.
*/

--Поиск сотрудников с продажами > 1000
SELECT DISTINCT --DISTINCT предотвращает повторное добавление в список тех сотрудников, у кого было несколько заказов с суммой > 1000.
	sales.employee_id
FROM 
	ecomarket.sales
WHERE
	sales.total_price > 1000;

/* Задача "обновить класс продуктов на 'A' для категорий с общей выручкой > 5000" не имеет смысла, так как
общая выручка даже одного из товаров превышает это значение. Поэтому будем менять класс тех товаров, у которых
общая выручка превышает 500000. */

--Выбор продуктов с общей выручкой >600000 для будущей проверки транзакции с изменением класса товаров
SELECT
	sales.product_id,
	SUM(sales.total_price) AS total_product_sales,
	products."class"
FROM 
	ecomarket.sales
INNER JOIN ecomarket.products ON products.product_id = sales.product_id
GROUP BY
	sales.product_id,
	products."class"
HAVING
	SUM(sales.total_price) > 600000
ORDER BY	
	sales.product_id ASC;

--Обновление класса продуктов с общей выручкой >600000 на 'A'.
WITH product_sales_summary AS (
    SELECT
    	sales.product_id
    FROM
    	ecomarket.sales
    INNER JOIN ecomarket.products ON products.product_id = sales.product_id
    GROUP BY 
    	sales.product_id
    HAVING
    	SUM(sales.total_price) > 600000
)
UPDATE ecomarket.products
SET "class" = 'A'
FROM product_sales_summary
WHERE products.product_id = product_sales_summary.product_id;

--Установка значений modify_timestamp для продуктов без даты.
UPDATE ecomarket.products 
SET modify_timestamp = NOW() 
WHERE products.modify_timestamp IS NULL;