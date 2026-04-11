WITH customer_months AS (
	 SELECT DISTINCT
	 customerkey,
	 DATE_TRUNC('month', orderdate) AS order_month,
	 DATE_TRUNC('month', first_purchase_date) AS cohort_month,
	 	(
	        EXTRACT(YEAR FROM orderdate) - EXTRACT(YEAR FROM first_purchase_date)
	    ) * 12
	    +
	    (
	        EXTRACT(MONTH FROM orderdate) - EXTRACT(MONTH FROM first_purchase_date)
	    ) AS months_since_first_purchase
	 
	 FROM cohort_analysis
 )
SELECT 
	cohort_month,
	months_since_first_purchase , 
	count(DISTINCT customerkey) AS customers_retained, 
	MAX(count(DISTINCT customerkey)) OVER (PARTITION BY cohort_month) AS cohort_size, 
	round(count(DISTINCT customerkey) / MAX(count(DISTINCT customerkey)) OVER (PARTITION BY cohort_month)::numeric, 3) AS retention_rate
FROM customer_months 
Group BY months_since_first_purchase, cohort_month
ORDER BY cohort_month , months_since_first_purchase