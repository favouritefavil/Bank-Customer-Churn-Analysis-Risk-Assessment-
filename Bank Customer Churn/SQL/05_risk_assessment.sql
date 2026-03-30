-- ============================================================
-- SCRIPT 5: Risk Assessment
-- ============================================================
-- This script moves from describing the problem to identifying
-- specific customers and segments that need action.
--
-- The segmentation script showed us WHERE the risk is.
-- This script answers: which exact customers are at risk
-- right now, and which customers represent the best
-- opportunity to grow the relationship?
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: Customer engagement funnel
-- How many customers make it through each stage of
-- engagement — from simply having an account, to being
-- active, to being digitally engaged, to holding multiple
-- products, to being high value?
--
-- Drop-offs between stages reveal where the bank is
-- losing customers along the journey.
-- ------------------------------------------------------------

SELECT
    COUNT(*)                                                        AS total_customers,
    COUNT(*) FILTER (WHERE dormant_flag = FALSE)                    AS active_customers,
    COUNT(*) FILTER (WHERE digital_engagement_score >= 40)          AS digitally_engaged,
    COUNT(*) FILTER (WHERE products_count >= 2)                     AS multi_product_customers,
    COUNT(*) FILTER (WHERE total_balance_ngn >= 500000)             AS high_value_customers
FROM customer;

-- Reading this funnel:
-- Large drop from total → active = onboarding problem
-- Large drop from active → digitally engaged = app/digital experience problem
-- Large drop from engaged → multi-product = cross-sell gap
-- Small high-value count = concentration risk (few customers hold a lot)


-- ------------------------------------------------------------
-- QUERY 2: Value × Risk matrix
-- Cross-tabulates customer value tier (high/mid/low)
-- against their current risk status (stable/at risk/churned).
-- This creates nine segments — each requiring a different
-- response from the retention team.
-- ------------------------------------------------------------

SELECT
    CASE
        WHEN total_balance_ngn >= 500000 THEN 'High Value'
        WHEN total_balance_ngn >= 100000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS value_segment,
    CASE
        WHEN churn_90d = TRUE                                       THEN 'Churned'
        WHEN days_since_last_transaction > 60
          OR digital_engagement_score < 40                          THEN 'At Risk'
        ELSE 'Stable'
    END AS risk_status,
    COUNT(*) AS customers
FROM customer
GROUP BY value_segment, risk_status
ORDER BY value_segment, risk_status;

-- Priority focus: High Value + At Risk (protect deposits before they leave)
-- Secondary: Mid Value + At Risk (large volume, meaningful deposits)
-- Opportunity: Any Value + Stable (cross-sell and deepen relationships)


-- ------------------------------------------------------------
-- QUERY 3: High-value customers at immediate risk
-- Lists the specific customers who are high value,
-- have NOT yet churned, but are showing warning signals.
-- These are the accounts where intervention can still work.
--
-- Warning signals:
--   - Digital engagement score below 40 (disengaging digitally)
--   - No transaction in over 60 days (going quiet financially)
-- ------------------------------------------------------------

SELECT
    customer_id,
    total_balance_ngn,
    digital_engagement_score,
    days_since_last_transaction,
    products_count
FROM customer
WHERE total_balance_ngn >= 500000
  AND churn_90d = FALSE
  AND (digital_engagement_score < 40 OR days_since_last_transaction > 60)
ORDER BY total_balance_ngn DESC;

-- Sort by balance so the highest-exposure customers appear first
-- These are the accounts to call first


-- ------------------------------------------------------------
-- QUERY 4: Growth target customers
-- Identifies customers who are highly engaged digitally
-- but have low balances — meaning they use the bank
-- actively but haven't grown their financial relationship.
--
-- These are the safest cross-sell targets: they are already
-- committed enough to engage with digital channels and
-- have not churned, but there is significant room to grow.
-- ------------------------------------------------------------

SELECT
    customer_id,
    products_count,
    digital_engagement_score,
    total_balance_ngn
FROM customer
WHERE digital_engagement_score >= 70
  AND total_balance_ngn < 100000
  AND churn_90d = FALSE
ORDER BY digital_engagement_score DESC;

-- These customers are receptive to new products.
-- Investment accounts, credit cards, or savings goals
-- are natural next steps for this group.
