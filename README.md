# Bank Customer Churn & Portfolio Risk Analysis

![Project Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Tool](https://img.shields.io/badge/Tool-PostgreSQL-blue)
![Dashboard](https://img.shields.io/badge/Dashboard-Power%20BI-yellow)
![Dataset](https://img.shields.io/badge/Dataset-Simulated%20Nigerian%20Bank-lightgrey)

---
---

## Table of Contents

- [Introduction](#introduction)
- [Business Problem](#business-problem)
- [Dataset Overview](#dataset-overview)
- [Data Quality & Preparation](#data-quality--preparation)
- [Analysis Approach](#analysis-approach)
- [Dashboard Overview](#dashboard-overview)
- [Dashboard Preview](#dashboard-preview)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)
- [Conclusion](#conclusion)
- [Repository Structure](#repository-structure)

---

## Introduction

This project delivers a complete customer churn and portfolio risk analysis for a Nigerian commercial bank. It simulates the work of a **customer analytics or retail banking analyst** responsible for identifying at-risk customers, segmenting the portfolio by value and engagement, and recommending retention strategies before deposits are lost.

The analysis covers a snapshot of 2 million customers holding ₦302 billion in total deposits, built using **PostgreSQL** for data analysis and **Power BI** for dashboard development and visualisation.

---

## Business Problem

Every bank loses customers. The question is how many, which ones, and whether the bank knows about it early enough to act. A 13% churn rate sounds manageable until you calculate what it means in deposit terms and realise that the customers most at risk are not spread randomly across the portfolio. They concentrate in specific, identifiable segments.

This project addresses four core business questions:

- What is the **overall churn and engagement picture** of the customer base?
- Which **customer segments** are most at risk of leaving?
- Where is the **greatest financial exposure** from churn concentrated?
- What **retention actions** should the bank prioritise and in what order?
- 
---
## 🚨 Key Findings

- **13% of customers churned** within 90 days threatening ₦39.3bn in deposits annually
- Total portfolio: **2 million customers | ₦302bn in balances**
- **Single-product customers churn at 20%** 5× higher than customers with 4+ products
- **3,260 high-value customers are currently at risk** representing ₦6.5bn in deposits
- **Low-engagement customers churn at 21%** 2.6× higher than highly engaged customers

> This project identifies who is most likely to leave, why they leave, and what the bank should do to keep them before the money walks out the door.

---

## Dataset Overview

**Source:** Nigerian commercial bank customer data  
**Records:** 2,000,000 customers  
**Snapshot period:** Single point-in-time portfolio snapshot

| Variable | Description |
|---|---|
| `customer_id` | Unique customer identifier |
| `snapshot_date` | Date the data was captured |
| `age` | Customer age |
| `gender` | Customer gender |
| `monthly_income_ngn` | Monthly income in Naira |
| `state` | State of residence |
| `kyc_tier` | KYC verification level |
| `account_age_days` | How long the account has been open (days) |
| `products_count` | Number of bank products the customer holds |
| `has_savings_account` | Whether customer has a savings account |
| `has_current_account` | Whether customer has a current account |
| `has_loan` | Whether customer has a loan product |
| `has_debit_card` | Whether customer has a debit card |
| `has_credit_card` | Whether customer has a credit card |
| `has_wallet` | Whether customer has a digital wallet |
| `has_investment` | Whether customer has an investment product |
| `total_balance_ngn` | Total account balance across all products (₦) |
| `transaction_count_30d` | Number of transactions in the last 30 days |
| `transaction_volume_ngn_30d` | Total transaction value in the last 30 days (₦) |
| `days_since_last_transaction` | Days since the customer last transacted |
| `dormant_flag` | Whether the account is classified as dormant |
| `digital_engagement_score` | Engagement score from 0 to 100 |
| `churn_30d` | Whether the customer churned within 30 days |
| `churn_90d` | Whether the customer churned within 90 days |

---

## Data Quality & Preparation

Data quality checks were run in PostgreSQL before any analysis. Two fields were checked for completeness `monthly_income_ngn` and `state` as missing values in either would affect segmentation accuracy.

The dataset required no significant cleaning. The primary key is a composite of `customer_id` and `snapshot_date`, which allows for multiple snapshots of the same customer over time without duplication.

No derived view was needed for this project unlike a loan portfolio where outstanding balance and PAR flags need to be calculated from raw fields, the customer table already contains pre-computed behavioural metrics (engagement score, dormancy flag, churn flags) that feed directly into the analysis.

**Dataset status: Clean and ready for analysis at 2,000,000 records.**

---

## Analysis Approach

The analysis was structured across **five SQL scripts** covering four analytical themes:

**Portfolio Baseline**
- Total customers, total balance, average balance per customer
- Overall 90-day churn rate, active rate, and dormant rate
- High-value customer ratio and average products per customer
- Average digital engagement score across the portfolio

**Churn & Engagement Segmentation**
- Churn rate by digital engagement band (low / medium / high)
- Churn rate by product depth (1 product through 4+ products)
- Churn rate by inactivity band (days since last transaction)
- Dormancy rate by account age (new vs established accounts)
- Value segment performance (high / mid / low value customers)
- Geographic churn by state

**Risk Assessment**
- Customer engagement funnel: how many customers progress from active to digitally engaged to multi-product to high-value
- Value × Risk matrix:  crossing customer value tier against risk status (stable / at risk / churned)
- High-value customers at immediate risk:  the specific customers who have not yet churned but are showing warning signals
- Growth target customers:  low-balance, high-engagement customers with cross-sell potential

---

## Dashboard Overview

The Power BI dashboard is structured across three pages. All pages share a persistent KPI banner and four interactive filters, State, Payment Type, Credit & Investment products, and Account Type enabling segment-level exploration across all visuals.

> **2M Customers | ₦302bn Total Balance | ₦151K Avg Balance | 13% Churn Rate | 88% Active Rate**

---

### Page 1: Portfolio Overview

| Visual | What It Shows |
|---|---|
| KPI cards | Total customers, churn rate, total balance, avg balance, active rate, dormant rate |
| Active vs Dormant (bar) | 1.76M active customers vs 240K dormant |
| Customer Balance by Value Segment (donut) | High value holds 48% (₦145bn) despite being only 6.1% of customers |
| Churn Rate by Engagement Band (bar) | Low engagement: 21%, Medium: 12%, High: 8% |
| Total Customers by Engagement Band (bar) | 1.09M medium, 450K low, 450K high engagement |

**Key takeaway:** The engagement gap is stark. Low-engagement customers churn at nearly three times the rate of high-engagement customers. With 450,000 customers in the low band, this is the largest single addressable risk in the portfolio.

---

### Page 2: Engagement & Product Depth

| Visual | What It Shows |
|---|---|
| KPI cards | Avg digital engagement score (54.4), avg products per customer (2.0) |
| Total Customers by Product Depth (bar) | 900K hold only 1 product the largest single segment |
| Churn Rate by Product Depth (bar) | 1 product: 20%, 2 products: 12%, 3 products: 4%, 4+ products: 4% |
| Customer Engagement Funnel | 2M total → 1.8M active → 1.5M digitally engaged → 1.1M multi-product → 100K high-value |
| Customer Value Segment Table | High value: 121K customers, ₦1.197M avg balance, 11% churn; Low value: 1.365M customers, ₦33K avg balance, 14% churn |

**Key takeaway:** Product depth is the clearest predictor of retention. A customer holding one product has a 1-in-5 chance of churning. A customer holding three or more has a 1-in-25 chance. The 900,000 single-product customers are simultaneously the highest-risk segment and the largest cross-selling opportunity.

---

### Page 3: Risk & Geography

| Visual | What It Shows |
|---|---|
| KPI cards | High-value customers at risk (3,260), high-value customer ratio (6.1%) |
| Churn Rate by Activity Band (bar) | 61–90 days inactive and 90+ days (dormant) have highest churn |
| Dormant Customer Rate by Account Age (bar) | Consistent 12% dormancy across all account age bands |
| Nigeria Churn Map | State-level churn — consistent 13–14% nationally, no strong regional outliers |
| Top 5 States by Customer Count | Lagos (480K), FCT (230K), Rivers (150K), Kano (130K), Oyo (100K) |
| Value × Risk Matrix (table) | 412,867 at-risk customers across all value tiers; 266,667 already churned |

**Key takeaway:** Churn is not a regional problem it is a behavioural one. The Nigeria map shows minimal state-level variation (13–14% across the country), meaning geography-based targeting will not move the needle. The real levers are engagement, product depth, and early detection of at-risk signals before customers reach the 61-day inactivity threshold.

---

## Dashboard Preview

### Page 1 — Portfolio Overview
<img width="926" height="751" alt="Customer Portfolio Dashbord 1" src="https://github.com/user-attachments/assets/8373a3a7-6c27-4c8f-b9fa-6d946a714a49" />

---

### Page 2 — Engagement & Product Depth
<img width="922" height="753" alt="Customer Portfolio Dashbord 2" src="https://github.com/user-attachments/assets/1f88f5d0-945a-484d-a57e-fb766720fa62" />


---

### Page 3 — Risk & Geography
<img width="922" height="753" alt="Customer Portfolio Dashbord 3" src="https://github.com/user-attachments/assets/db2f10b6-9150-40da-b4cc-d81f072ceb8e" />


---

## Key Insights

**1. The 13% churn rate is a deposit protection problem, not just a customer count problem.**  
At 2 million customers and ₦302bn in total deposits, a 13% churn rate means approximately 260,000 customers leaving per 90-day period. At an average balance of ₦151K per customer, that translates to roughly ₦39.3bn in deposit outflows every quarter if left unaddressed. The churn rate headline understates the financial stakes.

**2. Product depth is the strongest retention lever in the data.**  
The drop from 20% churn (1 product) to 4% churn (3+ products) is not gradual, it is a cliff. Adding a second product reduces churn by 40%. Adding a third cuts it by another 67%. The 900,000 single-product customers represent both the largest risk and the largest revenue opportunity in the portfolio. Cross-selling to the right customers at the right time is not a sales strategy it is a risk strategy.

**3. Digital engagement predicts churn before inactivity becomes visible.**  
Low-engagement customers churn at 21%, 2.6 times the rate of high-engagement customers. Engagement score deterioration likely precedes the transaction inactivity that triggers dormancy flags. Monitoring engagement score trends creates an earlier warning window than waiting for customers to stop transacting.

**4. High-value customers require disproportionate urgency despite their lower churn rate.**  
High-value customers (balance ≥ ₦500,000) actually churn at a slightly lower rate (11%) than low-value customers (14%). But 3,260 of them are currently showing at-risk signals, low engagement or 60+ days inactive,  while not yet churned. These customers collectively hold approximately ₦6.5bn in deposits. Each customer lost from this segment is worth roughly 35 average-balance customers. The intervention maths are straightforward.

**5. Churn is uniform across the country, the problem is behavioural, not geographic.**  
State-level churn rates range from approximately 13–14% with no meaningful outliers. Lagos, the largest state by customer count, churns at the same rate as smaller states. This rules out regional factors (economic conditions, competition, branch access) as primary drivers and points squarely at product and engagement gaps that are consistent nationwide.

**6. Dormancy is an onboarding problem as much as a retention problem.**  
The 12% dormancy rate is identical across all account age bands, customers under 6 months old go dormant at the same rate as customers with over a year of history. This means the bank is not just failing to re-engage older customers; it is also failing to activate new ones. The first 90 days appear to set a pattern that persists for the life of the account.

---

## Business Recommendations

### Immediate Actions (0–30 Days)

- **Protect the 3,260 high-value customers currently at risk:** assign dedicated relationship managers, conduct personalised outreach within 7 days, and offer premium product bundles or preferential rates to re-engage. These customers hold ₦6.5bn in deposits. Target: retain ₦5.2bn (80% of at-risk amount) within 90 days by reducing high-value churn from 11% to 7%.
- **Establish a weekly at-risk monitoring dashboard:** track high-value customers whose engagement scores are declining or who have not transacted in 30+ days. Waiting for 60-day inactivity to act is too late.

### Short-Term Actions (0–60 Days)

- **Launch a product bundling campaign targeting single-product customers:** prioritise the subset with digital engagement scores above 60, as these customers are active enough to respond but have not yet expanded their relationship with the bank. A simplified Savings + Debit Card + Wallet bundle with in-app activation incentives is the fastest path to moving customers out of the high-churn single-product tier. Target: convert 15% of single-product customers to multi-product (135,000 customers), reducing overall churn by 2 percentage points.
- **Redesign the first 90-day onboarding journey:**  the consistent 12% dormancy across all account ages confirms that early-stage disengagement is baked into the current experience. Implement milestone-based onboarding with automated check-ins at days 7, 30, 60, and 90, and offer activation incentives for completing first key actions (first transfer, card activation, bill payment). Target: reduce 6-month dormancy from 12% to 6%.

### Medium-Term Actions (0–90 Days)

- **Improve the digital experience for the 450,000 low-engagement customers:** conduct a UX audit of the mobile and digital channels, identify friction points, and implement personalised push notifications with relevant financial content. Low-engagement customers churn at 21%; moving 250,000 of them to the medium engagement band directly reduces portfolio churn. Target: increase average digital engagement score from 54.4 to 62+.
- **Target growth-potential customers for cross-sell:**  highly engaged customers with low balances (digital score ≥ 70 but balance < ₦100,000) are the safest cross-sell targets. They are already active and likely to respond positively. Investment and credit card products are the natural next step for this group.

### Long-Term Strategy (60–180 Days)

- **Build a predictive churn model:**  combine engagement score trends, transaction recency, balance movement, and product holding changes into a customer health score that flags deterioration 30 days before it becomes visible in standard metrics. A model that correctly identifies 75% of churners 30 days in advance, with a 40% save rate on intervention, would protect an estimated ₦9.1bn in deposits annually.
- **Set concentration limits on single-product acquisition:** any new customer acquisition campaign should include a 90-day product adoption target. Acquiring customers who hold only one product indefinitely grows the highest-churn segment without improving portfolio quality.

---


## Conclusion

This project produced a complete customer churn and portfolio risk analysis, covering data quality checks, SQL-based KPI calculation, multi-dimensional segmentation, risk matrix construction, and a three-page interactive Power BI dashboard.

Three findings carry the most direct business weight. First, product depth is the clearest and most actionable predictor of retention, the gap between one-product and three-product customers (20% vs 4% churn) is large enough that even modest cross-sell conversion rates produce measurable portfolio improvements. Second, high-value customer risk is urgent and concentrated, 3,260 customers holding ₦6.5bn in deposits are showing at-risk signals right now, before they have churned. The intervention window is open. Third, churn is uniform nationally but highly differentiated by behaviour, geographic targeting will not work, but engagement and product interventions will, because the underlying drivers are consistent across the country.

The five recommended priorities — high-value retention, product bundling, digital engagement improvement, onboarding optimisation, and predictive churn modelling are projected to protect ₦29.2bn in deposits over 12 months and reduce the overall churn rate from 13% to 9%.

> *A 13% churn rate at 2 million customers is not a retention problem ,it is a product depth and engagement problem that shows up as churn.*

---

## Repository Structure

```
bank-customer-churn-analysis/
│
├── README.md
│
├── dashboard/
│   ├── portfolio_overview.png
│   ├── engagement_product_depth.png
│   └── risk_and_geography.png
│
└── sql/
    ├── README.md                     # Guide to all 5 scripts and key concepts
    ├── 01_schema_and_setup.sql       # Table creation
    ├── 02_data_quality_checks.sql    # Missing data and completeness checks
    ├── 03_kpi_summary.sql            # 10 headline portfolio KPIs
    ├── 04_segmentation_analysis.sql  # Churn by engagement, product, geography, inactivity
    └── 05_risk_assessment.sql        # Funnel, value × risk matrix, at-risk customers
```

---

## 💡 Key Takeaway

> Customers with more products churn less, customers who engage digitally churn less, and customers who go inactive for 60+ days are already on their way out. The data points to the same intervention every time: get customers to use more of the bank, earlier.

---

*Project by Favour Chegwe - Data Analyst*  
*Tools: PostgreSQL · Power BI · DAX*  
*Dataset: Nigerian Commercial Bank customer data*
