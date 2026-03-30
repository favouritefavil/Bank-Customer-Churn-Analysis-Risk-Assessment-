-- ============================================================
-- SCRIPT 2: Data Quality Checks
-- ============================================================
-- Before running any analysis, we verify that the data is
-- complete and trustworthy. This script checks for missing
-- values in fields that are critical to the segmentation
-- analysis.
--
-- If any of these checks return unexpected numbers, the
-- records should be investigated before proceeding.
-- ============================================================


-- ------------------------------------------------------------
-- CHECK 1: Overall record count and missing critical fields
-- We check monthly_income_ngn and state because both are
-- used in segmentation. Missing income affects value tier
-- classification; missing state affects geographic analysis.
-- ------------------------------------------------------------

SELECT
    COUNT(*)                                            AS total_customers,
    COUNT(*) FILTER (WHERE monthly_income_ngn IS NULL)  AS missing_income,
    COUNT(*) FILTER (WHERE state IS NULL)               AS missing_state
FROM customer;

-- Expected: missing_income = 0, missing_state = 0
-- If not zero, investigate before proceeding with analysis


-- ------------------------------------------------------------
-- CHECK 2: Validate key numeric fields are within range
-- Digital engagement score should be between 0 and 100.
-- Days since last transaction should not be negative.
-- Products count should be 1 or more.
-- ------------------------------------------------------------

SELECT
    COUNT(*) FILTER (WHERE digital_engagement_score < 0
                       OR digital_engagement_score > 100)   AS invalid_engagement_scores,
    COUNT(*) FILTER (WHERE days_since_last_transaction < 0) AS negative_inactivity_days,
    COUNT(*) FILTER (WHERE products_count < 1)              AS zero_product_customers,
    COUNT(*) FILTER (WHERE total_balance_ngn < 0)           AS negative_balances
FROM customer;

-- Expected: all values = 0
-- Any non-zero result indicates a data entry or import error


-- ------------------------------------------------------------
-- CHECK 3: Confirm churn flag consistency
-- A customer who churned within 30 days should also be
-- marked as churned within 90 days. If churn_30d = TRUE
-- but churn_90d = FALSE, there is a data inconsistency.
-- ------------------------------------------------------------

SELECT
    COUNT(*) AS inconsistent_churn_flags
FROM customer
WHERE churn_30d = TRUE
  AND churn_90d = FALSE;

-- Expected: 0
-- churn_30d is a subset of churn_90d — 30-day churn implies 90-day churn


-- ------------------------------------------------------------
-- CHECK 4: Duplicate primary key check
-- The composite key (customer_id + snapshot_date) must be
-- unique. If duplicates exist, counts and aggregations will
-- be inflated.
-- ------------------------------------------------------------

SELECT
    customer_id,
    snapshot_date,
    COUNT(*) AS occurrences
FROM customer
GROUP BY customer_id, snapshot_date
HAVING COUNT(*) > 1;

-- Expected: no rows returned
-- Any rows here indicate duplicate records that must be removed
