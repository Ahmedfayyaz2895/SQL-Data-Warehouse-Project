/*******************************************************************************
📊 SQL Data Exploration & Business Intelligence Script
🎯 Purpose: Analyze sales performance, customer demographics, and product metrics.
🗄️ Database Schema: Gold (fact_sales, dim_customers, dim_products)
👤 Author: [Your Name]
*******************************************************************************

📋 PROJECT OVERVIEW & STRUCTURE:
This script performs a comprehensive deep dive into the business data warehouse to
generate actionable insights. The exploration is broken down into 5 key phases:

1. 🔍 DATABASE METADATA EXPLORATION
   - Inspecting schema tables, column definitions, and structural layout.

2. 📈 GLOBAL BUSINESS KEY METRICS (KPIs)
   - Benchmarking core operational metrics (Total Sales, Total Orders, 
     Quantity Sold, Average Selling Prices, and Unique Customer counts).
   - Consolidating KPIs using a dynamic UNION ALL Unified Report query.

3. 👥 CUSTOMER DEMOGRAPHICS & SEGMENTATION
   - Geographic distribution (Customers by Country).
   - Behavioral analysis (Revenue generated per customer, Order frequency).
   - Generational profiling (Age range, oldest/youngest cohorts) and gender splits.

4. 📦 PRODUCT & CATEGORY PERFORMANCE
   - Catalog distribution by primary categories and subcategories.
   - Cost structure profiling (Average cost baseline per category).
   - Inventory tracking (Total unique products moving through the supply chain).

5. 🏆 TOP & BOTTOM PERFORMER ANALYSIS (RANKING)
   - Financial tracking of the Top 5 / Bottom 5 revenue-generating products.
   - High-value customer indexing (Top 10 highest-spending customers).
   - Identification of low-engagement customers (Fewest orders placed).

*******************************************************************************/


--- Explore all Objects from the Database ---
SELECT * FROM INFORMATION_SCHEMA.Tables


--- Explore all Columns from the Database ---
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'


--- Explpre all countries where our customers are from ---
SELECT DISTINCT country FROM gold.dim_customers


--- Explore all Categories "The Major Divisions" ---
SELECT DISTINCT category, subcategory, product_name from gold.dim_products 
ORDER BY 1,2,3


--- Explore the first and the last date of sales ---
--- How many years are available? ---
SELECT 
MIN(order_date) AS 'first_order_date',
MAX(order_date) AS 'last_order_date',
DATEDIFF(year, MIN(order_date), MAX(order_date)) AS 'order_date_range'
FROM gold.fact_sales


--- Find the youngest and olderst customers ---
SELECT 
MIN(birthdate) AS 'oldest_customer_dob',
DATEDIFF(year, MIN(birthdate),  GETDATE()) AS youngest_customer_age,
MAX(birthdate) AS 'youngest_customer_dob',
DATEDIFF(year, MAX(birthdate), GETDATE()) AS oldest_customer_age,
DATEDIFF(year, MIN(birthdate), MAX(birthdate)) AS customer_age_range
from gold.dim_customers


--- Find total Sales ---
SELECT SUM(sales) FROM gold.fact_sales AS Total_sales


--- Find how many items are sold ---
SELECT SUM(quantity) FROM gold.fact_sales AS Total_quantity_sold


--- Find the average selling price ---
SELECT AVG(price) FROM gold.fact_sales AS Average_price


--- Find the total number of orders ---
SELECT COUNT(order_number) FROM gold.fact_sales AS Total_orders
SELECT COUNT(DISTINCT order_number) FROM gold.fact_sales AS Total_orders -- Corrected for duplicates ---

---Find the total number of products ---
SELECT COUNT(DISTINCT product_key) from gold.dim_products AS Total_nr_products

--- Find the total number of customers ---
SELECT COUNT(DISTINCT customer_id) FROM gold.dim_customers AS Total_customers

--- Find the total number of customers that has placed an order ---
SELECT COUNT( DISTINCT customer_key) FROM gold.fact_sales



--- Generate the report that shows all the Key matrics of our business ---

SELECT 'Total_Sale' AS measure_name, SUM(sales) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_quantity' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average_price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_nr_orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_nr_products' AS measure_name, COUNT(DISTINCT product_key) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total_nr_customers' AS measure_name, COUNT(DISTINCT customer_id) AS measure_value FROM gold.dim_customers


--- Find total number of customer by Country ---
SELECT country, COUNT( DISTINCT customer_id) AS total_customers FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC


--- Find total customers by gender ---
SELECT gender, COUNT( DISTINCT customer_id) AS total_customers FROM gold.dim_customers 
GROUP BY gender
ORDER by total_customers DESC


--- Find total products by category ---
SELECT category, COUNT( DISTINCT product_id) AS total_products FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

--- What is the average cost in each category ---
SELECT category, AVG(cost) AS avg_cost FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC


--- What is the total revenue generated for each category ---
SELECT 
p.category,
SUM(s.sales) AS total_revenue 
FROM gold.dim_products p
LEFT JOIN gold.fact_sales s
	ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY total_revenue DESC


--- Find total revenue is generated by each customer ---
SELECT 
c.Customer_key,
c.first_name,
c.last_name,
SUM(f.sales) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.Customer_key
GROUP BY c.Customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC


--- what is the distribution of sold items across countries? ---
SELECT 
c.country,
COUNT(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.Customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC


--- Which 5 products generate the highest revenue? ---
SELECT top 5
p.product_name,
SUM(f.sales) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_sales DESC

---OR---
SELECT * FROM 
	(SELECT
	p.product_name,
	Row_number() OVER (ORDER BY SUM(f.sales) DESC) AS Product_rank,
	SUM(f.sales) AS total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
		ON p.product_key = f.product_key
	GROUP BY p.product_name)t
WHERE Product_rank < 6




--- What are the 5 worst-performing products in terms of sales? ---
SELECT TOP 5
p.product_name,
SUM(f.sales) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_sales


--- Find the top 10 customers who have generated the highest revenue---
SELECT TOP 10
c.Customer_key,
c.last_name,
c.first_name,
SUM(f.sales) AS total_sales
from gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON c.Customer_key = f.customer_key
GROUP BY c.Customer_key,
c.last_name,
c.first_name
ORDER BY total_sales DESC


--- Find 3 customers with fewest orders placed ---
SELECT TOP 3
c.Customer_key,
c.last_name,
c.first_name,
COUNT(DISTINCT f.order_number) AS Order_count
from gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON c.Customer_key = f.customer_key
GROUP BY c.Customer_key,
c.last_name,
c.first_name
ORDER BY Order_count
