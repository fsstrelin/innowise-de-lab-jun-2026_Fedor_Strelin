/* Создание схемы mart, исправленная версия */

-- Создаём схему mart, в которой будут располагаться все представления витрин данных
CREATE SCHEMA mart;

/* mart_daily_anomaly: Витрина для анализа отклонений ежедневной выручки отдельного магазина от статистически ожидаемой. */

/* Следующий SQL-запрос создаёт цепь из двух common table expressions перед основным запросом.
В первом CTE происходит агрегация всех продаж (net_revenue) каждого магазина по дате.
Во втором CTE для каждого магазина вычисляется среднее значение всех сумм дневных продаж за предыдущие 30 дней.
Затем, в основном запросе, вместе собираются все агрегированные значения и выводятся
вместе с соответствующей им географической информацией о магазинах, для которых они посчитаны. */

-- Создание представления для витрины дневной аномалии продаж отдельного магазина
CREATE VIEW mart.mart_daily_anomaly AS
WITH shop_daily_revenue AS (
	SELECT
		gold.dim_date.full_date AS sales_date,
		gold.dim_shop.shop_country_name AS shop_country,
		gold.dim_shop.shop_city_name AS shop_city,
		gold.dim_shop.shop_address AS shop_address,
		SUM(gold.fact_sales.net_revenue) AS shop_daily_revenue
	FROM
		gold.fact_sales
	INNER JOIN
		gold.dim_date ON gold.fact_sales.date_sk = gold.dim_date.date_sk
	INNER JOIN
		gold.dim_shop ON gold.fact_sales.shop_sk = gold.dim_shop.shop_sk
	GROUP BY
		gold.dim_shop.shop_country_name,
		gold.dim_shop.shop_city_name,
		gold.dim_shop.shop_address,
		gold.dim_date.full_date
	ORDER BY
		gold.dim_date.full_date ASC
),
shop_expected_revenue AS (
	SELECT
		sales_date,
		shop_country,
		shop_city,
		shop_address,
		shop_daily_revenue,
		AVG(shop_daily_revenue) OVER (
			PARTITION BY shop_address	
			ORDER BY sales_date
			ROWS BETWEEN 30 PRECEDING AND 1 PRECEDING
		) AS shop_expected_revenue
	FROM shop_daily_revenue
)
SELECT
	sales_date,
	shop_country,
	shop_city,
	shop_address,
	shop_daily_revenue AS shop_actual_total_revenue_on_this_day,
	ROUND(shop_expected_revenue, 2) AS shop_expected_total_revenue_on_this_day,
	ROUND(((shop_daily_revenue - shop_expected_revenue) / shop_expected_revenue) * 100, 2) AS uplift_percent
FROM
	shop_expected_revenue
ORDER BY
	sales_date, shop_address ASC;


/* mart_shop_daily: Витрина для анализа индивидуальной дневной результативности магазинов. */

-- Создание представления для витрины показателей дневных продаж отдельных магазинов
CREATE VIEW mart.mart_shop_daily AS
SELECT
	gold.dim_date.full_date AS "date",
	gold.dim_shop.shop_country_name AS shop_country,
	gold.dim_shop.shop_city_name AS shop_city,
	gold.dim_shop.shop_address AS shop_address,
	COUNT(fact_sales.sales_sk) AS number_of_sales_made_by_shop__on_this_day,
	SUM(fact_sales.net_revenue) AS shop_total_revenue_on_this_day,
	ROUND(AVG(fact_sales.net_revenue), 2) AS shop_average_revenue_per_each_sale_on_this_day
FROM 
	gold.fact_sales
INNER JOIN
	gold.dim_date ON gold.fact_sales.date_sk = gold.dim_date.date_sk
INNER JOIN 
	gold.dim_shop ON gold.fact_sales.shop_sk = gold.dim_shop.shop_sk
GROUP BY 
	shop_country,
	shop_city,
	shop_address,
	"date"
ORDER BY 
	"date", shop_total_revenue_on_this_day ASC;


/* mart_customer_behavior: Витрина для ранжирования клиентской базы по принесённой прибыли. */

/* Следующий SQL-запрос создаёт цепь из двух common table expressions перед основным запросом.
В первом CTE происходит агрегация продаж (net_revenue) для каждого клиента с вычислением суммы всей прибыли,
принесённой клиентом, а также общего числа совершенных клиентом покупок.
Во втором CTE для каждого клиента определяется ранг по принесённой прибыли (бронзовый -> платиновый).
Затем, в основном запросе, вычисляется число клиентов для каждого ранга. */

