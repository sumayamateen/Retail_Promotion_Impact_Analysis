WITH promotion_performance AS (
    SELECT 
        CASE
            WHEN promo_type IN ('50% OFF','33% OFF','25% OFF') THEN 'Discount' 
            WHEN promo_type = 'BOGOF' THEN 'BOGOF' 
            WHEN promo_type = '500 Cashback' THEN 'Cashback' 
        END AS promotion_category,
                
        SUM(base_price * (quantity_sold_after_promo - quantity_sold_before_promo)) AS incremental_revenue,
        SUM(quantity_sold_after_promo - quantity_sold_before_promo) AS incremental_sold_units
    FROM fact_events 
    GROUP BY promotion_category
)

SELECT 
    promotion_category,
    incremental_revenue,
    incremental_sold_units,
    RANK() OVER (ORDER BY incremental_revenue DESC) AS incremental_revenue_rank,
    RANK() OVER (ORDER BY incremental_sold_units DESC) AS incremental_sold_units_rank
FROM promotion_performance
ORDER BY incremental_revenue DESC;
