CREATE DATABASE PROJECT;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
	OR
	category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
   transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
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
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- the unique category we have ?
SELECT DISTINCT category FROM retail_sales

SELECT * FROM RETAIL_SALES

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM RETAIL_SALES 
WHERE SALE_DATE =  '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
Select * from retail_Sales
where category = 'Clothing'

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as Total_sale from retail_sales
group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select Round (avg(age),0) as Avg_age_Cust,Category from Retail_sales
where Category = 'Beauty'
Group by 2

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
Select * from retail_sales
where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
Select Gender, Category , count(transactions_id) as total_no_trans from retail_Sales 
Group by 1,2

-- -- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Select 
	YEAR,
	MONTH,
	AVG_SALE
from 
		(select 
				extract (year from sale_date) as year , 
				extract (month from sale_date) as month, 
				Round (avg(total_sale),0) as avg_sale,
				dense_rank () over (PARTITION BY extract (year from sale_date) ORDER BY (avg(total_sale))) as rank
		from retail_Sales
		Group by 1,2) AS RNK
WHERE RANK = 1
ORDER BY YEAR DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 


select * from (
			select customer_id,
			sum(total_sale) as total_sales,
			dense_rank () over(order by (sum(total_sale)) desc ) as rank
			from retail_sales
			group by 1) as rnk
			where rank in (1,2,3,4,5)


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT CATEGORY, 
	COUNT (DISTINCT CUSTOMER_ID) AS UNIQUE_CUST  
FROM RETAIL_SALES
GROUP BY 1




-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM SALE_TIME) <12 THEN 'MORNING'
		WHEN EXTRACT (HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
	ELSE 'NIGHT' 
	END AS SHIFT 
FROM RETAIL_sALES
ORDER BY SALE_TIME ASC

select 
	Shift,
	Count(*) as no_of_Orders 
from (
		SELECT*, 
			CASE 
				WHEN EXTRACT(HOUR FROM SALE_TIME) <12 THEN 'MORNING'
				WHEN EXTRACT (HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
			ELSE 'NIGHT' 
			END AS SHIFT 
		FROM RETAIL_sALES) as t1
group by shift

--cte (COMMON TABLE EXPRESSIONS)

with hourly_sale 
as 
(
		SELECT*, 
			CASE 
				WHEN EXTRACT(HOUR FROM SALE_TIME) <12 THEN 'MORNING'
				WHEN EXTRACT (HOUR FROM SALE_TIME) BETWEEN 12 AND 17 THEN 'AFTERNOON'
			ELSE 'NIGHT' 
			END AS SHIFT 
		FROM RETAIL_sALES 
)
select 
	shift,
	Count(transactions_id) as total_sale
from hourly_sale
group by 1;



												---END OF PROJECT 
