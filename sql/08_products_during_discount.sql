WITH discount_sales AS (
    SELECT
        dp.category,
    
        SUM(fe.base_price * fe.quantity_sold_after_promo) - SUM(fe.base_price * fe.quantity_sold_before_promo) AS sales_lift_revenue,
        SUM(fe.quantity_sold_after_promo) - SUM(fe.quantity_sold_before_promo) AS sales_lift_sold_units,
        (SUM(fe.quantity_sold_after_promo) - SUM(fe.quantity_sold_before_promo)) * 100 / SUM(fe.quantity_sold_before_promo) AS sales_lift_sold_percentage

    FROM fact_events fe
    INNER JOIN dim_products dp
    ON fe.product_code = dp.product_code

    WHERE fe.promo_type IN ('50% OFF', '33% OFF', '25% OFF')  

    GROUP BY dp.category
)
SELECT
    category,
    sales_lift_revenue,
    sales_lift_sold_units,
    sales_lift_sold_percentage

FROM discount_sales

ORDER BY sales_lift_revenue DESC;
