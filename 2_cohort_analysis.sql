SELECT 
	ca.cohort_year,
	count(DISTINCT customerkey) AS total_customer,
	sum(total_net_revenue) AS total_revenue, 
	sum(total_net_revenue) / count(DISTINCT customerkey) AS customer_revenue
FROM cohort_analysis ca 
WHERE ca.orderdate = ca.first_purchase_date
GROUP BY ca.cohort_year ;