-- Создание представления для витрины ранжирования клиентской базы
CREATE VIEW mart.mart_customer_behavior AS
WITH customer_metrics AS (
	-- Агрегация данных по продажам из fact_sales для каждого клиента из dim_customer
	SELECT 
		gold.dim_customer.customer_sk,
		gold.dim_customer.customer_country_name AS customer_country,
		gold.dim_customer.customer_city_name AS customer_city,
		gold.dim_customer.customer_first_name || ' ' || gold.dim_customer.customer_middle_initial || ' ' || gold.dim_customer.customer_last_name AS customer_full_name,
		COALESCE(SUM(gold.fact_sales.net_revenue), 0) AS customer_total_revenue,
		COUNT(gold.fact_sales.sales_sk) AS customer_total_orders,
		MAX(gold.dim_date.full_date) AS customer_last_purchase_date
	FROM gold.fact_sales
	INNER JOIN 
		gold.dim_customer ON gold.fact_sales.customer_sk = gold.dim_customer.customer_sk
	INNER JOIN 
		gold.dim_date ON gold.fact_sales.date_sk = gold.dim_date.date_sk
	GROUP BY
		dim_customer.customer_sk, 
		dim_customer.customer_first_name,
		dim_customer.customer_middle_initial,
		dim_customer.customer_last_name
),
customer_segmentation AS (
	-- Вычисление рангов, статусов активности и сегментов по выручке
	SELECT 
		customer_sk,
		customer_country,
		customer_city,
		customer_full_name,
		customer_total_revenue,
		customer_total_orders,
		-- Ранжирование клиентов по сумме выручки
		DENSE_RANK() OVER (ORDER BY customer_total_revenue DESC) AS customer_total_revenue_rank,
		-- Определение статуса активности (активен, если покупал в последние 90 дней интервала имеющихся в базе продаж)
		CASE 
			WHEN customer_last_purchase_date >= '2023-12-31'::DATE - INTERVAL '90 days' THEN 'Active'
			ELSE 'Inactive'
		END AS customer_activity_status,
		-- Сегментация по фиксированным порогам выручки
		CASE 
			WHEN customer_total_revenue >= 10000000 THEN 'Platinum'
			WHEN customer_total_revenue >= 100000 AND customer_metrics.customer_total_revenue < 10000000 THEN 'Gold'
			WHEN customer_total_revenue >= 1000 AND customer_metrics.customer_total_revenue < 100000 THEN 'Silver'
			ELSE 'Bronze'
		END AS customer_total_revenue_segment
	FROM customer_metrics
)
-- Добавление подсчета общего количества клиентов внутри каждого сегмента
SELECT 
	customer_sk,
	customer_country,
	customer_city,
	customer_full_name,
	customer_total_revenue,
	customer_total_orders,
	customer_total_revenue_rank,
	customer_activity_status,
	customer_total_revenue_segment,
	-- Оконная функция подсчёта количества клиентов в текущем сегменте
	COUNT(*) OVER (PARTITION BY customer_total_revenue_segment) AS total_customers_in_segment
FROM
	customer_segmentation
ORDER BY
	customer_total_revenue DESC;

/* mart_employee_performance: Витрина эффективности персонала. */

-- Создание представления для витрины эффективности персонала по принесённой прибыли
CREATE VIEW mart.mart_employee_performance AS
SELECT
	gold.dim_employee.employee_sk,
	gold.dim_employee.employee_country_name AS employee_country,
	gold.dim_employee.employee_city_name AS employee_city,
	gold.dim_employee.employee_first_name || ' ' || gold.dim_employee.employee_middle_initial || ' ' || gold.dim_employee.employee_last_name AS employee_full_name,
	SUM(fact_sales.net_revenue) AS employee_total_revenue
FROM
	gold.fact_sales
INNER JOIN
	gold.dim_employee ON gold.fact_sales.employee_sk = gold.dim_employee.employee_sk
GROUP BY
	gold.dim_employee.employee_sk,
	gold.dim_employee.employee_first_name,
	gold.dim_employee.employee_middle_initial,
	gold.dim_employee.employee_last_name
ORDER BY
	employee_total_revenue DESC;


/* mart_product_seasonality: Витрина анализа сезонности продуктов. */

-- Создание представления для витрины сезонности продуктов по категориям
CREATE VIEW mart.mart_product_seasonality AS
SELECT
	gold.dim_product.product_category_name AS category,
	gold.dim_date.week_num AS week_number,
	gold.dim_location.location_country_name AS country,
	gold.dim_location.location_city_name AS city,
	SUM(gold.fact_sales.net_revenue) AS total_week_revenue,
	COUNT(gold.fact_sales.sales_sk) AS total_week_sales_count,
	ROUND(AVG(fact_sales.net_revenue), 2) AS average_week_revenue
FROM
	gold.fact_sales
INNER JOIN
	gold.dim_product ON gold.fact_sales.product_sk = gold.dim_product.product_sk
INNER JOIN
	gold.dim_date ON gold.fact_sales.date_sk = gold.dim_date.date_sk
INNER JOIN
	gold.dim_location ON gold.fact_sales.location_sk = gold.dim_location.location_sk
GROUP BY
	category,
	week_number,
	city,
	country
ORDER BY
	week_num, total_week_revenue DESC;
