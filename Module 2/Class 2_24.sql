-- Activity part 1: SQL Challenge

-- Use a case statement to create 5 RFM segments.

select c_custkey,
rfm_segment,
case
when rfm_segment in(111,125,123) then 'Segment 1'
when rfm_segment between 200 and 299 then 'Segment 2'
when rfm_segment between 300 and 399 then 'Segment 3'
when rfm_segment between 400 and 499 then 'Segment 4'
when rfm_segment between 500 and 599 then 'Segment 5'
else 'Other'
end as condensed_segment
from customer_rfm sample (.1);

-- Activity Part 2: Cluster EDA
select * 
from churned_customer_clusters sample(1);

select count(*)
from churned_customer_clusters;

select distrinct cluster
from churned_customer_clusters
order by cluster;

select cluster,
count(*) as customer_count
from churned_customer_clusters
group by cluster
order by cluster;

--Actibity part 3a
select c_custkey,
cluster,
total_spend,
round(avg(total_spend) over(partition by cluster),2) as avg_per_cluster
total_spend - avg_per_cluster as cust_diff_from_cluster_avg
from churned_customer_clusters sample(1)
where cluster =3
order by cluster
limit 10;

-- Value window function
select c_custkey,
cluster,
total_spend,
first_value(total_spend) over( partition by cluster order by total_spend)

from churned_customer_clusters
--where cluster =3
order by cluster
limit 10;

-- Activity 3b

WITH cluster_stats AS (
    SELECT 
        C_CUSTKEY,
        CLUSTER,
        TOTAL_SPEND,
        AVG_ORDER_VALUE,
        ORDERS_PER_YEAR,
        TENURE_DAYS,
        RETURN_RATE,
        ROUND(AVG(TOTAL_SPEND) OVER(PARTITION BY CLUSTER), 2) AS avg_spend,
        ROUND(AVG(AVG_ORDER_VALUE) OVER(PARTITION BY CLUSTER), 2) AS avg_aov,
        ROUND(AVG(ORDERS_PER_YEAR) OVER(PARTITION BY CLUSTER), 2) AS avg_orders_per_year,
        ROUND(AVG(TENURE_DAYS) OVER(PARTITION BY CLUSTER), 0) AS avg_tenure,
        ROUND(AVG(RETURN_RATE) OVER(PARTITION BY CLUSTER), 4) AS avg_return_rate,
        COUNT(*) OVER(PARTITION BY CLUSTER) AS cluster_size,
        ROW_NUMBER() OVER(PARTITION BY CLUSTER ORDER BY C_CUSTKEY) AS rn
    FROM CHURNED_CUSTOMER_CLUSTERS
)
SELECT 
    C_CUSTKEY AS sample_customer,
    CLUSTER,
    cluster_size,
    avg_spend,
    avg_aov,
    avg_orders_per_year,
    avg_tenure,
    avg_return_rate
FROM cluster_stats
WHERE rn = 1
ORDER BY CLUSTER;