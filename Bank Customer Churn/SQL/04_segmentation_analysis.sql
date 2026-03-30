-- ============================================================
-- SCRIPT 4: Segmentation Analysis
-- ============================================================
-- This script breaks down churn and dormancy across six
-- dimensions to identify WHERE the risk is concentrated.
--
-- The KPI script told us WHAT the problem is (13% churn).
-- This script tells us WHO is churning and WHY — which
-- segments, which behaviours, and which geographies have
-- the highest risk.
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Churn rate by digital engagement band
-- Does being more digitally active reduce the chance of
-- leaving? This query divides customers into three
-- engagement tiers and compares their churn rates.
--
-- Low: score below 40 | Medium: 40–69 | High: 70+
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN digital_engagement_score >= 70 THEN 'High Engagement'
        WHEN digital_engagement_score >= 40 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS engagement_band,
    COUNT(*)                                        AS customers,
    ROUND(AVG(churn_90d::INT) * 100, 2)             AS churn_rate_pct
FROM customer
GROUP BY engagement_band
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- QUERY 2: Churn rate by product depth
-- Customers who use more of the bank's products are harder
-- to replace elsewhere — do they actually stay longer?
-- This is the key cross-selling justification query.
-- ------------------------------------------------------------

SELECT
    products_count,
    COUNT(*)                                        AS customers,
    ROUND(AVG(churn_90d::INT) * 100, 2)             AS churn_rate_pct
FROM customer
GROUP BY products_count
ORDER BY products_count;


-- ------------------------------------------------------------
-- QUERY 3: Churn rate by inactivity band
-- How long does it take for an inactive customer to become
-- a churned one? This shows the relationship between
-- transaction recency and churn risk.
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN days_since_last_transaction <= 30  THEN '0–30 days (Active)'
        WHEN days_since_last_transaction <= 60  THEN '31–60 days (At Risk)'
        WHEN days_since_last_transaction <= 90  THEN '61–90 days (Inactive)'
        ELSE '90+ days (Dormant)'
    END AS inactivity_band,
    COUNT(*)                                        AS customers,
    ROUND(AVG(churn_90d::INT) * 100, 2)             AS churn_rate_pct
FROM customer
GROUP BY inactivity_band
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------------------
-- QUERY 4: Dormancy rate by account age
-- Are newer accounts more likely to go dormant, or is
-- dormancy spread evenly across all account ages?
-- If new accounts go dormant at the same rate as old ones,
-- it points to an onboarding problem, not a loyalty problem.
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN account_age_days < 180  THEN 'Under 6 months'
        WHEN account_age_days < 365  THEN '6 to 12 months'
        ELSE 'Over 1 year'
    END AS account_age_band,
    COUNT(*)                                        AS customers,
    ROUND(AVG(dormant_flag::INT) * 100, 2)          AS dormancy_rate_pct
FROM customer
GROUP BY account_age_band
ORDER BY account_age_band;


-- ------------------------------------------------------------
-- QUERY 5: Customer distribution and balance by value tier
-- How are customers and deposits distributed across
-- high, mid, and low value segments?
-- This shows which segment holds the most money — not
-- just the most customers.
--
-- High Value: balance ≥ ₦500K
-- Mid Value:  balance ₦100K–₦499K
-- Low Value:  balance below ₦100K
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN total_balance_ngn >= 500000 THEN 'High Value'
        WHEN total_balance_ngn >= 100000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS value_segment,
    COUNT(*)                                        AS customers,
    SUM(total_balance_ngn)                          AS total_balance_ngn,
    ROUND(AVG(total_balance_ngn), 0)                AS avg_balance_ngn,
    ROUND(AVG(churn_90d::INT) * 100, 2)             AS churn_rate_pct
FROM customer
GROUP BY value_segment
ORDER BY avg_balance_ngn DESC;


-- ------------------------------------------------------------
-- QUERY 6: Churn rate by state (geographic analysis)
-- Is churn concentrated in specific regions, or is it a
-- nationwide pattern? If rates are similar across states,
-- the cause is behavioural, not geographic.
-- ------------------------------------------------------------

SELECT
    state,
    COUNT(*)                                        AS customers,
    ROUND(AVG(churn_90d::INT) * 100, 2)             AS churn_rate_pct
FROM customer
GROUP BY state
ORDER BY churn_rate_pct DESC;
