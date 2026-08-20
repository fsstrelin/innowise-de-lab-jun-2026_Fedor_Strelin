/*
Следующий запрос использует обобщенное табличное выражение (CTE) и оконную функцию ROW_NUMBER().
Оконная функция нумерует строки внутри каждой группы дубликатов. Все строки с номером больше 1 удаляются.

PARTITION BY группирует строки с абсолютно одинаковыми данными.
ORDER BY id определяет, какую строку по счету считать первой (row_num = 1).
В данном случае останется строка с наименьшим id.
DELETE ... WHERE row_num > 1 стирает все "лишние" копии, сколько бы их ни было.
*/

--Удаление дубликатов (с разными id) из таблицы silver_employees.
WITH duplicates AS (
    SELECT 
        employee_id,
        ROW_NUMBER() OVER (
            PARTITION BY first_name, middle_initial, last_name, birth_date, gender, city_id, shop_id, hire_date -- атрибуты, которые могут совпадать у разных экземпляров таблицы
            ORDER BY employee_id ASC
        ) as row_num
    FROM silver.silver_employees
)
DELETE FROM silver.silver_employees
USING duplicates
WHERE silver_employees.employee_id = duplicates.employee_id
  AND duplicates.row_num > 1;

--Удаление экземпляров таблицы silver_employees, у которых отсутствует employee_id (IS NULL)
DELETE FROM silver.silver_employees 
WHERE employee_id IS NULL;

--Удаление строк сотрудников из таблицы employees не совершивших ни одной продажи по данным таблицы sales.
DELETE FROM silver.silver_employees
WHERE employee_id NOT IN (
    SELECT employee_id 
    FROM ecomarket.bronze_sales
);