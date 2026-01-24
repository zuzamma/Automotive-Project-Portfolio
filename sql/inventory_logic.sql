-- #############################################################
-- PHASE 1: DATA PREPARATION & INITIAL SEGMENTATION
-- #############################################################

USE projekt_auta;

-- Create the final reporting table with business logic
DROP TABLE IF EXISTS final_cars_report;

CREATE TABLE final_cars_report AS
SELECT 
    make_name,
    model_name,
    year,
    price,
    daysonmarket,
    -- Calculate holding cost: $40 USD per day per car
    (daysonmarket * 40) as holding_cost,
    -- Inventory Age Segmentation
    CASE 
        WHEN daysonmarket <= 30 THEN '1. Fresh (<30d)'
        WHEN daysonmarket <= 60 THEN '2. Standard (30-60d)'
        WHEN daysonmarket <= 90 THEN '3. Slow (60-90d)'
        ELSE '4. TRAP (>90d)'
    END as inventory_status
FROM automotive_analysis_clean_cars
WHERE price BETWEEN 2000 AND 200000;

-- #############################################################
-- PHASE 2: EXECUTIVE SUMMARY (High-Level Metrics)
-- #############################################################

-- Calculate total volume and financial impact by segment
SELECT 
    inventory_status, 
    COUNT(*) as car_count,
    ROUND(SUM(holding_cost) / 1000000, 2) as total_loss_mln_usd
FROM final_cars_report
GROUP BY inventory_status
ORDER BY inventory_status;

-- #############################################################
-- PHASE 3: ADVANCED ANALYSIS (Window Functions)
-- #############################################################

-- Creating a View to identify "Loss Leaders" within each brand
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
    -- Calculate % contribution of the model to the total brand's loss
    ROUND(100 * total_model_loss / SUM(total_model_loss) OVER(PARTITION BY make_name), 2) as brand_loss_contribution_pct,
    -- Rank models by loss within their respective brands
    RANK() OVER(PARTITION BY make_name ORDER BY total_model_loss DESC) as brand_rank
FROM model_stats;

-- Display the Top 3 most expensive models for the most problematic brands
SELECT * FROM brand_model_loss_analysis
WHERE brand_rank <= 3
ORDER BY total_loss_usd DESC
LIMIT 20;