
-- QUERIES: NML vs STAR

USE ROLE RACCOON_ROLE;
USE WAREHOUSE ANIMAL_TASK_WH;
USE DATABASE Z_DB_RACCOON;
USE SCHEMA PUBLIC;

-- ============================================================
-- PART 1: QUERY ON NORMALIZED SCHEMA
-- ============================================================
-- Business Question: Show total revenue and quantity sold
-- per product category, per region, per quarter in 2024.
-- Notice how many JOINs are required!

SELECT
    r.REGION_NAME,
    cat.CATEGORY_NAME,
    CONCAT('Q', QUARTER(o.ORDER_DATE), ' ', YEAR(o.ORDER_DATE)) AS QUARTER,
    SUM(oi.QUANTITY)                                              AS TOTAL_QTY,
    SUM(oi.QUANTITY * oi.UNIT_PRICE * (1 - oi.DISCOUNT_PCT))     AS TOTAL_REVENUE
FROM NML_ORDER_ITEMS   oi
JOIN NML_ORDERS         o   ON oi.ORDER_ID    = o.ORDER_ID
JOIN NML_CUSTOMERS      c   ON o.CUSTOMER_ID  = c.CUSTOMER_ID
JOIN NML_CITIES         ci  ON c.CITY_ID      = ci.CITY_ID
JOIN NML_STATES         s   ON ci.STATE_ID    = s.STATE_ID
JOIN NML_REGIONS        r   ON s.REGION_ID    = r.REGION_ID
JOIN NML_PRODUCTS       p   ON oi.PRODUCT_ID  = p.PRODUCT_ID
JOIN NML_CATEGORIES     cat ON p.CATEGORY_ID  = cat.CATEGORY_ID
WHERE o.ORDER_DATE >= '2024-01-01' AND o.ORDER_DATE < '2025-01-01'
GROUP BY r.REGION_NAME, cat.CATEGORY_NAME, QUARTER
ORDER BY r.REGION_NAME, QUARTER, TOTAL_REVENUE DESC;

-- ============================================================
-- PART 2: SAME QUERY ON STAR SCHEMA
-- ============================================================
-- Same business question: total revenue and quantity sold
-- per category, per region, per quarter.
-- Notice: only 3 JOINs instead of 7!

SELECT
    dc.REGION_NAME,
    dp.CATEGORY_NAME,
    CONCAT('Q', dd.QUARTER, ' ', dd.YEAR) AS QUARTER,
    SUM(fs.QUANTITY)                       AS TOTAL_QTY,
    SUM(fs.NET_AMOUNT)                     AS TOTAL_REVENUE
FROM STAR_FACT_SALES    fs
JOIN STAR_DIM_DATE      dd ON fs.DATE_KEY     = dd.DATE_KEY
JOIN STAR_DIM_CUSTOMER  dc ON fs.CUSTOMER_KEY = dc.CUSTOMER_KEY
JOIN STAR_DIM_PRODUCT   dp ON fs.PRODUCT_KEY  = dp.PRODUCT_KEY
WHERE dd.YEAR = 2024
GROUP BY dc.REGION_NAME, dp.CATEGORY_NAME, dd.QUARTER, dd.YEAR
ORDER BY dc.REGION_NAME, CONCAT('Q', dd.QUARTER, ' ', dd.YEAR), TOTAL_REVENUE DESC;

-- ============================================================
-- BONUS: Additional star schema queries that are now easy
-- ============================================================

-- Top 5 customers by total spend
SELECT
    dc.FIRST_NAME || ' ' || dc.LAST_NAME AS CUSTOMER_NAME,
    dc.REGION_NAME,
    COUNT(DISTINCT fs.ORDER_ID) AS NUM_ORDERS,
    SUM(fs.NET_AMOUNT)          AS TOTAL_SPEND
FROM STAR_FACT_SALES   fs
JOIN STAR_DIM_CUSTOMER dc ON fs.CUSTOMER_KEY = dc.CUSTOMER_KEY
GROUP BY CUSTOMER_NAME, dc.REGION_NAME
ORDER BY TOTAL_SPEND DESC
LIMIT 5;

-- Inventory items that need reorder, with product and warehouse details
SELECT
    dp.PRODUCT_NAME,
    dp.CATEGORY_NAME,
    dw.WAREHOUSE_NAME,
    dw.REGION_NAME,
    fi.QTY_ON_HAND,
    fi.REORDER_LEVEL
FROM STAR_FACT_INVENTORY fi
JOIN STAR_DIM_PRODUCT    dp ON fi.PRODUCT_KEY   = dp.PRODUCT_KEY
JOIN STAR_DIM_WAREHOUSE  dw ON fi.WAREHOUSE_KEY = dw.WAREHOUSE_KEY
WHERE fi.NEEDS_REORDER = TRUE
ORDER BY dp.CATEGORY_NAME, dp.PRODUCT_NAME;
