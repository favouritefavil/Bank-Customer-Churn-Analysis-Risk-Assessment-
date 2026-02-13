# Bank Customer Churn Analysis & Risk Assessment

## 📊 Project Overview

A comprehensive data analytics project analyzing customer
portfolio health, churn patterns, and retention strategies for a Nigerian bank with 2 million customers and ₦302 billion in deposits.

## 🎯 Business Problem

The bank is experiencing a **13% churn rate**, threatening revenue stability and long-term growth. 
This project identifies key drivers of customer attrition and provides data-driven recommendations to improve retention.

## 📊 Key Findings

### Critical Metrics
- **Total Customers**: 2,000,000
- **Total Deposits**: ₦302 billion
- **Churn Rate**: 13%
- **Active Customer Rate**: 88%
- **Dormant Customer Rate**: 12%
- **Average Balance per Customer**: ₦151,123
- **High-Value Customer Ratio**: 6.1%
- **Customers at Risk**: 3,260 high-value customers (₦6.5B in deposits)

### 📊 Interactive Dashboards
View the complete analysis dashboards:
- **[Portfolio & Risk Overview](dashboards/customer_portfolio_1.PNG)** - Customer distribution, value segments, engagement metrics
- **[Product & Engagement Analysis](dashboards/customer_portfolio_2.PNG)** - Product depth, digital engagement, customer funnel
- **[Geographic & Risk Distribution](dashboards/customer_portfolio_3.PNG)** - State-level analysis, activity patterns, risk matrix

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

## 📁 Project Files

```
bank_churn_project/
│
├── README.md                                 
│   │── Sql                                         
│   ├── Data Quality Checks                     
│   ├── KPI Calculations (11 metrics)            
│   ├── Segmentation Analysis                    
│   ├── Churn Analysis by Multiple Dimensions   
│   ├── Risk Assessment Queries                 
│   └── Customer Targeting Queries            
│
├── dashboards/                                 
│   ├── customer_portfolio_1.PNG                 
│   │
│   ├── customer_portfolio_2.PNG                
│   │
│   └── customer_portfolio_3.PNG                 
│
├── executive_review/                           
│   └── Executive_Review_Customer_Portfolio_Risk.docx
│
└── data/
    └── schema.sql                               


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



## 🚀 Getting Started

### Prerequisites
- PostgreSQL database
- SQL client (pgAdmin, DBeaver, or similar)
- Power BI or Tableau for visualization

### Running the Analysis

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/bank-churn-analysis.git
cd bank-churn-analysis
```

2. **Set up the database**
```bash
psql -U your_username -d your_database -f schema.sql
# Load your data into the customer table
```

3. **Run the analysis queries**
```bash
psql -U your_username -d your_database -f analysis.sql
```

4. **Review the results**
- Check query outputs in your SQL client
- Review dashboard images in `/dashboards/`
- Read executive summary in `/executive_review/`

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

### Churn Rate by Product Depth
```sql
SELECT
    products_count,
    COUNT(*) AS customers,
    ROUND(AVG(churn_90d::INT) * 100, 2) AS churn_rate_pct
FROM customer
GROUP BY products_count
ORDER BY products_count;
```

### Customer Engagement Funnel
```sql
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE dormant_flag = FALSE) AS active_customers,
    COUNT(*) FILTER (WHERE digital_engagement_score >= 40) AS digitally_engaged,
    COUNT(*) FILTER (WHERE products_count >= 2) AS multi_product_customers,
    COUNT(*) FILTER (WHERE total_balance_ngn >= 500000) AS high_value_customers
FROM customer;
```

### Value × Risk Matrix
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

## 📚 Lessons Learned

1. **Data Quality Matters**: Ensuring complete customer data was crucial for accurate segmentation
2. **Early Intervention**: Identifying at-risk customers early provides more retention options
3. **Engagement is Key**: Digital engagement proved to be the strongest predictor of retention
4. **Product Cross-Sell**: Simple product bundling can dramatically reduce churn
5. **Geographic Insights**: Regional patterns helped tailor retention strategies



## 👤 Author

Chegwe Favour
- Role: Financial Data Analyst
- LinkedIn: www.linkedin.com/in/favour-chegwe
- Email: favourchegwec@gmail.com




**Last Updated**: January 2026
