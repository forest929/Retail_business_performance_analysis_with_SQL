/*
    INSIGHT 3: Urban Loom Store Location Analysis
    STEP 1: Cleaned the duplicates and focused only on cities in the UK and excluded July (Month 7) from analysis
    STEP 2: Used ROLLUP to show both city revenue totals and breakdowns by city and month         
    STEP 3: Ordered the results by total revenue and identified the top 3 potential locations for the new store.
*/
WITH customer_items_transaction AS (
        SELECT
        c.city,
        c.country,
        ot.order_transaction_date,
        oli.*,
        ROW_NUMBER() OVER (PARTITION BY oli.transaction_line_item_id ORDER BY oli.transaction_line_item_id) AS row_number
    FROM `urbanloom_analytics.order_line_items` oli
        LEFT JOIN `urbanloom_analytics.order_transactions` ot
         	ON oli.order_transaction_id = ot.order_transaction_id
        LEFT JOIN `urbanloom_analytics.customers` c
         	ON ot.customer_id = c.customer_id
),

cleaned_customer_items_transaction AS (
    SELECT *
    FROM customer_items_transaction
    WHERE row_number = 1 -- STEP 1 (1)
)

SELECT
    city,
    EXTRACT(MONTH FROM DATE(order_transaction_date)) AS month,
    ROUND(SUM(revenue), 2) AS total_revenue,
FROM cleaned_customer_items_transaction
WHERE country = 'United Kingdom'  -- STEP 1 (2)
    AND EXTRACT(MONTH FROM DATE(order_transaction_date)) < 7 -- STEP 1 (3)
GROUP BY ROLLUP (city, month) -- STEP 2
ORDER BY 
    SUM(SUM(revenue)) OVER (PARTITION BY city) DESC,-- STEP 3 (1)
    city,
    month 
LIMIT 22 -- STEP 3 (2)
