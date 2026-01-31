-- bank customer churn project

CREATE TABLE customer (
    customer_id VARCHAR(25),
    snapshot_date DATE,
    age INTEGER,
    gender VARCHAR(25),
    monthly_income_ngn NUMERIC(18, 2),
    state VARCHAR(25),
    kyc_tier VARCHAR(25),
    account_age_days INTEGER,
    products_count INTEGER,
    has_savings_account BOOLEAN,
    has_current_account BOOLEAN,
    has_loan BOOLEAN,
    has_debit_card BOOLEAN,
    has_credit_card BOOLEAN,
    has_wallet BOOLEAN,
    has_investment BOOLEAN,
    total_balance_ngn NUMERIC(18, 2),
    transaction_count_30d INTEGER,
    transaction_volume_ngn_30d NUMERIC(18, 2),
    days_since_last_transaction INTEGER,
    dormant_flag BOOLEAN,
    digital_engagement_score INTEGER,
    churn_30d BOOLEAN,
    churn_90d BOOLEAN,
    -- Suggested Primary Key if data is unique per customer per date
    PRIMARY KEY (customer_id, snapshot_date)
);

SELECT * FROM customer;


-- check for missing data
SELECT 
COUNT (*) AS total_customers,
COUNT(*) FILTER(
WHERE monthly_income_ngn IS NULL) AS missing_income,
	COUNT(*) FILTER (WHERE state is NULL) AS missing_state
	FROM customer;
)


--KPI
--total customers
SELECT
COUNT(*) AS total_customers
FROM customer;


--active customer rate%
SELECT 
	ROUND(
		100.0 * COUNT(*) FILTER(	
						WHERE dormant_flag = FALSE) / COUNT(*), 2)
						AS active_customer_rate
FROM customer;


--dormant customer rate
SELECT 
	ROUND(
		100.0 * COUNT(*) FILTER(
						WHERE dormant_flag = TRUE) / COUNT(*), 2)
						AS dormant_customer_rate
FROM customer;


-- 90day churn rate
SELECT
ROUND(
		100.0 * COUNT(*) FILTER(
						WHERE churn_90d = TRUE) / COUNT(*), 2)
						AS churn_90d_rate
FROM customer;

	
--total customer balance
SELECT
	 SUM(total_balance_ngn) AS total_customer_balance
FROM customer;


--average balance per customer
SELECT
	ROUND(AVG(total_balance_ngn), 2)
	AS avg_balance_per_customer
FROM customer;


--high value customer ratio (high value = balance >#500k)
	SELECT 
		ROUND(
			100.0 * COUNT(*) FILTER(
							WHERE total_balance_ngn >= 500000) / COUNT(*), 2
						) AS high_value_customer_ratio
FROM customer;


--high value customer at risk(high value and inactive)
SELECT 
		ROUND(
			100.0 * COUNT(*) FILTER(
							WHERE total_balance_ngn >= 500000
							AND (
							digital_engagement_score <40 
								OR
							days_since_last_transaction >60)
							) 
							/ NULLIF(COUNT (*) FILTER (
												WHERE 
												total_balance_ngn >= 500000), 0), 2)
												AS high_value_customer_at_risk
FROM customer;
										
												
--average product per customer
SELECT 
	ROUND(AVG(products_count),2) AS avg_products_per_customer
FROM customer;


--avg digital engagement score
SELECT
	ROUND(AVG(digital_engagement_score), 2) AS avg_digital_engagement_score
FROM customer;

SELECT * FROM customer;

--churn by engagement band
SELECT 
	CASE
		WHEN digital_engagement_score >= 70 THEN 'High Engagement'
		WHEN digital_engagement_score >= 40 THEN 'Medium Engagement'
		ELSE 'Low Engagement'
		END AS engagement_band,
		COUNT (*) AS customers,
		ROUND(AVG(churn_90d :: int) * 100,2)
		AS churn_rate
FROM customer
GROUP BY engagement_band;

--dormancy by account age
SELECT 
	CASE
		WHEN account_age_days < 180 THEN '<6 months'
		WHEN account_age_days < 365 THEN '6-12 months'
		ELSE '1+ years'
		END AS account_age_band,
		ROUND (AVG(dormant_flag :: int) * 100, 2) AS dormancy_rate
FROM customer
GROUP BY account_age_band;

-- value segment performance
SELECT 
	CASE
		WHEN total_balance_ngn >= 500000 THEN 'High Value'
		WHEN total_balance_ngn >= 100000 THEN 'Mid Value'
		ELSE 'Low Value'
		END AS value_segment,
		COUNT(*) AS customers,
		SUM(total_balance_ngn) AS total_balance
FROM customer
GROUP BY value_segment;


--geography by churn
SELECT 
	state,
	COUNT(*) AS customers,
	ROUND(AVG(churn_90d :: int) * 100, 2)
	AS churn_rate
FROM customer
GROUP BY state
ORDER BY churn_rate DESC;

--inactivity band
SELECT 
	CASE
		WHEN days_since_last_transaction <= 30 THEN '0-30 days'
		WHEN days_since_last_transaction <= 60 THEN '31-60 days'
		WHEN days_since_last_transaction <= 90 THEN '61-90 days'
		ELSE '90+'
		END AS inactivity_band,
		COUNT (*) AS customers,
		ROUND(AVG(churn_90d :: int) * 100, 2)
		AS churn_rate
FROM customer
GROUP BY inactivity_band;


--Churn by product depth
SELECT
    products_count,
    COUNT(*) AS customers,
    ROUND(AVG(churn_90d::INT) * 100, 2) AS churn_rate_pct
FROM customer
GROUP BY products_count
ORDER BY products_count;

--ENGAGEMENT FUNNEL ANALYSIS
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE dormant_flag = FALSE) AS active_customers,
    COUNT(*) FILTER (WHERE digital_engagement_score >= 40) AS digitally_engaged,
    COUNT(*) FILTER (WHERE products_count >= 2) AS multi_product_customers,
    COUNT(*) FILTER (WHERE total_balance_ngn >= 500000) AS high_value_customers
FROM customer;

--Single-product but engaged customers
SELECT
    COUNT(*) AS cross_sell_targets
FROM customer
WHERE products_count = 1
  AND digital_engagement_score >= 60
  AND churn_90d = FALSE;

--Product holding distribution
SELECT
    products_count,
    COUNT(*) AS customers
FROM customer_360
GROUP BY products_count
ORDER BY products_count;

--Value × Risk grid
SELECT
    CASE
        WHEN total_balance_ngn >= 500000 THEN 'High Value'
        WHEN total_balance_ngn >= 100000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS value_segment,
    CASE
        WHEN churn_90d = TRUE THEN 'Churned'
        WHEN days_since_last_transaction > 60
          OR digital_engagement_score < 40 THEN 'At Risk'
        ELSE 'Stable'
    END AS risk_status,
    COUNT(*) AS customers
FROM customer
GROUP BY value_segment, risk_status
ORDER BY value_segment, risk_status;


--High-value customers at immediate risk
SELECT
    customer_id,
    total_balance_ngn,
    digital_engagement_score,
    days_since_last_transaction,
    products_count
FROM customer
WHERE total_balance_ngn >= 500000
  AND churn_90d = FALSE
  AND (
        digital_engagement_score < 40
     OR days_since_last_transaction > 60
      );


--Growth targets (engaged but low value)
SELECT
    customer_id,
    products_count,
    digital_engagement_score,
    total_balance_ngn
FROM customer
WHERE digital_engagement_score >= 70
  AND total_balance_ngn < 100000
  AND churn_90d = FALSE;












































































