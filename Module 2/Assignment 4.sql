
select *
from churn_predictions;

select *
from customer_rfm;

SELECT 
    r.C_CUSTKEY,
    r.RECENCY_SCORE,
    r.FREQUENCY_SCORE,
    r.MONETARY_SCORE,
    r.RFM_SEGMENT,
    c.AVG_ORDER_VALUE,
    c.CHURNED,
    c.RETURN_RATE,
    c.PREDICTED_CHURN
FROM V_CUSTOMER_RFM r
JOIN CHURN_PREDICTIONS c ON r.C_CUSTKEY = c.C_CUSTKEY;

