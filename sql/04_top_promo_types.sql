SELECT 
       promo_type,
       SUM(base_price * quantity_sold_before_promo) AS revenue_before,
       SUM(base_price * quantity_sold_after_promo) AS revenue_after,
       SUM(base_price * quantity_sold_after_promo) - SUM(base_price * quantity_sold_before_promo) AS incremental_revenue
       
FROM fact_events 

GROUP BY promo_type
ORDER BY incremental_revenue DESC
LIMIT 2;
