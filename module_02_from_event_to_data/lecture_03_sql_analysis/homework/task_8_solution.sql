/*
Задача 8.
Вставить два новых Продукта (Products).
Выбрать только Продукты (Products) у которых is_allergic и resistant = 'Yes'.
Обновить is_allergic для Продукта (Products) Bananas Family Pack на 'Yes'.
Удалить один из двух добавленных продуктов.
Проверить все изменения, используя SELECT * FROM Products;.
*/
INSERT INTO
	products (product_id, product_name, price, category_id, "class", modify_timestamp, resistant, is_allergic, vitality_days)
VALUES 
	(506, 'new_product_1', 100.00, 1, 'A', LOCALTIMESTAMP, 'Yes', 'No', 3),
	(507, 'new_product_2', 200.00, 2, 'C', LOCALTIMESTAMP, 'No', 'Yes', 7);

SELECT
	*
FROM 
	products
WHERE (
	is_allergic = 'Yes'
AND
	resistant = 'Yes'
)
ORDER BY 
	product_id ASC;

UPDATE products
SET 
	is_allergic = 'Yes'
WHERE 
	product_name = 'Bananas Family Pack';

DELETE FROM products
WHERE 
	product_name = 'new_product_2';

SELECT 
	*
FROM 
	products
ORDER BY 
	product_id ASC;