WITH category_promo_performance AS (
    SELECT 
        dp.category,

        fe.promo_type,
        SUM(fe.base_price * (fe.quantity_sold_after_promo - fe.quantity_sold_before_promo)) AS incremental_revenue,
        SUM(fe.quantity_sold_after_promo - fe.quantity_sold_before_promo) AS incremental_units

    FROM fact_events fe

    INNER JOIN dim_products dp 
    ON fe.product_code = dp.product_code
    GROUP BY dp.category, fe.promo_type
)
SELECT 
    category,
    promo_type,
    incremental_revenue,
    incremental_units,
    RANK() OVER (PARTITION BY category ORDER BY incremental_revenue DESC) AS revenue_rank_in_category,
    RANK() OVER (PARTITION BY category ORDER BY incremental_units DESC) AS units_rank_in_category

FROM category_promo_performance

ORDER BY category,incremental_revenue DESC;
