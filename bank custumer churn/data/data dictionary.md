**Field Descriptions:**

| Field | Type | Description |
|-------|------|-------------|
| `customer_id` | VARCHAR(25) | Unique customer identifier |
| `snapshot_date` | DATE | Date of data snapshot |
| `age` | INTEGER | Customer age |
| `gender` | VARCHAR(25) | Customer gender |
| `monthly_income_ngn` | NUMERIC(18,2) | Monthly income in Nigerian Naira |
| `state` | VARCHAR(25) | State of residence |
| `kyc_tier` | VARCHAR(25) | KYC verification level |
| `account_age_days` | INTEGER | Days since account opening |
| `products_count` | INTEGER | Number of products held |
| `has_savings_account` | BOOLEAN | Has savings account flag |
| `has_current_account` | BOOLEAN | Has current account flag |
| `has_loan` | BOOLEAN | Has loan product flag |
| `has_debit_card` | BOOLEAN | Has debit card flag |
| `has_credit_card` | BOOLEAN | Has credit card flag |
| `has_wallet` | BOOLEAN | Has digital wallet flag |
| `has_investment` | BOOLEAN | Has investment product flag |
| `total_balance_ngn` | NUMERIC(18,2) | Total account balance in Naira |
| `transaction_count_30d` | INTEGER | Transactions in last 30 days |
| `transaction_volume_ngn_30d` | NUMERIC(18,2) | Transaction volume in last 30 days |
| `days_since_last_transaction` | INTEGER | Days since last transaction |
| `dormant_flag` | BOOLEAN | Account dormancy indicator |
| `digital_engagement_score` | INTEGER | Digital engagement score (0-100) |
| `churn_30d` | BOOLEAN | Churned within 30 days |
| `churn_90d` | BOOLEAN | Churned within 90 days |

