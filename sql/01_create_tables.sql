--PROJECT 1: RETAIL SALES PERFORMANCE ANALYSIS
-- Purpose: Creates the raw_sales table structure

CREATE TABLE raw_sales (
    row_id          INTEGER,
    order_id        VARCHAR(20),
    order_date      DATE,
    ship_date       DATE,
    ship_mode       VARCHAR(50),
    customer_id     VARCHAR(20),
    customer_name   VARCHAR(100),
    segment         VARCHAR(50),
    country         VARCHAR(50),
    city            VARCHAR(100),
    state           VARCHAR(50),
    postal_code     VARCHAR(20),
    region          VARCHAR(20),
    product_id      VARCHAR(20),
    category        VARCHAR(50),
    sub_category    VARCHAR(50),
    product_name    VARCHAR(255),
    sales           NUMERIC(10,2),
    quantity        INTEGER,
    discount        NUMERIC(5,2),
    profit          NUMERIC(10,2)
);