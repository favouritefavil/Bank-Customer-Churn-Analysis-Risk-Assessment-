# SQL Scripts

This folder contains all the SQL queries used in the Bank Customer Churn & Portfolio Risk Analysis. There are 5 scripts. Run them in order each one builds on the previous.

---

## Scripts at a Glance

### 01_schema_and_setup.sql
Creates the customer table with all its columns. The primary key is a combination of `customer_id` and `snapshot_date`. this allows the same customer to appear in multiple monthly snapshots without creating duplicate errors. Run this first before loading any data.

### 02_data_quality_checks.sql
Verifies the data is clean and trustworthy before any analysis runs. Checks for missing values in critical fields, validates that numeric scores are within expected ranges, confirms churn flag consistency, and looks for duplicate records. If all checks pass, the dataset is ready to analyse.

### 03_kpi_summary.sql
Calculates the 10 headline numbers shown at the top of the dashboard — total customers, churn rate, active rate, dormant rate, total balance, average balance, high-value customer ratio, high-value customers at risk, average products per customer, and average digital engagement score.

### 04_segmentation_analysis.sql
Breaks the portfolio into segments to find where churn is actually concentrated. Six queries cover: churn by engagement level, churn by product depth, churn by inactivity band, dormancy by account age, value segment distribution, and geographic churn by state.

### 05_risk_assessment.sql
Moves from describing the problem to identifying specific customers who need action. Four queries: the customer engagement funnel, the value × risk matrix, high-value customers at immediate risk, and growth target customers.

---

## Query Results

### Churn Rate by Engagement Band
Customers with low digital engagement (score below 40) churn at **21.13%**, nearly 3× the rate of high-engagement customers at **7.66%**. Medium engagement sits at 12.45%.

<img width="293" height="119" alt="engagement band" src="https://github.com/user-attachments/assets/0fb75f1c-7c3f-4301-ac99-0d02183ed17e" />


---

### Churn Rate by Product Depth
Single-product customers churn at **19.83%**. This drops sharply to **11.64%** at 2 products, and falls to under **4%** from 3 products onwards. The cliff between 1 and 2 products is the most important cross-sell target in the portfolio.

<img width="293" height="205" alt="products depth" src="https://github.com/user-attachments/assets/b100f85b-7587-4f1b-ac04-23fbf6944531" />


---

### Churn Rate by Inactivity Band
Customers who transacted within the last 30 days churn at only **4.42%**. Customers inactive for 61–90 days churn at **74.20%**, and those dormant beyond 90 days churn at **74.11%**. The 31–60 day window is the last practical intervention point before churn probability jumps dramatically.

<img width="273" height="139" alt="inativity band" src="https://github.com/user-attachments/assets/0a60875e-a437-44df-b14c-ae97101e6c8b" />


---

### Dormancy Rate by Account Age
Dormancy is consistent at **11.80–12.17%** across all account age bands, new accounts (under 6 months) go dormant at nearly the same rate as accounts over a year old. This confirms the problem is an onboarding failure, not just a long-term loyalty issue.

<img width="229" height="117" alt="dormancy by age" src="https://github.com/user-attachments/assets/3a67d710-e4f9-4b9b-bf61-dda86ac8e5eb" />


---

### Customer Distribution & Balance by Value Segment
High-value customers (121,433) hold **₦145.6bn** in deposits. Low-value customers (1,365,303) hold only **₦4.6bn** combined. Despite being 6.1% of the customer base, high-value customers control 48% of total deposits, making their retention disproportionately important.

<img width="296" height="112" alt="value segment" src="https://github.com/user-attachments/assets/237acd7e-455e-4a89-b3b8-12d319ed2324" />


---

### Geographic Churn by State
Churn rates are tightly clustered between **13.49% and 13.77%** across all states shown. There are no meaningful geographic outliers, churn is a nationwide behavioural pattern, not a regional one.

<img width="308" height="273" alt="Geography churn" src="https://github.com/user-attachments/assets/75c4915c-62bf-4fb9-9042-438d66c30113" />


---

### Customer Engagement Funnel
Of 2,000,000 total customers: **1,759,764** are active, **1,546,855** are digitally engaged, **1,074,062** hold multiple products, and only **121,433** are high-value. The largest drop-off is between multi-product customers and high-value customers, suggesting the bank has a balance growth challenge even among loyal customers

<img width="635" height="67" alt="engagement funnel" src="https://github.com/user-attachments/assets/0540af3b-dfc4-437d-8f24-f364e2e32f46" />


---

### Value × Risk Matrix
Across all value segments: **412,867 customers are At Risk**, **266,677 have already Churned**, and **1,320,456 are Stable**. Among high-value customers specifically: 26,588 are at risk and 13,630 have churned, representing a significant deposit exposure.

<img width="268" height="247" alt="value x risk" src="https://github.com/user-attachments/assets/7991037c-e4f6-402c-9b1a-36ce6efb76c7" />
Matrix]


---

### High-Value Customers at Immediate Risk
Top customers by outstanding balance who have not yet churned but are showing disengagement signals. The highest-risk account holds **₦41.4M** with an engagement score of just 22 and only 1 product. These are the first accounts the retention team should contact.

<img width="691" height="159" alt="high customer at risk" src="https://github.com/user-attachments/assets/77f81fa0-c71a-42f1-a921-837027425501" />


---

## Key Concepts Used

**Churn:** a customer who has stopped using the bank's services. `churn_90d = TRUE` means the customer left within 90 days of the snapshot date.

**Dormancy:** an account that has gone inactive, as flagged by the bank's system. Not the same as churn — a dormant customer has not fully left yet but has stopped transacting.

**Digital engagement score:** a 0–100 score measuring how actively a customer uses the bank's digital channels. Below 40 is classified as low engagement; 70 and above is high engagement.

**Product depth:** the number of bank products a customer holds. Higher product depth is strongly associated with lower churn.

**Value segment:** customers grouped by total balance: High Value (₦500K+), Mid Value (₦100K–₦499K), Low Value (below ₦100K).

**Value × Risk matrix:** crosses value tier (High/Mid/Low) with risk status (Stable/At Risk/Churned) to create nine segments, each requiring a different retention response.
