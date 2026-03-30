-- ============================================================
-- SCRIPT 1: Schema & Setup
-- ============================================================
-- Creates the main customer table that holds all portfolio
-- data for this analysis.
--
-- The primary key is a combination of customer_id AND
-- snapshot_date — this is because the same customer can
-- appear in multiple snapshots over time (e.g. monthly
-- data pulls). Using both fields together ensures each
-- record is unique.
-- ============================================================


CREATE TABLE customer (
    customer_id                 VARCHAR(25),
    snapshot_date               DATE,

    -- Customer profile
    age                         INTEGER,
    gender                      VARCHAR(25),
    monthly_income_ngn          NUMERIC(18, 2),
    state                       VARCHAR(25),
    kyc_tier                    VARCHAR(25),          -- KYC verification level (Tier 1 / 2 / 3)

    -- Account details
    account_age_days            INTEGER,              -- How long the account has been open
    products_count              INTEGER,              -- Total number of products held

    -- Product flags (TRUE = customer holds this product)
    has_savings_account         BOOLEAN,
    has_current_account         BOOLEAN,
    has_loan                    BOOLEAN,
    has_debit_card              BOOLEAN,
    has_credit_card             BOOLEAN,
    has_wallet                  BOOLEAN,              -- Digital wallet
    has_investment              BOOLEAN,

    -- Financial metrics
    total_balance_ngn           NUMERIC(18, 2),       -- Total balance across all accounts (₦)
    transaction_count_30d       INTEGER,              -- Number of transactions in last 30 days
    transaction_volume_ngn_30d  NUMERIC(18, 2),       -- Total transaction value in last 30 days (₦)
    days_since_last_transaction INTEGER,              -- 0 = transacted today; higher = more inactive

    -- Engagement & risk indicators
    dormant_flag                BOOLEAN,              -- TRUE = account classified as dormant
    digital_engagement_score    INTEGER,              -- Score from 0 to 100 (higher = more engaged)

    -- Churn outcomes
    churn_30d                   BOOLEAN,              -- TRUE = customer churned within 30 days
    churn_90d                   BOOLEAN,              -- TRUE = customer churned within 90 days

    PRIMARY KEY (customer_id, snapshot_date)          -- Composite key allows multiple snapshots
);
