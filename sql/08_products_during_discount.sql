SELECT dm.category,
       SUM(fe.base_price * fe.quantity_sold_after_promo) - SUM(fe.base_price * fe.quantity_sold_before_promo) AS sales_lift_revenue,
       SUM(fe.quantity_sold_after_promo) - SUM(fe.quantity_sold_before_promo) AS sales_lift_sold_units,
       (SUM(fe.quantity_sold_after_promo) - SUM(fe.quantity_sold_before_promo)) * 100 / SUM(fe.quantity_sold_before_promo) AS sales_lift_sold_percentage,
       COUNT(DISTINCT fe.product_code) AS products_discounted,
       COUNT(DISTINCT fe.campaign_id) AS campaigns_included
	   
FROM u131628650_supermart365.fact_events fe

INNER JOIN u131628650_supermart365.dim_products dm 
ON fe.product_code = dm.product_code

WHERE (fe.promo_type LIKE '%OFF%'
       OR fe.promo_type LIKE '%DISC%'
       OR fe.promo_type LIKE '%SALE%')
	   
GROUP BY dm.category

ORDER BY sales_lift_sold_percentage DESC
