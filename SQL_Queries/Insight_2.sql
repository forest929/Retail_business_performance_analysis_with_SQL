/*
 INSIGHT 2: Sales quantity analysis by product category and size for inventory planning
 STEP 1: Cleaned duplicate records using row_number() to ensure accurate quantity counts
 STEP 2: Created a pivot table showing total quantities sold by category and size
 STEP 3: Ordered by product_category for easy reference by the inventory team
*/
WITH order_product_row_number AS (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY oli.transaction_line_item_id ORDER BY oli.transaction_line_item_id) AS row_number,
        *
    FROM `urbanloom_analytics.order_line_items` oli
        LEFT JOIN `urbanloom_analytics.products` p
            ON oli.product_id = p.product_id
        LEFT JOIN `urbanloom_analytics.order_transactions` ot
            ON oli.order_transaction_id = ot.order_transaction_id
    WHERE EXTRACT(MONTH FROM DATE(ot.order_transaction_date)) < 7
),
    
clean_order_product AS (
    SELECT *
    FROM order_product_row_number
    WHERE row_number = 1
),--STEP 1
    
category_size_quantity AS(
    SELECT
        product_category,
        product_size,
        Quantity
    FROM clean_order_product
    WHERE product_category IS NOT NULL
), --STEP 2 (1)

pivot_table AS (
    SELECT
        *
    FROM category_size_quantity
    PIVOT (SUM(quantity) AS total_quantity for product_size IN ('XS','Small','Medium', 'Large', 'XL', '1X','2X','3X','4X'))
) -- STEP 2(2)

SELECT *
FROM pivot_table
ORDER BY product_category -- STEP 3
