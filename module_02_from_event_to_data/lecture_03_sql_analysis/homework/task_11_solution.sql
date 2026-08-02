/*
Увеличить цену всех продуктов категории 'Fruits' на 10%.
Удалить всех сотрудников без продаж.
Вставить нового сотрудника и первую продажу в одной транзакции.
*/

--Увеличение цен всех товаров в категории 'Fruits' на 10%.
UPDATE
	ecomarket.products
SET
	price = price * 1.1
FROM
	ecomarket.categories
WHERE
	products.category_id = categories.category_id
AND 
	categories.category_name = 'Fruits';

--Добавление данных нового сотрудника Ivan Ivanov в таблицу employees и его первой продажи в таблицу sales одной транзакцией.
WITH new_employee AS (
    INSERT INTO ecomarket.employees (
    	employee_id,
    	first_name,
    	middle_initial,
    	last_name,
    	birth_date,
    	gender,
    	city_id,
    	shop_id,
    	hire_date
    )
    VALUES (
    	326,
    	'Ivan',
    	'I',
    	'Ivanov',
    	'01.01.1990',
    	'M',
    	6,
    	1,
    	'2026-08-01'
    )
    RETURNING employee_id
)
INSERT INTO sales (
	sales_id,
	employee_id,
	customer_id,
	product_id,
	quantity,
	discount,
	total_price,
	sales_timestamp,
	transaction_number
)
VALUES (
    2000002,
	(SELECT employee_id FROM new_employee), 
	76435,
	153,
	4,
	0.08,
	108.76,
    LOCALTIMESTAMP, 
    'T0002000002'
);

/*
Оценка корректности транзакции перед удалением данных.
Выполняется последним в скрипте для дополнительной проверки транзакции добавления нового сотрудника и его первой продажи.
*/
SELECT 
	ecomarket.employees.employee_id,
	ecomarket.employees.last_name
FROM ecomarket.employees 
WHERE employee_id NOT IN (
    SELECT employee_id 
    FROM ecomarket.sales
);

--Удаление строк сотрудников из таблицы employees не совершивших ни одной продажи по данным таблицы sales.
DELETE FROM ecomarket.employees 
WHERE employee_id NOT IN (
    SELECT employee_id 
    FROM ecomarket.sales
);
