-- Activity Part 1 

-- How many customers per RFM segment?, Query my rfm table in z_db_instructor1.module2.v_customer_rfm       count how many customers are in each rmf table

SELECT 
    RFM_SEGMENT,
    COUNT(*) AS customer_count
FROM Z_DB_INSTRUCTOR1.MODULE2.V_CUSTOMER_RFM
GROUP BY RFM_SEGMENT
ORDER BY customer_count DESC;


-- Activity part 2: RFM Analysis with case and CTEs

with cte as (
select c_custkey,
rfm_segment,
case 
when rfm_segment < 250 then 'High Risk'
when rfm_segment >= 250 then 'Low Risk'
end as churn_risk
from Z_DB_INSTRUCTOR1.MODULE2.V_CUSTOMER_RFM
order by rfm_segment desc
)

select churn_risk,
count(c_custkey)
from cte
group by churn_risk
limit 10;


-- Activity part 3 
select Z_DB_INSTRUCTOR1.MODULE2.rfm_churn_predictor2!predict(3,2,1);
select Z_DB_INSTRUCTOR1.MODULE2.rfm_churn_predictor2!predict_proba(3,2,1);