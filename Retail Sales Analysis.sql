-- Retail Sales Analysis MYSQL
CREATE DATABASE sqlpro;


-- Create TABLE
DROP TABLE IF EXISTS Retail_Sales;
CREATE TABLE Retail_Sales
( transaction_id INT PRIMARY KEY,	
 sale_date DATE,	 
 sale_time TIME,	
 customer_id	INT,
 gender	VARCHAR(15),
 age	INT,
 category VARCHAR(15),	
 quantity	INT,
 price_per_unit FLOAT,	
 cogs	FLOAT,
 total_sale FLOAT);


SELECT COUNT(*) 
FROM Retail_Sales;

-- Data Cleaning
SELECT * FROM Retail_Sales
WHERE transactions_id IS NULL;

SELECT * FROM Retail_Sales
WHERE sale_date IS NULL;

SELECT * FROM Retail_Sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    customer_id IS NULL 
    OR 
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    customer_id IS NULL 
    OR 
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM Retail_Sales;

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM Retail_Sales;

SELECT DISTINCT category FROM Retail_Sales;


-- Data analysis & Business Key Problems with Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM Retail_Sales 
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022

SELECT * FROM Retail_Sales
WHERE category = 'clothing' AND quantity > '2' 
AND date_format(sale_date, '%Y-%m') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category, sum(total_sale), count(quantity) 
FROM Retail_Sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT AVG(age) FROM Retail_Sales 
WHERE category = 'beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM Retail_sales
WHERE total_sale > 1000
ORDER BY transactions_id;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT DISTINCT category, count(transactions_id),gender
FROM Retail_Sales
GROUP BY gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH ranked_sales AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS YEAR,
        EXTRACT(MONTH FROM sale_date) AS MONTH,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS Ranking
    FROM Retail_Sales
    GROUP BY YEAR, MONTH
)

SELECT *
FROM ranked_sales
WHERE ranking = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id, 
sum(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY customer_id
ORDER BY total_sales DESC
lIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT count(DISTINCT customer_id) AS unique_customer,category
FROM Retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS ( SELECT *, CASE
WHEN HOUR(sale_time) < 12 THEN 'morning'
WHEN HOUR(sale_time) between 12 and 17 THEN 'afternoon'
ELSE 'evening'
END AS shift 
FROM Retail_Sales)
SELECT shift, count(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
