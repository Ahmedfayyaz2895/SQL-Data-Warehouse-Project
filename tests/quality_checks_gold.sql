
/*

===========================================================================
Quality Checks
===========================================================================
Script Purpose:
	This script performs quality checks to validate the integrity, consistency,
	and accuracy of the Gold Layer. These checks ensure:
	-	Uniqueness of customer_key in dimension tables.
	-	Referential integrity between fact and dimension tables.
	-	Validation of relationships in the data model for analytical purposes.

usage:
	-	Run these checks after loading data from silver layer
	-	Investigate and resolve any discrepencies found during the checks.
===========================================================================
*/
-- ==========================================================================

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
