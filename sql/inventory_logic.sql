USE projekt_auta;

DROP TABLE IF EXISTS final_cars_report;

CREATE TABLE final_cars_report AS
SELECT 
    make_name,
    model_name,
    year,
    price,
    daysonmarket,
    (daysonmarket * 40) as holding_cost,
    CASE 
        WHEN daysonmarket <= 30 THEN '1. Fresh (<30d)'
        WHEN daysonmarket <= 60 THEN '2. Standard (30-60d)'
        WHEN daysonmarket <= 90 THEN '3. Slow (60-90d)'
        ELSE '4. TRAP (>90d)'
    END as inventory_status
FROM automotive_analysis_clean_cars
WHERE price BETWEEN 2000 AND 200000;

SELECT 
    inventory_status, 
    COUNT(*) as car_count,
    ROUND(SUM(holding_cost) / 1000000, 2) as total_loss_mln_usd
FROM final_cars_report
GROUP BY inventory_status
ORDER BY inventory_status;

CREATE OR REPLACE VIEW brand_model_loss_analysis AS
WITH model_stats AS (
    SELECT 
        make_name, 
        model_name, 
        SUM(holding_cost) as total_model_loss
    FROM final_cars_report
    GROUP BY make_name, model_name
)
SELECT 
    make_name,
    model_name,
    ROUND(total_model_loss, 2) as total_loss_usd,
    ROUND(100 * total_model_loss / SUM(total_model_loss) OVER(PARTITION BY make_name), 2) as brand_loss_contribution_pct,
    RANK() OVER(PARTITION BY make_name ORDER BY total_model_loss DESC) as brand_rank
FROM model_stats;

SELECT * FROM brand_model_loss_analysis
WHERE brand_rank <= 3
ORDER BY total_loss_usd DESC
LIMIT 20;
