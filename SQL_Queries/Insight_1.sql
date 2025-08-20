/*
   INSIGHT 1: Product performance analysis by category
   STEP 1: Handled duplicate product_id records (from products table) and duplicate order_transaction_id records (from order_transactions table) by keeping only the first occurrence per transaction_line_item_id(full detail see DATA CLEANING NOTES Q1/A1).
   STEP 2: Selected records only from Jan 2024 to June 2024.
   STEP 3: Excluded gift products to avoid confusion, as they have no associated category or costs.
*/

WITH order_product_row_number AS (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY oli.transaction_line_item_id ORDER BY oli.transaction_line_item_id) AS row_number, -- STEP 1(1)
         *
    FROM `urbanloom_analytics.order_line_items` oli
        LEFT JOIN `urbanloom_analytics.products` p 
            ON oli.product_id = p.product_id
        LEFT JOIN `urbanloom_analytics.order_transactions` ot 
            ON oli.order_transaction_id = ot.order_transaction_id
    WHERE EXTRACT(MONTH FROM DATE(ot.order_transaction_date)) < 7 -- STEP 2
),
    
clean_order_product AS (
    SELECT *
    FROM order_product_row_number
    WHERE row_number = 1 -- STEP 1(2)
)

SELECT
    product_category,
    ROUND(SUM(revenue),2) AS total_revenue,
    ROUND(SUM(cost_price * quantity),2) AS total_cost,
    ROUND(((SUM(revenue) - SUM(cost_price * quantity))/SUM(revenue))*100, 2) AS profit_margin_percentage
FROM clean_order_product
WHERE product_category IS NOT NULL --STEP 3
GROUP BY ROLLUP(product_category)
ORDER BY total_revenue DESC, product_category

NOTE: This query includes critical data cleaning procedures, with detailed documentation of data quality issues identified and remediation methods applied.

/*
DATA CLEANING NOTES: Duplicate product_id and order_transaction_id entries affect the accuracy of calculations involving costs!

Q1: Why did the record count increase from 11,038 to 11,323 after JOIN?
A1: Duplicate product_id in the products table (same product, different colors) and duplicate order_transaction_id records in the order_transactions table. After inspecting the duplicate records, I believe that keeping the first record is sufficient.
SOLUTION: Remove duplicates using transaction_line_item_id (unique identifier).
REASONING STEPS: see below - Q1-A1-KEY STEP.

Q2: What are the records with NULL category?
A2: Possibly gift/promotional products in orders.
SOLUTION: Exclude from analysis (no product_category or cost_price data anyway).

Q3: SUM(revenue) vs SUM(ABS(revenue) * quantity) - which is correct?
A3: SUM(revenue) is more accurate (revenue already calculated correctly in the source)
SOLUTION: Use SUM(revenue) directly.

Q4: What are the currencies used?
A4: GBP is the only currency.

FINAL RESULT: Cleaned 10,896 records with accurate revenue/cost calculations.
*/
