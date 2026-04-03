-- PROJECT 1: RETAIL SALES PERFORMANCE ANALYSIS
-- Purpose: Deep dive investigation queries run during profiling

-- Central region sub-category breakdown
SELECT
    region,
    sub_category,
    COUNT(*)                                    AS transactions,
    ROUND(AVG(discount * 100)::NUMERIC, 1)      AS avg_discount_pct,
    ROUND(SUM(profit)::NUMERIC, 2)              AS total_profit,
    ROUND(AVG(profit_margin)::NUMERIC, 2)       AS avg_margin
FROM cleaned_sales
WHERE region = 'Central'
GROUP BY region, sub_category
ORDER BY avg_margin ASC;

-- Customer segment deep dive
SELECT
    segment,
    COUNT(DISTINCT customer_id)                 AS customer_count,
    ROUND(SUM(profit)::NUMERIC, 2)              AS total_profit,
    ROUND(
        SUM(profit) / 
        NULLIF(COUNT(DISTINCT customer_id), 0)::NUMERIC
    , 2)                                        AS profit_per_customer,
    ROUND(AVG(discount * 100)::NUMERIC, 1)      AS avg_discount_pct
FROM cleaned_sales
GROUP BY segment
ORDER BY profit_per_customer DESC;