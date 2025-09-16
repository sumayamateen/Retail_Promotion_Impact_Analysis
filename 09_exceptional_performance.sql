WITH product_performance AS (
    SELECT 
        dp.product_code,
        dp.product_name,
        dp.category, 

        SUM(fe.base_price * fe.quantity_sold_before_promo) AS revenue_before,
        SUM(fe.base_price * fe.quantity_sold_after_promo) AS revenue_after, 
        SUM(fe.base_price * (fe.quantity_sold_after_promo - fe.quantity_sold_before_promo)) AS incremental_revenue,
        SUM(fe.quantity_sold_after_promo - fe.quantity_sold_before_promo) AS incremental_sold_units

    FROM fact_events fe
    INNER JOIN dim_products dp
    ON fe.product_code = dp.product_code
    GROUP BY dp.product_code, dp.product_name, dp.category
)
SELECT 
    product_code,
    product_name,
    category,
    incremental_revenue,
    incremental_sold_units,
    CASE
        WHEN incremental_revenue > 0 AND incremental_sold_units > 0 THEN 'Exceptional Positive'
        WHEN incremental_revenue < 0 AND incremental_sold_units < 0 THEN 'Exceptional Negative'
        WHEN incremental_revenue > 0 AND incremental_sold_units < 0 THEN 'Mixed (Revenue ↑, Units ↓)' 
        WHEN incremental_revenue < 0 AND incremental_sold_units > 0 THEN 'Mixed (Revenue ↓, Units ↑)'
    END AS performance_flag
 
FROM product_performance
ORDER BY incremental_revenue DESC;
