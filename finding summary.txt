## Finding 1: Aggressive Discounting is Destroying Profit

- 1,871 transactions (18.7% of all rows) have negative profit
- Total profit loss from these rows: -$156,131.86
- Root cause: Discounts above 20% consistently produce negative margins
- Most affected category: Office Supplies
- Worst single transaction: -$6,599.98 at 80% discount

Recommendation: Cap discounts at 20% company-wide. 
Review and reprice Office Supplies discount policy immediately.



## Finding 2: The 20% Discount Threshold is the Break-Even Point

Discount Bucket    | Transactions | Total Profit   | Margin %
0% No Discount     |  4798        |       320987.88|  29.51
1-10%              |  94          |         9029.21|  16.61
11-20%             |  3709        |        91757.14|  11.58
21-30%             |  227         |       -10369.34| -10.05 ← turns negative
31-50%             |  310         |       -48447.87| -24.81
Over 50%           |  856         |       -76559.23| -119.20

Key Finding: Discounts above 20% generated -$135,376.44 in total losses
despite producing real sales revenue. The company is selling below cost
on every transaction above the 20% threshold.

Recommendation: Implement a hard cap of 20% on all discounts company-wide.
Require VP approval for any exception above this threshold.



## Data Cleaning Summary

| Issue                  | Action Taken              | Rows Affected |
|------------------------|---------------------------|---------------|
| Duplicate check        | ROW_NUMBER deduplication  | 0 duplicates  |
| NULL values            | None found                | 0             |
| Whitespace in text     | TRIM applied to all cols  | Preventative  |
| Added profit_margin    | profit / sales * 100      | 9,994 rows    |
| Added order_year       | EXTRACT from order_date   | 9,994 rows    |
| Added order_month      | EXTRACT from order_date   | 9,994 rows    |
| Added days_to_ship     | ship_date - order_date    | 9,994 rows    |

Raw data preserved in raw_sales table. All analysis uses cleaned_sales.


---

# Retail Sales Performance Analysis
## Executive Summary

**To:** VP of Sales  
**From:** Samuel Gomez, Data Analyst  
**Date:** 04/02/2026  
**Re:** Sales Performance Analysis — Key Findings & Recommendations

---

### SITUATION
We analyzed 9,994 transactions across 4 regions spanning 2014-2017, 
covering 793 unique customers, 1,862 products, and $2.3M in total revenue.

---

### COMPLICATION
Despite strong revenue growth — particularly in Q4 — the business is 
generating significant profit losses driven by an aggressive and 
inconsistent discount policy. 1,871 transactions (18.7% of all sales) 
produced negative profit, totaling -$156,131.86 in losses.

---

### KEY FINDINGS

**Finding 1: Our Discount Policy Has a Clear Break-Even Point**

Every transaction discounted above 20% generates negative profit.
Transactions above this threshold produced -$135,376.44 in total losses
despite generating real sales revenue. We are selling below cost on
nearly 1 in 5 transactions.

Recommendation: Implement a hard 20% discount cap company-wide.
Require VP approval for any exception.

---

**Finding 2: Technology is Our Most Valuable Category**

Copiers and Phones generate our highest profit margins consistently 
across all regions and years. The Canon imageCLASS 2200 Advanced Copier 
alone is our single most profitable product.

However, certain Machines within Technology are loss-making and heavily 
discounted these products cannot sustain a viable price point.

Recommendation: Double investment in Copiers and Phones marketing.
Audit Machines sub-category for discontinuation candidates.

---

**Finding 3: Q4 Seasonality is Real But Potentially Dangerous**

Revenue in September, November, and December doubles compared to other 
months likely driven by holiday consumer spending. However, holiday 
discount promotions during this period may be eroding margins at our 
highest-volume period.

Recommendation: Review all discount exceptions approved during Q4.
Ensure holiday promotions stay within the 20% threshold.

---

**Finding 4: The Central Region Requires Immediate Attention**

The Central region is the only region operating at a negative average 
profit margin of -10.41%. Multiple sub-categories are selling at a loss 
including Appliances (-125.01% avg margin), Binders, Furnishings, 
Tables, and Bookcases all discounted above the 20% break-even point.

Furniture revenue is growing year over year in this region, but since 
it is sold at a loss, more sales means more losses.

Recommendation: Conduct immediate audit of Central region discount 
approvals. Renegotiate supplier costs on Appliances and Furniture or 
discontinue underperforming SKUs.

---

**Finding 5: Corporate Segment is an Untapped Opportunity**

While Consumer is our largest segment by customer count (409 customers, 
$134,119 profit), Corporate customers generate significantly higher 
profit per customer despite fewer accounts. Corporate buyers purchase 
more per transaction and are less reliant on discounts.

Recommendation: Build a dedicated Corporate acquisition strategy.
Research top-selling products within Corporate to focus sales efforts.

---

**Finding 6: Furniture Growth is Masking a Profitability Problem**

Furniture has shown consistent revenue growth from 2014-2017, averaging 
8.3% year over year. However it operates at thin or negative margins 
particularly in the Central region. Growing a loss-making category 
accelerates losses, not profits.

Recommendation: Fix Furniture pricing and supplier costs before 
continuing to scale this category.

---

### PROJECTED IMPACT

| Recommendation              | Estimated Annual Impact        |
|-----------------------------|--------------------------------|
| 20% discount cap            | Recover up to $135,376/year    |
| Central region audit        | Reduce regional losses         |
| Technology focus            | Expand highest-margin category |
| Corporate segment strategy  | Increase profit per customer   |

---

### WHAT I WOULD DO WITH MORE TIME
- Basket analysis: What products are bought together?
- Customer lifetime value calculation per segment
- Supplier cost analysis to identify renegotiation targets
- Store count by region to explain South region order volume
