WITH store_performance AS (
    SELECT 
        ds.city,
        ds.store_id,

        SUM(fe.base_price * (fe.quantity_sold_after_promo - fe.quantity_sold_before_promo)) AS store_incremental_revenue,
        SUM(fe.quantity_sold_after_promo - fe.quantity_sold_before_promo) AS store_incremental_units
        
    FROM u131628650_supermart365.fact_events fe

    INNER JOIN u131628650_supermart365.dim_stores ds 
    ON fe.store_id = ds.store_id

    GROUP BY ds.city, ds.store_id)

SELECT 
    city,
    COUNT(store_id) AS stores_in_city,
    AVG(store_incremental_revenue) AS avg_store_revenue,
    SUM(store_incremental_revenue) AS total_city_revenue,
    SUM(store_incremental_units) AS total_city_units

FROM store_performance

GROUP BY city

ORDER BY avg_store_revenue DESC;
