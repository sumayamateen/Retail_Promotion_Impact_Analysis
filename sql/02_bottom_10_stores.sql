SELECT  
	store_id,
    SUM(quantity_sold_after_promo) - SUM(quantity_sold_before_promo) AS incremental_sold_units
    
FROM fact_events

GROUP BY store_id   

ORDER BY incremental_sold_units ASC

LIMIT 10;
