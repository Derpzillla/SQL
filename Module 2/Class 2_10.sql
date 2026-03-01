-- Activity part 1

-- Explore new dataset, use limit, sample.

-- inital q's, how many tables, what in tables, how many rows in each table?

show tables;

describe table customer;

select * 
from customer
limit 10;

-- gets total number of customers
select count(*)
from customer;

describe table orders;

-- Activity part 3a.

select c_custkey,
c_acctbal,
c_mktsegment
from customer
limit 5;

select min(c_acctbal) as min_acct_bal,
max(c_acctbal),
avg(c_acctbal),
count(*) - count(c_acctbal) as missing_acct_bal
from customer;

select c_custkey,
c_mktsegment
from customer
limit 5;

select distinct c_mktsegment
from customer;

-- Activity Part 3b

-- Comprehensive data profiling for CUSTOMER table

-- Numerical columns: C_CUSTKEY, C_NATIONKEY, C_ACCTBAL
SELECT 
    'C_CUSTKEY' AS column_name,
    COUNT(*) AS n,
    COUNT(*) - COUNT(C_CUSTKEY) AS missing_count,
    ROUND((COUNT(*) - COUNT(C_CUSTKEY)) * 100.0 / COUNT(*), 2) AS missing_pct,
    MIN(C_CUSTKEY) AS min_value,
    MAX(C_CUSTKEY) AS max_value
FROM CUSTOMER
UNION ALL
SELECT 
    'C_NATIONKEY',
    COUNT(*),
    COUNT(*) - COUNT(C_NATIONKEY),
    ROUND((COUNT(*) - COUNT(C_NATIONKEY)) * 100.0 / COUNT(*), 2),
    MIN(C_NATIONKEY),
    MAX(C_NATIONKEY)
FROM CUSTOMER
UNION ALL
SELECT 
    'C_ACCTBAL',
    COUNT(*),
    COUNT(*) - COUNT(C_ACCTBAL),
    ROUND((COUNT(*) - COUNT(C_ACCTBAL)) * 100.0 / COUNT(*), 2),
    MIN(C_ACCTBAL),
    MAX(C_ACCTBAL)
FROM CUSTOMER;

-- Categorical columns: C_MKTSEGMENT (with value counts and percentages)
SELECT 
    'C_MKTSEGMENT' AS column_name,
    C_MKTSEGMENT AS value,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    ROUND(SUM(CASE WHEN C_MKTSEGMENT IS NULL THEN 1 ELSE 0 END) OVER() * 100.0 / COUNT(*) OVER(), 2) AS missing_pct
FROM CUSTOMER
GROUP BY C_MKTSEGMENT
ORDER BY count DESC;

-- Summary stats for all categorical columns (C_NAME, C_ADDRESS, C_PHONE, C_MKTSEGMENT, C_COMMENT)
SELECT 
    'C_NAME' AS column_name,
    COUNT(*) AS n,
    COUNT(DISTINCT C_NAME) AS unique_values,
    COUNT(*) - COUNT(C_NAME) AS missing_count,
    ROUND((COUNT(*) - COUNT(C_NAME)) * 100.0 / COUNT(*), 2) AS missing_pct
FROM CUSTOMER
UNION ALL
SELECT 'C_ADDRESS', COUNT(*), COUNT(DISTINCT C_ADDRESS), COUNT(*) - COUNT(C_ADDRESS),
    ROUND((COUNT(*) - COUNT(C_ADDRESS)) * 100.0 / COUNT(*), 2) FROM CUSTOMER
UNION ALL
SELECT 'C_PHONE', COUNT(*), COUNT(DISTINCT C_PHONE), COUNT(*) - COUNT(C_PHONE),
    ROUND((COUNT(*) - COUNT(C_PHONE)) * 100.0 / COUNT(*), 2) FROM CUSTOMER
UNION ALL
SELECT 'C_MKTSEGMENT', COUNT(*), COUNT(DISTINCT C_MKTSEGMENT), COUNT(*) - COUNT(C_MKTSEGMENT),
    ROUND((COUNT(*) - COUNT(C_MKTSEGMENT)) * 100.0 / COUNT(*), 2) FROM CUSTOMER
UNION ALL
SELECT 'C_COMMENT', COUNT(*), COUNT(DISTINCT C_COMMENT), COUNT(*) - COUNT(C_COMMENT),
    ROUND((COUNT(*) - COUNT(C_COMMENT)) * 100.0 / COUNT(*), 2) FROM CUSTOMER;

