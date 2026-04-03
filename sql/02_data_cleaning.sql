-- PROJECT 1: RETAIL SALES PERFORMANCE ANALYSIS
-- Purpose: Profiles raw data, creates cleaned table, adds calculated columns

-- SECTION 1: DATA PROFILING

-- Basic health check
SELECT 
    COUNT(*)                                    AS total_rows,
    COUNT(DISTINCT order_id)                    AS unique_orders,
    COUNT(DISTINCT customer_id)                 AS unique_customers,
    COUNT(DISTINCT product_id)                  AS unique_products,
    MIN(order_date)                             AS earliest_order,
    MAX(order_date)                             AS latest_order
FROM raw_sales;

-- Duplicate check
SELECT 
    row_id,
    order_id,
    product_id,
    COUNT(*) AS occurrences
FROM raw_sales
GROUP BY row_id, order_id, product_id
HAVING COUNT(*) > 1;

-- NULL value check
SELECT
    SUM(CASE WHEN order_id       IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN customer_id    IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN product_id     IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN sales          IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit         IS NULL THEN 1 ELSE 0 END) AS null_profit,
    SUM(CASE WHEN postal_code    IS NULL THEN 1 ELSE 0 END) AS null_postal_code,
    SUM(CASE WHEN region         IS NULL THEN 1 ELSE 0 END) AS null_region,
    SUM(CASE WHEN ship_date      IS NULL THEN 1 ELSE 0 END) AS null_ship_date
FROM raw_sales;

-- Category consistency check
SELECT DISTINCT region       FROM raw_sales ORDER BY region;
SELECT DISTINCT segment      FROM raw_sales ORDER BY segment;
SELECT DISTINCT category     FROM raw_sales ORDER BY category;
SELECT DISTINCT sub_category FROM raw_sales ORDER BY sub_category;
SELECT DISTINCT ship_mode    FROM raw_sales ORDER BY ship_mode;

-- Numeric range check
SELECT
    MIN(sales)      AS min_sales,
    MAX(sales)      AS max_sales,
    AVG(sales)      AS avg_sales,
    MIN(profit)     AS min_profit,
    MAX(profit)     AS max_profit,
    MIN(quantity)   AS min_quantity,
    MAX(quantity)   AS max_quantity,
    MIN(discount)   AS min_discount,
    MAX(discount)   AS max_discount
FROM raw_sales;

-- Negative profit check
SELECT
    COUNT(*)                                        AS negative_profit_rows,
    ROUND(SUM(profit)::NUMERIC, 2)                  AS total_profit_loss,
    ROUND(AVG(profit)::NUMERIC, 2)                  AS avg_profit_loss,
    ROUND(MIN(profit)::NUMERIC, 2)                  AS worst_single_loss
FROM raw_sales
WHERE profit < 0;

-- SECTION 2: DISCOUNT INVESTIGATION

-- Worst single transactions
SELECT
    order_id,
    product_name,
    category,
    sub_category,
    sales,
    profit,
    discount,
    quantity,
    ROUND((profit / NULLIF(sales, 0) * 100)::NUMERIC, 2) AS profit_margin_pct
FROM raw_sales
WHERE profit < -1000
ORDER BY profit ASC;

-- Discount bucket analysis
WITH discount_buckets AS (
    SELECT
        CASE
            WHEN discount = 0       THEN '0% No Discount'
            WHEN discount <= 0.10   THEN '1-10%'
            WHEN discount <= 0.20   THEN '11-20%'
            WHEN discount <= 0.30   THEN '21-30%'
            WHEN discount <= 0.50   THEN '31-50%'
            ELSE                         'Over 50%'
        END AS discount_bucket,
        CASE
            WHEN discount = 0       THEN 1
            WHEN discount <= 0.10   THEN 2
            WHEN discount <= 0.20   THEN 3
            WHEN discount <= 0.30   THEN 4
            WHEN discount <= 0.50   THEN 5
            ELSE                         6
        END AS bucket_order,
        sales,
        profit
    FROM raw_sales
)
SELECT
    discount_bucket,
    COUNT(*)                                    AS transactions,
    ROUND(SUM(sales)::NUMERIC, 2)               AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2)              AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) 
        * 100)::NUMERIC, 2
    )                                           AS profit_margin_pct
FROM discount_buckets
GROUP BY discount_bucket, bucket_order
ORDER BY bucket_order;

-- SECTION 3: CLEANING

-- Create cleaned table removing duplicates
CREATE TABLE cleaned_sales AS
WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY row_id, order_id, product_id
            ORDER BY row_id
        ) AS rn
    FROM raw_sales
)
SELECT * FROM ranked WHERE rn = 1;

-- Drop helper column
ALTER TABLE cleaned_sales DROP COLUMN rn;

-- Trim whitespace from text columns
UPDATE cleaned_sales SET region        = TRIM(region);
UPDATE cleaned_sales SET city          = TRIM(city);
UPDATE cleaned_sales SET state         = TRIM(state);
UPDATE cleaned_sales SET segment       = TRIM(segment);
UPDATE cleaned_sales SET category      = TRIM(category);
UPDATE cleaned_sales SET sub_category  = TRIM(sub_category);
UPDATE cleaned_sales SET ship_mode     = TRIM(ship_mode);
UPDATE cleaned_sales SET customer_name = TRIM(customer_name);
UPDATE cleaned_sales SET product_name  = TRIM(product_name);

-- Add calculated columns
ALTER TABLE cleaned_sales ADD COLUMN profit_margin  NUMERIC(10,2);
ALTER TABLE cleaned_sales ADD COLUMN order_year     INTEGER;
ALTER TABLE cleaned_sales ADD COLUMN order_month    INTEGER;
ALTER TABLE cleaned_sales ADD COLUMN days_to_ship   INTEGER;

UPDATE cleaned_sales
SET profit_margin = ROUND(
    (profit / NULLIF(sales, 0) * 100)::NUMERIC, 2
);

UPDATE cleaned_sales
SET order_year = EXTRACT(YEAR FROM order_date);

UPDATE cleaned_sales
SET order_month = EXTRACT(MONTH FROM order_date);

UPDATE cleaned_sales
SET days_to_ship = (ship_date - order_date);

-- SECTION 4: VALIDATION

-- Compare row counts
SELECT 'raw_sales'     AS source, COUNT(*) AS rows FROM raw_sales
UNION ALL
SELECT 'cleaned_sales' AS source, COUNT(*) AS rows FROM cleaned_sales;

-- Confirm no NULLs in new columns
SELECT
    SUM(CASE WHEN profit_margin IS NULL THEN 1 ELSE 0 END) AS null_margin,
    SUM(CASE WHEN order_year    IS NULL THEN 1 ELSE 0 END) AS null_year,
    SUM(CASE WHEN order_month   IS NULL THEN 1 ELSE 0 END) AS null_month,
    SUM(CASE WHEN days_to_ship  IS NULL THEN 1 ELSE 0 END) AS null_ship
FROM cleaned_sales;

-- Spot check calculated columns
SELECT
    sales,
    profit,
    profit_margin,
    order_year,
    order_month,
    days_to_ship
FROM cleaned_sales
LIMIT 10;