SELECT  
	store_id,

    SUM(base_price * quantity_sold_after_promo) - SUM(base_price * quantity_sold_before_promo) AS incremental_revenue

FROM fact_events 

GROUP BY store_id    

ORDER BY incremental_revenue DESC

LIMIT 10 ;
