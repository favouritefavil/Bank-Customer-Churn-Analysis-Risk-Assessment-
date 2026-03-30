-- ============================================================
-- SCRIPT 3: KPI Summary
-- ============================================================
-- This script calculates the 10 headline metrics that sit
-- at the top of the dashboard. These are the numbers that
-- give an immediate sense of the portfolio's overall health
-- before any segmentation is applied.
--
-- Each query is intentionally kept as a single focused
-- calculation so they can be run individually or combined
-- into a single summary query for reporting.
-- ============================================================


-- ------------------------------------------------------------
-- KPI 1: Total customers
-- The starting point — how many customers does the bank have?
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS total_customers
FROM customer;


-- ------------------------------------------------------------
-- KPI 2: Active customer rate
-- What percentage of customers are actively using the bank?
-- Active = not flagged as dormant
-- ------------------------------------------------------------

SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE dormant_flag = FALSE) / COUNT(*), 2
    ) AS active_customer_rate_pct
FROM customer;


-- ------------------------------------------------------------
-- KPI 3: Dormant customer rate
-- What percentage of accounts have gone inactive?
-- Dormant accounts are at high risk of eventual churn.
-- ------------------------------------------------------------

SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE dormant_flag = TRUE) / COUNT(*), 2
    ) AS dormant_customer_rate_pct
FROM customer;


-- ------------------------------------------------------------
-- KPI 4: 90-day churn rate
-- What percentage of customers left the bank within 90 days?
-- This is the primary risk metric for the whole analysis.
-- ------------------------------------------------------------

SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE churn_90d = TRUE) / COUNT(*), 2
    ) AS churn_90d_rate_pct
FROM customer;


-- ------------------------------------------------------------
-- KPI 5: Total customer balance
-- The total deposits held across all customers.
-- This is what is at stake if churn is not addressed.
-- ------------------------------------------------------------

SELECT
    SUM(total_balance_ngn) AS total_customer_balance_ngn
FROM customer;


-- ------------------------------------------------------------
-- KPI 6: Average balance per customer
-- The mean deposit amount. Useful for estimating the
-- deposit impact of losing a given number of customers.
-- ------------------------------------------------------------

SELECT
    ROUND(AVG(total_balance_ngn), 2) AS avg_balance_per_customer_ngn
FROM customer;


-- ------------------------------------------------------------
-- KPI 7: High-value customer ratio
-- What share of customers hold ₦500,000 or more?
-- This group is small but holds a disproportionate share
-- of total deposits.
-- ------------------------------------------------------------

SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE total_balance_ngn >= 500000) / COUNT(*), 2
    ) AS high_value_customer_ratio_pct
FROM customer;


-- ------------------------------------------------------------
-- KPI 8: High-value customers currently at risk
-- High-value customers who have not yet churned but are
-- showing warning signals — low engagement OR inactivity
-- of more than 60 days. These are the most urgent cases.
-- ------------------------------------------------------------

SELECT
    COUNT(*) FILTER (
        WHERE total_balance_ngn >= 500000
          AND churn_90d = FALSE
          AND (digital_engagement_score < 40 OR days_since_last_transaction > 60)
    ) AS high_value_customers_at_risk
FROM customer;


-- ------------------------------------------------------------
-- KPI 9: Average products per customer
-- How many bank products does the average customer hold?
-- Higher product depth = stronger retention. This number
-- tells us how much room there is to grow relationships.
-- ------------------------------------------------------------

SELECT
    ROUND(AVG(products_count), 2) AS avg_products_per_customer
FROM customer;


-- ------------------------------------------------------------
-- KPI 10: Average digital engagement score
-- The mean engagement level across all customers (0–100).
-- A score below 40 is classified as low engagement in this
-- analysis; above 70 is high engagement.
-- ------------------------------------------------------------

SELECT
    ROUND(AVG(digital_engagement_score), 2) AS avg_digital_engagement_score
FROM customer;


-- ------------------------------------------------------------
-- COMBINED: All KPIs in a single query
-- Run this for a one-row portfolio summary report
-- ------------------------------------------------------------

SELECT
    COUNT(*)                                                                AS total_customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE dormant_flag = FALSE) / COUNT(*), 2) AS active_rate_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE dormant_flag = TRUE)  / COUNT(*), 2) AS dormant_rate_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE churn_90d = TRUE)     / COUNT(*), 2) AS churn_90d_rate_pct,
    SUM(total_balance_ngn)                                                  AS total_balance_ngn,
    ROUND(AVG(total_balance_ngn), 2)                                        AS avg_balance_ngn,
    ROUND(100.0 * COUNT(*) FILTER (WHERE total_balance_ngn >= 500000) / COUNT(*), 2) AS high_value_ratio_pct,
    COUNT(*) FILTER (
        WHERE total_balance_ngn >= 500000
          AND churn_90d = FALSE
          AND (digital_engagement_score < 40 OR days_since_last_transaction > 60)
    )                                                                       AS high_value_at_risk,
    ROUND(AVG(products_count), 2)                                           AS avg_products,
    ROUND(AVG(digital_engagement_score), 2)                                 AS avg_engagement_score
FROM customer;
