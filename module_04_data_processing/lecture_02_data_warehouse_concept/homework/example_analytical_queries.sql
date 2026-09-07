/* Аналитические запросы для слоя gold */

-- Аналитический запрос 1: топ-10 клиентов по выручке
SELECT
	customer_first_name || ' ' || customer_middle_initial || ' ' || customer_last_name AS customer_full_name,
	SUM(net_revenue) AS customer_total_revenue
FROM
	gold.fact_sales
INNER JOIN
	gold.dim_customer ON gold.fact_sales.customer_sk = gold.dim_customer.customer_sk
GROUP BY
	customer_first_name,
	customer_middle_initial,
	customer_last_name
ORDER BY
	customer_total_revenue DESC
LIMIT
	10;

-- Аналитический запрос 2: 10 самых продаваемых товаров
SELECT
	product_name,
	product_category_name,
	SUM(net_revenue) AS product_total_revenue
FROM
	gold.fact_sales
INNER JOIN
	gold.dim_product ON gold.fact_sales.product_sk = gold.dim_product.product_sk
GROUP BY
	product_name,
	product_category_name
ORDER BY
	product_total_revenue DESC
LIMIT
	10;

-- Аналитический запрос 3: средний чек за всё время работы EcoMarket
SELECT
	ROUND(AVG(total_revenue), 2) AS average_receipt
FROM
	gold.fact_sales;