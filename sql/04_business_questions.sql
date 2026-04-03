-- PROJECT 1: RETAIL SALES PERFORMANCE ANALYSIS
-- Purpose: Answers the 7 core business questions

-- Q1: Top 10 Most Profitable Products
-- Business context: Where should we double down?

SELECT
    product_name,
    category,
    sub_category,
    COUNT(DISTINCT order_id)                    AS total_orders,
    ROUND(SUM(sales)::NUMERIC, 2)               AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2)              AS total_profit,
    ROUND(AVG(profit_margin)::NUMERIC, 2)       AS avg_profit_margin
FROM cleaned_sales
GROUP BY product_name, category, sub_category
ORDER BY total_profit DESC
LIMIT 10;

-- Q2: Products Losing Money
-- Business context: What should we reprice or discontinue?

SELECT
    product_name,
    category,
    sub_category,
    COUNT(DISTINCT order_id)                    AS times_ordered,
    ROUND(SUM(sales)::NUMERIC, 2)               AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2)              AS total_loss,
    ROUND(AVG(discount * 100)::NUMERIC, 1)      AS avg_discount_pct
FROM cleaned_sales
GROUP BY product_name, category, sub_category
HAVING SUM(profit) < 0
ORDER BY total_loss ASC
LIMIT 15;

-- Q3: Monthly Revenue Trend
-- Business context: When should we ramp up marketing/inventory?

SELECT
    order_year,
    order_month,
    COUNT(DISTINCT order_id)                    AS total_orders,
    ROUND(SUM(sales)::NUMERIC, 2)               AS monthly_revenue,
    ROUND(SUM(profit)::NUMERIC, 2)              AS monthly_profit,
    ROUND(AVG(profit_margin)::NUMERIC, 2)       AS avg_margin
FROM cleaned_sales
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

-- Q4: Regional Performance
-- Business context: Where should we expand or pull back?

SELECT
    region,
    COUNT(DISTINCT customer_id)                 AS unique_customers,
    COUNT(DISTINCT order_id)                    AS total_orders,
    ROUND(SUM(sales)::NUMERIC, 2)               AS total_revenue,
    ROUND(SUM(profit)::NUMERIC, 2)              AS total_profit,
    ROUND(AVG(profit_margin)::NUMERIC, 2)       AS avg_margin,
    ROUND(
        SUM(sales) / 
        NULLIF(COUNT(DISTINCT order_id), 0)::NUMERIC
    , 2)                                        AS avg_order_value
FROM cleaned_sales
GROUP BY region
ORDER BY total_profit DESC;

-- Q5: Customer Segment Value
-- Business context: Who should we focus sales & marketing on?

SELECT
    segment,
    COUNT(DISTINCT customer_id)                 AS customer_count,
    COUNT(DISTINCT order_id)                    AS total_orders,
    ROUND(SUM(sales)::NUMERIC, 2)               AS total_revenue,
    ROUND(SUM(profit)::NUMERIC, 2)              AS total_profit,
    ROUND(
        SUM(profit) / 
        NULLIF(COUNT(DISTINCT customer_id), 0)::NUMERIC
    , 2)                                        AS profit_per_customer
FROM cleaned_sales
GROUP BY segment
ORDER BY profit_per_customer DESC;

-- Q6: Shipping Mode Impact
-- Business context: Are we losing money on how we ship?

SELECT
    ship_mode,
    COUNT(*)                                    AS total_transactions,
    ROUND(AVG(sales)::NUMERIC, 2)               AS avg_sale,
    ROUND(AVG(profit)::NUMERIC, 2)              AS avg_profit,
    ROUND(AVG(profit_margin)::NUMERIC, 2)       AS avg_margin,
    ROUND(AVG(days_to_ship)::NUMERIC, 1)        AS avg_days_to_ship,
    ROUND(SUM(profit)::NUMERIC, 2)              AS total_profit
FROM cleaned_sales
GROUP BY ship_mode
ORDER BY avg_margin DESC;

-- Q7: Year Over Year Category Growth
-- Business context: Which categories are growing or declining?

WITH yearly AS (
    SELECT
        category,
        order_year,
        ROUND(SUM(sales)::NUMERIC, 2)           AS annual_sales,
        ROUND(SUM(profit)::NUMERIC, 2)          AS annual_profit
    FROM cleaned_sales
    GROUP BY category, order_year
)
SELECT
    category,
    order_year,
    annual_sales,
    annual_profit,
    LAG(annual_sales) OVER (
        PARTITION BY category 
        ORDER BY order_year
    )                                           AS prev_year_sales,
    ROUND(
        (
            (annual_sales - LAG(annual_sales) OVER (
                PARTITION BY category ORDER BY order_year)
            ) / NULLIF(LAG(annual_sales) OVER (
                PARTITION BY category ORDER BY order_year), 0
            ) * 100
        )::NUMERIC
    , 2)                                        AS yoy_growth_pct
FROM yearly
ORDER BY category, order_year;