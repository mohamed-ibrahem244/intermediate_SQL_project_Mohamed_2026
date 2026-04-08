WITH customer_last_purchase AS (

SELECT 
	ca.customerkey ,
	ca.full_name , 
	ca.orderdate ,
	ca.first_purchase_date ,
	ca.cohort_year ,
	row_number() OVER (PARTITION BY ca.customerkey ORDER BY ca.orderdate DESC) AS rn

FROM 
	cohort_analysis ca 
), churned_customers AS (
	SELECT 
		customerkey, 
		full_name, 
		orderdate AS last_purchase_date, 
		CASE 
			WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months' THEN 'Churned'
			ELSE 'Active'
		END AS customer_status, 
		cohort_year 
		
	FROM 
		customer_last_purchase 
	WHERE rn = 1 AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months'	
)

SELECT 
customer_status, 
cohort_year ,
count(*), 
sum(count(customerkey)) OVER(PARTITION BY cohort_year )  AS total_customers,
round(count(*) / sum(count(customerkey)) OVER(), 2) AS status_percent
FROM churned_customers 
GROUP BY cohort_year ,customer_status 