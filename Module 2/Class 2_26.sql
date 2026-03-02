-- Activity 1

select s_suppkey,
s_name,
s_nationkey,
n_name,
n_regionkey,
r_name
from supplier s
inner join nation n on s.s_nationkey = n.n_nationkey
inner join region r on n.n_regionkey = r.r_regionkey
where s_suppkey =1;

select *
from partsupp
where ps_suppkey =1;

SELECT PS.PS_PARTKEY, P.P_NAME
FROM PARTSUPP PS
JOIN PART P ON PS.PS_PARTKEY = P.P_PARTKEY
WHERE PS.PS_SUPPKEY = 1
AND NOT EXISTS (
    SELECT 1 FROM LINEITEM L 
    WHERE L.L_PARTKEY = PS.PS_PARTKEY 
    AND L.L_SUPPKEY = PS.PS_SUPPKEY
);

-- Part 2 Aggregations

SELECT 
    PS.PS_PARTKEY,
    P.P_NAME,
    SUM(L.L_QUANTITY) AS total_quantity_sold,
    SUM(L.L_EXTENDEDPRICE * (1 - L.L_DISCOUNT)) AS revenue
FROM PARTSUPP PS
JOIN PART P ON PS.PS_PARTKEY = P.P_PARTKEY
LEFT JOIN LINEITEM L ON PS.PS_PARTKEY = L.L_PARTKEY AND PS.PS_SUPPKEY = L.L_SUPPKEY
WHERE PS.PS_SUPPKEY = 1
GROUP BY PS.PS_PARTKEY, P.P_NAME
ORDER BY revenue DESC NULLS LAST;

select count(*)
avg(ps_supplycost)
from partsupp
where ps_suppkey =1;

-- Part 3

with cte as (
select *
from partsupp
where ps_suppkey =1
)
select *
from cte
where ps_availqty>8000
order by ps_availqty desc;

WITH supplier1_revenue AS (
    SELECT 
        L.L_PARTKEY,
        SUM(L.L_EXTENDEDPRICE * (1 - L.L_DISCOUNT)) AS revenue
    FROM LINEITEM L
    WHERE L.L_SUPPKEY = 1
    GROUP BY L.L_PARTKEY
),
other_suppliers_avg AS (
    SELECT 
        L.L_PARTKEY,
        AVG(SUM(L.L_EXTENDEDPRICE * (1 - L.L_DISCOUNT))) OVER(PARTITION BY L.L_PARTKEY) AS avg_revenue
    FROM LINEITEM L
    WHERE L.L_SUPPKEY != 1
    GROUP BY L.L_PARTKEY, L.L_SUPPKEY
)
SELECT 
    s1.L_PARTKEY,
    P.P_NAME,
    ROUND(s1.revenue, 2) AS supplier1_revenue,
    ROUND(osa.avg_revenue, 2) AS other_suppliers_avg_revenue,
    ROUND(s1.revenue - osa.avg_revenue, 2) AS difference
FROM supplier1_revenue s1
JOIN PART P ON s1.L_PARTKEY = P.P_PARTKEY
JOIN other_suppliers_avg osa ON s1.L_PARTKEY = osa.L_PARTKEY
ORDER BY difference DESC;

--4 case statement

SELECT 
    L.L_PARTKEY,
    P.P_NAME,
    ROUND(SUM(L.L_EXTENDEDPRICE * (1 - L.L_DISCOUNT)), 2) AS revenue,
    CASE 
        WHEN SUM(L.L_EXTENDEDPRICE * (1 - L.L_DISCOUNT)) >= 100000 THEN 'Platinum'
        WHEN SUM(L.L_EXTENDEDPRICE * (1 - L.L_DISCOUNT)) >= 50000 THEN 'Gold'
        WHEN SUM(L.L_EXTENDEDPRICE * (1 - L.L_DISCOUNT)) >= 25000 THEN 'Silver'
        WHEN SUM(L.L_EXTENDEDPRICE * (1 - L.L_DISCOUNT)) > 0 THEN 'Bronze'
        ELSE 'No Sales'
    END AS revenue_tier
FROM PARTSUPP PS
JOIN PART P ON PS.PS_PARTKEY = P.P_PARTKEY
LEFT JOIN LINEITEM L ON PS.PS_PARTKEY = L.L_PARTKEY AND PS.PS_SUPPKEY = L.L_SUPPKEY
WHERE PS.PS_SUPPKEY = 1
GROUP BY L.L_PARTKEY, P.P_NAME
ORDER BY revenue DESC NULLS LAST;