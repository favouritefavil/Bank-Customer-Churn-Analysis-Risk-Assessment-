
# Bank Customer Churn Analysis & Risk Assessment

## 📊 Project Overview

A comprehensive data analytics project analyzing customer portfolio health, churn patterns, and retention strategies for a Nigerian bank with 2 million customers and ₦302 billion in deposits.

## 🎯 Business Problem

The bank is experiencing a **13% churn rate**, threatening revenue stability and long-term growth. This project identifies key drivers of customer attrition and provides data-driven recommendations to improve retention.

## 📈 Key Findings

### Critical Metrics
- **Total Customers**: 2,000,000
- **Total Deposits**: ₦302 billion
- **Churn Rate**: 13%
- **Active Customer Rate**: 88%
- **Dormant Customer Rate**: 12%
- **Average Balance per Customer**: ₦151,123
- **High-Value Customer Ratio**: 6.1%
- **Customers at Risk**: 3,260 high-value customers (₦6.5B in deposits)

### Top Insights

1. **Engagement Drives Retention**
   - Low engagement customers: 21% churn rate
   - High engagement customers: 8% churn rate
   - 2.6x difference in retention based on digital engagement

2. **Product Depth Creates Stickiness**
   - Single-product customers: 20% churn rate
   - 4+ product customers: 4% churn rate
   - 900,000 single-product customers represent largest at-risk segment

3. **High-Value Customer Vulnerability**
   - 121,633 high-value customers (6.1% of base)
   - Hold 48% of total deposits (₦145 billion)
   - 3,260 are currently at risk of churning

4. **Early-Stage Dormancy**
   - 12% of accounts <6 months old become dormant
   - Indicates critical onboarding issues
   - First 180 days are crucial for long-term retention

## 🛠️ Technical Stack

- **Database**: PostgreSQL
- **Analysis**: SQL
- **Visualization**: Power BI / Tableau (Dashboard images)
- **Documentation**: Microsoft Word (Executive Review)

## 📁 Project Structure

bank_churn_project/

[SQL analysis.sql](https://github.com/user-attachments/files/24978217/SQL.analysis.sql)


Dashboards

[View the dashboard 1](https://github.com/user-attachments/assets/a386a3cc-de6f-4fa7-bdf2-6f4cb3b8c623)

[View the dashboard 2](https://github.com/user-attachments/assets/ddaa89ff-8a60-496d-931c-37aaa9808d00)

[View the dashboard 3](https://github.com/user-attachments/assets/ba7bf9e5-9127-4d41-a6cb-bd05bd219673)

 
[Executive_Review_Customer_Portfolio_Risk.pdf](https://github.com/user-attachments/files/24978289/Executive_Review_Customer_Portfolio_Risk.pdf)


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
```

## 🔍 Analysis Performed

### 1. **Customer Segmentation**
- Value segments (High/Medium/Low based on balance)
- Engagement bands (High/Medium/Low based on digital score)
- Product depth analysis (1, 2, 3, 4+ products)
- Geographic distribution across Nigerian states

### 2. **Churn Analysis**
- 90-day churn rate by segment
- Churn by engagement level
- Churn by product depth
- Churn by account age
- Geographic churn patterns

### 3. **Risk Assessment**
- High-value customers at risk identification
- Dormancy analysis by account age
- Inactivity band analysis
- Customer health scoring

### 4. **Engagement Funnel**
- Total customers → Active → Digitally Engaged → Multi-Product → High-Value
- Identified drop-off points and conversion opportunities

## 💡 Strategic Recommendations

### Priority 1: High-Value Customer Retention (Immediate)
**Impact**: Protect ₦5.2B in at-risk deposits  
**Timeline**: 30-90 days  

- Deploy dedicated relationship managers
- Personalized outreach to 3,260 at-risk customers
- VIP product bundles and preferential rates
- Premium support channels

### Priority 2: Product Bundling & Cross-Sell (0-60 days)
**Impact**: Reduce churn by 40-60% for targeted segment  
**Timeline**: 60 days  

- Target 900,000 single-product customers
- Create intelligent product recommendations
- Simplified bundling with activation incentives
- In-app campaigns with one-click activation

### Priority 3: Digital Engagement Enhancement (0-90 days)
**Impact**: Improve engagement for 1M+ customers  
**Timeline**: 90 days  

- UX audits and friction elimination
- Personalized push notification strategy
- Financial wellness content and tools
- Biometric authentication improvements

### Priority 4: Onboarding Optimization (30-120 days)
**Impact**: Reduce early-stage dormancy by 50%  
**Timeline**: 120 days  

- Progressive onboarding with milestones
- First 90-day engagement program
- Welcome bonuses for key actions
- Early warning system for dormancy signals

### Priority 5: Predictive Churn Modeling (60-180 days)
**Impact**: Proactive retention for 8-10% of base  
**Timeline**: 180 days  

- Machine learning churn prediction models
- Customer health scoring system
- Automated early intervention workflows
- Tailored retention playbooks

## 💰 Financial Impact

**Total Potential Impact**: ₦29.2 billion in protected deposits over 12 months

| Initiative | Deposit Impact | Timeline |
|------------|---------------|----------|
| High-Value Retention | ₦5.2B | 30-90 days |
| Product Bundling | ₦8.1B | 60-90 days |
| Digital Engagement | ₦4.5B | 90-120 days |
| Onboarding Optimization | ₦2.3B | 120-180 days |
| Predictive Modeling | ₦9.1B | 180-365 days |

## 🎨 Dashboard Previews

The project includes three comprehensive dashboards:

1. **Portfolio Overview**: Customer distribution, engagement metrics, value segments
2. **Product & Engagement Analysis**: Product depth, digital engagement funnel, churn by segment
3. **Risk & Geography**: Activity bands, geographic analysis, customer risk matrix

## 📝 Key SQL Queries

### Churn Rate by Engagement Band
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

### High-Value Customers at Risk
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

## 📚 Lessons Learned

1. **Data Quality Matters**: Ensuring complete customer data was crucial for accurate segmentation
2. **Early Intervention**: Identifying at-risk customers early provides more retention options
3. **Engagement is Key**: Digital engagement proved to be the strongest predictor of retention
4. **Product Cross-Sell**: Simple product bundling can dramatically reduce churn
5. **Geographic Insights**: Regional patterns helped tailor retention strategies

## 🔮 Future Enhancements

- [ ] Implement real-time churn prediction API
- [ ] Build automated customer health scoring dashboard
- [ ] Develop A/B testing framework for retention campaigns
- [ ] Create customer lifetime value (CLV) models
- [ ] Integrate external data sources (economic indicators, competitor activity)
- [ ] Build interactive web dashboard using Plotly/Dash

## 👤 Author

Chegwe Favour
- Role: Financial Data Analyst
- LinkedIn: www.linkedin.com/in/favour-chegwe
- Email: favourchegwec@gmail.com




**Last Updated**: January 2026
