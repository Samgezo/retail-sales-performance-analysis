Retail Sales Performance Analysis
Tools: PostgreSQL · Python · Power BI
Skills: Data Cleaning · SQL Analysis · Business Intelligence

Business Problem

A retail company's VP of Sales needed answers to four questions about 
their transactional data:

- What's selling and what's not?
- Where are we making money?
- Where are we losing money?
- What should we do about it?

The data was described as "a mess." My job was to clean it, analyze it, 
and deliver actionable findings.


Dataset

- **Source:** Kaggle Superstore Sales Dataset https://www.kaggle.com/datasets/vivek468/superstore-dataset-final
- **Size:** 9,994 transactions across 4 years (2014–2017)
- **Scope:** 793 customers · 1,862 products · 4 regions · $2.3M revenue

My Approach

I treated this like a real analyst engagement — starting with business 
questions, not the data. Every technical decision was made in service 
of answering something the business actually needed to know.

1. Profile the data → understand what we're working with
2. Clean the data  → build a reliable foundation
3. Analyze         → answer the business questions
4. Document        → turn findings into recommendations


Data Cleaning Summary

Raw data was loaded into PostgreSQL for profiling before any cleaning 
was performed. Key decisions made:

| Issue Found              | Decision                        | Rows Affected |
|--------------------------|---------------------------------|---------------|
| Duplicate row check      | ROW_NUMBER deduplication        | 0 duplicates  |
| NULL value check         | None found in critical columns  | 0             |
| Whitespace in categories | TRIM applied defensively        | Preventative  |
| Added profit_margin col  | Calculated: profit/sales × 100  | 9,994 rows    |
| Added order_year col     | Extracted from order_date       | 9,994 rows    |
| Added order_month col    | Extracted from order_date       | 9,994 rows    |
| Added days_to_ship col   | ship_date minus order_date      | 9,994 rows    |

**Raw data was preserved untouched in 'raw_sales'. All analysis was 
performed on 'cleaned_sales'.**


Key Findings

🔴 Finding 1: Discount Policy is Destroying Profit

- **1,871 transactions (18.7%)** generated negative profit
- **Total losses: -$156,131.86** from discounted transactions
- **Root cause:** The break-even discount threshold is 20%
- Every transaction above 20% discount sells below cost
- Transactions above this threshold alone account for **-$135,376** 
  in losses

> **Recommendation:** Implement a hard 20% discount cap company-wide.
> Require VP approval for any exception above this threshold.


🟢 Finding 2: Technology is Our Highest-Value Category

- Copiers and Phones generate the **highest profit margins** consistently across all regions
- The Canon imageCLASS 2200 Advanced Copier is our **single most profitable product**
- Technology grows year-over-year while maintaining strong margins

> **Recommendation:** Prioritize marketing and inventory investment 
> in Copiers and Phones. Audit Machines sub-category for 
> discontinuation candidates.


🟡 Finding 3: Q4 Seasonality is Real But Potentially Risky

- Revenue in **September, November, and December doubles** compared 
  to other months
- Holiday discount promotions likely drive volume during this period
- Risk: Holiday discounts may be eroding margins at our highest 
  revenue period

> **Recommendation:** Review all discount exceptions during Q4. 
> Ensure holiday promotions stay within the 20% threshold.


🔴 Finding 4: Central Region Requires Immediate Action

- **Only region with a negative average profit margin: -10.41%**
- Multiple sub-categories selling at a loss:
  - Appliances: **-125.01% avg margin** (worst offender)
  - Binders, Furnishings, Tables, Bookcases all negative
- All underperforming sub-categories discounted above 20% threshold
- Furniture revenue is growing — but since it sells at a loss, **more growth means more losses**

> **Recommendation:** Immediate audit of Central region discount 
> approvals. Renegotiate supplier costs or discontinue 
> underperforming SKUs.


🟢 Finding 5: Corporate Segment is an Untapped Opportunity

- **Consumer** is largest by count (409 customers, $134,119 profit)
- **Corporate** generates significantly higher profit per customer
- Corporate buyers purchase more per transaction with less 
  reliance on discounts

> **Recommendation:** Build a dedicated Corporate acquisition 
> strategy. Research top products within Corporate to focus 
> sales efforts.



🟡 Finding 6: Furniture Growth is Masking a Loss Problem

- Furniture shows consistent revenue growth 2014–2017 (~8.3% avg)
- But operates at thin or negative margins, especially in Central
- Growing a loss-making category accelerates losses, not profits

> **Recommendation:** Fix Furniture pricing and supplier costs 
> before continuing to scale this category.


Projected Impact

| Recommendation             | Estimated Annual Impact       |
|----------------------------|-------------------------------|
| 20% discount cap           | Recover up to $135,376/year   |
| Central region audit       | Reduce regional losses         |
| Technology focus           | Expand highest-margin category |
| Corporate segment strategy | Increase profit per customer   |


Repository Structure
```
Project-1-Retail-Sales-Analysis/
│
├── data/
│   ├── raw/                    ← Original data (never modified)
│   └── cleaned/                ← Cleaned exports
│
├── sql/
│   ├── 01_create_tables.sql    ← Table definitions
│   ├── 02_data_cleaning.sql    ← Cleaning pipeline
│   ├── 03_exploratory_queries.sql  ← Profiling queries
│   └── 04_business_questions.sql  ← Analysis queries
│
├── python/
│   └── cleaning_script.py      ← Encoding fix + CSV prep
│
├── findings_summary.md         ← Full findings & recommendations
└── README.md                   ← You are here

How to Reproduce This Analysis

1. Clone this repository
2. Download the Superstore dataset from Kaggle and place in 'data/raw/'
3. Run 'python/cleaning_script.py' to generate clean CSV
4. Execute SQL scripts in order (01 → 04) in PostgreSQL
5. Open 'findings_summary.md' for full business write-up

**Requirements:**
- PostgreSQL 14+
- pgAdmin 4
- Python 3.12+
- pandas (`pip install pandas`)


What I Would Do With More Time

- **Basket analysis:** What products are frequently bought together?
- **Customer lifetime value:** Which customers are worth acquiring?
- **Supplier cost analysis:** Identify renegotiation targets in 
  Furniture and Appliances
- **Regional store count:** Verify whether South region low order 
  volume is explained by fewer store locations
- **Predictive model:** Forecast Q4 revenue and recommended 
  inventory levels


What I Learned

The most valuable skill in this project wasn't SQL — it was learning 
to ask *why* before accepting any number at face value. The -$6,599 
loss on a single transaction wasn't a data error. It was evidence of 
a broken discount policy that cost the company over $135,000 annually.

Data tells a story. The analyst's job is to find it.
