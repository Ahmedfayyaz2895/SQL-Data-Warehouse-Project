
---Checking uniqueness of customer_key in gold.dim_customers---
SELECT 
	customer_key,
	COUNT(*) AS 'duplicate_count'
	FROM gold.dim_customers
	GROUP BY customer_key
	HAVING COUNT(*) > 1

---Checking uniqueness of product_key in gold.dim_products---
SELECT 
	product_key,
	COUNT(*) AS 'duplicate_count'
	FROM gold.dim_products
	GROUP BY product_key
	HAVING COUNT(*) > 1

---Checking the data model connectivity between fact and dimension views---
	SELECT * FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
		ON c.customer_key = f.customer_key
	LEFT JOIN gold.dim_products p
		ON p.product_key = f.product_key
	WHERE p.product_key IS NULL
