# UrbanLoom SQL Project  

## Overview  
This project analyses retail business performance using SQL. The workflow includes data cleaning, extraction, and advanced querying to generate actionable business insights.  

A key challenge was **duplicate transaction IDs**, which caused inaccuracies in revenue calculations. By resolving these issues, the analysis provides a reliable foundation for decision-making in product, inventory, and store performance strategies.  



## Objectives  
- Clean and validate raw transaction data to ensure accuracy  
- Apply advanced SQL functions for efficient data extraction and reporting  
- Deliver insights into product profitability, inventory planning, and store performance  



## Key Steps  

### 1. Data Cleaning Notes  
A major focus of this project was ensuring data accuracy before analysis. Key steps included:  
- **Duplicate Handling:** Detected and removed ~200 duplicate `transaction_line_item_id` values that were inflating revenue calculations.  
- **Revenue Validation:** Recalculated revenue by cross-checking unit price × quantity to correct mismatches.  
- **Null and Missing Values:** Identified incomplete records and applied filtering rules to maintain consistency.

> **_Key Highlight: Handling JOIN-Induced Duplicates_** - you can see the step by step validation here: [SQL_Queries/Key_clearning_step.sql](SQL_Queries/Key_clearning_step.sql)


### 2. Data Analysis  
- Applied `JOIN`, `GROUP BY`, and `CASE` statements for data aggregation  
- Implemented subqueries and CTEs for modular, readable analysis  
- Designed queries to calculate accurate revenue and highlight discrepancies  

### 3. Reporting  
- Generated summary tables and dashboards to track performance  
- Ensured results were reproducible and transparent through SQL scripts  



## Insights  
- **Product Profitability:** Identified top-performing and underperforming products  
- **Inventory Planning:** Highlighted stock imbalances to inform purchasing decisions  
- **Store Performance:** Evaluated location-based sales to optimise store strategy  



## Tools & Technologies  
- SQL (**BigQuery**)  
- Data cleaning and validation queries  
- GitHub for version control  


