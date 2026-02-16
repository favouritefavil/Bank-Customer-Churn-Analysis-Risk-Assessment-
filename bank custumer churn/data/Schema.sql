## 📊 Database Schema

```sql
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
    PRIMARY KEY (customer_id, snapshot_date)
);