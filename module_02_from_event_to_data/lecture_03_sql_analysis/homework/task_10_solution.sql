/*
Задача 10.
>Создать новую роль (пользователя) PostgreSQL с именем data_engineer_trainee (стажер) и простым паролем.
>Предоставить data_engineer_trainee право SELECT на таблицу sales.

>Подключиться к базе данных как data_engineer_trainee и выполнить SELECT * FROM sales; (должно завершиться успешно).
>Как data_engineer_trainee, попытаться выполнить INSERT новой продажи в sales (должно завершиться неудачей).

>Как пользователь-администратор, предоставить data_engineer_trainee права INSERT и UPDATE на таблицу sales.

>Как data_engineer_trainee, повторно попробовать выполнить INSERT и UPDATE (теперь должно сработать).
*/

-- Создание пользователя 
CREATE USER test_user WITH PASSWORD 'qwerty'; 
-- Создание роли 
CREATE ROLE data_engineer_trainee; 
--Наделение созданной роли правом на использование схемы ecomarket, в которой находится таблица sales
GRANT USAGE ON SCHEMA ecomarket TO data_engineer_trainee;
--Наделение созданной роли правом на запрос SELECT
GRANT SELECT ON TABLE ecomarket.sales TO data_engineer_trainee; 
-- Назначение роли пользователю 
GRANT data_engineer_trainee TO test_user;

--Подключение к базе данных в роли data_engineer_trainee
SET ROLE data_engineer_trainee;
--Тестирование запроса с SELECT от лица data_engineer_trainee
SELECT
	* 
FROM 
	ecomarket.sales;
--Тестирование запроса с INSERT от лица data_engineer_trainee
INSERT INTO ecomarket.sales (
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
	2000001,
	223,
	62345,
	306,
	2,
	0.05,
	43,
	LOCALTIMESTAMP,
	'T0002000001'
);

--Обратная смена роли на администратора (admin)
RESET ROLE;
--Наделение роли data_engineer_trainee правами на запросы INSERT и UPDATE
GRANT INSERT, UPDATE ON TABLE ecomarket.sales TO data_engineer_trainee;

--Повторное подключение к базе данных в роли data_engineer_trainee
SET ROLE data_engineer_trainee;
--Повторное тестирование запроса с INSERT от лица data_engineer_trainee
INSERT INTO ecomarket.sales (
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
	2000001,
	223,
	62345,
	306,
	2,
	0.05,
	43,
	LOCALTIMESTAMP,
	'T0002000001'
);