SELECT  
    SUM(quantity_sold_after_promo) - SUM(quantity_sold_before_promo) AS incremental_sold_units,
    store_id,
    
FROM fact_events

GROUP BY ds.store_id   

ORDER BY incremental_sold_units ASC

LIMIT 10;
