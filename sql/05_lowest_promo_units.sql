SELECT 
       promo_type,
       SUM(quantity_sold_before_promo) AS revenue_before,
       SUM(quantity_sold_after_promo) AS revenue_after,
       SUM(quantity_sold_after_promo) - SUM(quantity_sold_before_promo) AS incremental_sold_units
	   
FROM fact_events 

GROUP BY promo_type

ORDER BY incremental_sold_units ASC

LIMIT 2;
