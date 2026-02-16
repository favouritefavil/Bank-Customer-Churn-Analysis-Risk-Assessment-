# SQL Analysis Documentation
## Bank Customer Churn Analysis

This document provides detailed explanations of all SQL queries used in the customer churn analysis project.



## Data Quality Checks

### Missing Data Analysis

**Purpose:** Identify data completeness issues that may affect analysis accuracy.

```sql
SELECT 
    COUNT(*) AS total_customers,
    COUNT(*) FILTER(WHERE monthly_income_ngn IS NULL) AS missing_income,
    COUNT(*) FILTER(WHERE state IS NULL) AS missing_state
FROM customer;
```


## Key Performance Indicators (KPIs)

### 1. Total Customers

**Purpose:** Get the total number of customers in the database.

```sql
SELECT
    COUNT(*) AS total_customers
FROM customer;
```

**
---

### 2. Active Customer Rate

**Purpose:** Calculate the percentage of active (non-dormant) customers.

```sql
SELECT 
    ROUND(
        100.0 * COUNT(*) FILTER(WHERE dormant_flag = FALSE) / COUNT(*), 2
    ) AS active_customer_rate
FROM customer;
```

---

### 3. Dormant Customer Rate

**Purpose:** Calculate the percentage of dormant customers.

```sql
SELECT 
    ROUND(
        100.0 * COUNT(*) FILTER(WHERE dormant_flag = TRUE) / COUNT(*), 2
    ) AS dormant_customer_rate
FROM customer;
```


---

### 4. 90-Day Churn Rate

**Purpose:** Calculate the overall churn rate over a 90-day period.

```sql
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER(WHERE churn_90d = TRUE) / COUNT(*), 2
    ) AS churn_90d_rate
FROM customer;
```


---

### 5. Total Customer Balance

**Purpose:** Calculate total deposits across all customers.

```sql
SELECT
    SUM(total_balance_ngn) AS total_customer_balance
FROM customer;
```



---

### 6. Average Balance per Customer

**Purpose:** Calculate the mean account balance across all customers.

```sql
SELECT
    ROUND(AVG(total_balance_ngn), 2) AS avg_balance_per_customer
FROM customer;
```


---

### 7. High-Value Customer Ratio

**Purpose:** Calculate the percentage of customers with balances ≥ ₦500,000.

```sql
SELECT 
    ROUND(
        100.0 * COUNT(*) FILTER(WHERE total_balance_ngn >= 500000) / COUNT(*), 2
    ) AS high_value_customer_ratio
FROM customer;
```


---

### 8. High-Value Customers at Risk

**Purpose:** Identify percentage of high-value customers showing risk signals.

```sql
SELECT 
    ROUND(
        100.0 * COUNT(*) FILTER(
            WHERE total_balance_ngn >= 500000
            AND (digital_engagement_score < 40 OR days_since_last_transaction > 60)
        ) / NULLIF(COUNT(*) FILTER(WHERE total_balance_ngn >= 500000), 0), 2
    ) AS high_value_customer_at_risk
FROM customer;
```



---

### 9. Average Products per Customer

**Purpose:** Calculate mean number of products held per customer.

```sql
SELECT 
    ROUND(AVG(products_count), 2) AS avg_products_per_customer
FROM customer;
```


---

### 10. Average Digital Engagement Score

**Purpose:** Calculate mean digital engagement level across all customers.

```sql
SELECT
    ROUND(AVG(digital_engagement_score), 2) AS avg_digital_engagement_score
FROM customer;
```


---

## Segmentation Analysis

### 1. Churn Rate by Engagement Band

**Purpose:** Analyze how digital engagement correlates with churn behavior.

```sql
SELECT 
    CASE
        WHEN digital_engagement_score >= 70 THEN 'High Engagement'
        WHEN digital_engagement_score >= 40 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS engagement_band,
    COUNT(*) AS customers,
    ROUND(AVG(churn_90d::int) * 100, 2) AS churn_rate
FROM customer
GROUP BY engagement_band;
```


---

### 2. Dormancy Rate by Account Age

**Purpose:** Understand how account age affects dormancy patterns.

```sql
SELECT 
    CASE
        WHEN account_age_days < 180 THEN '<6 months'
        WHEN account_age_days < 365 THEN '6-12 months'
        ELSE '1+ years'
    END AS account_age_band,
    ROUND(AVG(dormant_flag::int) * 100, 2) AS dormancy_rate
FROM customer
GROUP BY account_age_band;
```



---

### 3. Value Segment Performance

**Purpose:** Analyze customer distribution and total balance by value tier.

```sql
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
```


---

### 4. Geographic Churn Analysis

**Purpose:** Identify state-level churn patterns for targeted interventions.

```sql
SELECT 
    state,
    COUNT(*) AS customers,
    ROUND(AVG(churn_90d::int) * 100, 2) AS churn_rate
FROM customer
GROUP BY state
ORDER BY churn_rate DESC;
```



---

### 5. Churn by Inactivity Band

**Purpose:** Understand how transaction recency impacts churn risk.

```sql
SELECT 
    CASE
        WHEN days_since_last_transaction <= 30 THEN '0-30 days'
        WHEN days_since_last_transaction <= 60 THEN '31-60 days'
        WHEN days_since_last_transaction <= 90 THEN '61-90 days'
        ELSE '90+'
    END AS inactivity_band,
    COUNT(*) AS customers,
    ROUND(AVG(churn_90d::int) * 100, 2) AS churn_rate
FROM customer
GROUP BY inactivity_band;
```



---

## Churn Analysis

### Churn Rate by Product Depth

**Purpose:** Analyze relationship between number of products held and churn rate.

```sql
SELECT
    products_count,
    COUNT(*) AS customers,
    ROUND(AVG(churn_90d::INT) * 100, 2) AS churn_rate_pct
FROM customer
GROUP BY products_count
ORDER BY products_count;
```


---

## Risk Assessment Queries

### 1. Customer Engagement Funnel

**Purpose:** Track customer progression through engagement stages.

```sql
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE dormant_flag = FALSE) AS active_customers,
    COUNT(*) FILTER (WHERE digital_engagement_score >= 40) AS digitally_engaged,
    COUNT(*) FILTER (WHERE products_count >= 2) AS multi_product_customers,
    COUNT(*) FILTER (WHERE total_balance_ngn >= 500000) AS high_value_customers
FROM customer;
```


---


.

---

### 3. Value × Risk Matrix

**Purpose:** Create comprehensive risk segmentation for targeted strategies.

```sql
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
```



### 4. High-Value Customers at Immediate Risk

**Purpose:** Identify specific high-value customers requiring urgent intervention.

```sql
SELECT
    customer_id,
    total_balance_ngn,
    digital_engagement_score,
    days_since_last_transaction,
    products_count
FROM customer
WHERE total_balance_ngn >= 500000
  AND churn_90d = FALSE
  AND (digital_engagement_score < 40 OR days_since_last_transaction > 60);
```



---

### 5. Growth Target Customers

**Purpose:** Identify highly engaged low-balance customers with growth potential.

```sql
SELECT
    customer_id,
    products_count,
    digital_engagement_score,
    total_balance_ngn
FROM customer
WHERE digital_engagement_score >= 70
  AND total_balance_ngn < 100000
  AND churn_90d = FALSE;
```



---





