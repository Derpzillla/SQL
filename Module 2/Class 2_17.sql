-- Activity part 1 

-- write one query that returns for each market segment, how many orders in total, what is the average amount of money customers spent per order, sum of all order totals



SELECT 
    C.C_MKTSEGMENT AS market_segment,
    COUNT(*) AS total_orders,
    AVG(O.O_TOTALPRICE) AS avg_order_amount,
    SUM(O.O_TOTALPRICE) AS total_revenue
FROM ORDERS O
JOIN CUSTOMER C ON O.O_CUSTKEY = C.C_CUSTKEY
GROUP BY C.C_MKTSEGMENT
ORDER BY total_revenue DESC;

-- RFM Analysis: Recency, Frequency, Monetary metrics for every customer
SELECT 
    C.C_CUSTKEY,
    C.C_NAME,
    DATEDIFF('day', MAX(O.O_ORDERDATE), (SELECT MAX(O_ORDERDATE) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS)) AS recency_days,
    COUNT(O.O_ORDERKEY) AS frequency,
    SUM(O.O_TOTALPRICE) AS monetary
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O ON C.C_CUSTKEY = O.O_CUSTKEY
GROUP BY C.C_CUSTKEY, C.C_NAME
ORDER BY C.C_CUSTKEY;

-- Activity part 3

-- Recency scoring with subquery in FROM clause
SELECT 
    r.C_CUSTKEY,
    r.C_NAME,
    r.recency_days,
    CASE 
        WHEN r.recency_days <= 30 THEN 5
        WHEN r.recency_days <= 90 THEN 4
        WHEN r.recency_days <= 180 THEN 3
        WHEN r.recency_days <= 365 THEN 2
        ELSE 1
    END AS recency_score
FROM (
    SELECT 
        C.C_CUSTKEY,
        C.C_NAME,
        DATEDIFF('day', MAX(O.O_ORDERDATE), (SELECT MAX(O_ORDERDATE) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS)) AS recency_days
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
    LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O ON C.C_CUSTKEY = O.O_CUSTKEY
    GROUP BY C.C_CUSTKEY, C.C_NAME
) r
ORDER BY recency_score DESC, recency_days ASC;

-- Activity 4 CTEs

WITH recency_cte AS (
    SELECT 
        C.C_CUSTKEY,
        C.C_NAME,
        DATEDIFF('day', MAX(O.O_ORDERDATE), (SELECT MAX(O_ORDERDATE) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS)) AS recency_days
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
    LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O ON C.C_CUSTKEY = O.O_CUSTKEY
    GROUP BY C.C_CUSTKEY, C.C_NAME
)
SELECT 
    r.C_CUSTKEY,
    r.C_NAME,
    r.recency_days,
    CASE 
        WHEN r.recency_days <= 30 THEN 5
        WHEN r.recency_days <= 90 THEN 4
        WHEN r.recency_days <= 180 THEN 3
        WHEN r.recency_days <= 365 THEN 2
        ELSE 1
    END AS recency_score
FROM recency_cte r
ORDER BY recency_score DESC, recency_days ASC;

-- Activity part 5: Create a view

create or replace view z_db_raccoon.public.v_mktsegment_status as
SELECT 
        C.C_CUSTKEY,
        C.C_NAME,
        DATEDIFF('day', MAX(O.O_ORDERDATE), (SELECT MAX(O_ORDERDATE) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS)) AS recency_days
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
    LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O ON C.C_CUSTKEY = O.O_CUSTKEY
    GROUP BY C.C_CUSTKEY, C.C_NAME;
    

select *
from z_db_instructor1.module2.v_customer_rfm
limit 10;

-- Activity part 6: CTAS

create or replace view z_db_raccoon.public.v_mktsegment_status as
select * 
from z_db_instructor1.module2.v_mktsegment_stats;