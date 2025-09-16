WITH event_calculations AS (
    SELECT 
        fe.promo_type,
        fe.base_price * cm.cost_margin / 100 AS cost_price,
        fe.base_price - (fe.base_price * cm.cost_margin / 100) AS profit_per_unit,
        fe.quantity_sold_after_promo - fe.quantity_sold_before_promo AS incremental_units
    FROM fact_events fe
    INNER JOIN cost_margin cm 
    ON fe.product_code = cm.product_code
),
promo_summary AS (
    SELECT 
        promo_type,
        SUM(incremental_units) AS total_incremental_units,
        SUM(profit_per_unit * incremental_units) AS total_incremental_profit,
        AVG(profit_per_unit) AS avg_profit_per_unit,
        CASE
            WHEN AVG(profit_per_unit) < 300 THEN 'Low Margin'
            WHEN AVG(profit_per_unit) BETWEEN 300 AND 900 THEN 'Healthy Margin'
            ELSE 'High Margin'
        END AS profit_margin_bucket
    FROM event_calculations
    GROUP BY promo_type
),
promo_ranks AS (
    SELECT 
        promo_type,
        total_incremental_units,
        total_incremental_profit,
        avg_profit_per_unit,
        profit_margin_bucket,
        RANK() OVER (ORDER BY total_incremental_units DESC) AS rank_by_units,
        RANK() OVER (ORDER BY avg_profit_per_unit DESC) AS rank_by_profit_per_unit
    FROM promo_summary
)
SELECT 
    promo_type,
    total_incremental_units,
    total_incremental_profit,
    avg_profit_per_unit,
    profit_margin_bucket,
    rank_by_units,
    rank_by_profit_per_unit,
    (rank_by_units + rank_by_profit_per_unit) AS optimal_balance_score  -- lower = better balance
FROM promo_ranks
ORDER BY optimal_balance_score ASC, total_incremental_units DESC;
