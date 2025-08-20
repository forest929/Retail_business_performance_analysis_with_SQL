/*
Q1-A1-KEY STEP: Handling JOIN-induced duplicates for accurate financial calculations.

PROBLEM CONTEXT:
   1. There are duplicates on the PK in two tables:
     - products table: 839 unique product_id in total 843 records (same product_id with different colors/variants).
     - order_transactions table: 6,281 unique order_transaction_id in total 6,351 records.
   2. When joining (LEFT JOIN) order_line_items with these two tables, the record count increased from 11,038 to 11,323 records.This creates duplicate transaction_line_item_id records that will cause incorrect calculations of:
     - Total revenue (sum of revenue field)
     - Total quantities (affecting cost calculations: quantity * cost_price)

EXPLORATION: Examine the duplicates in the products and order_transactions tables separately, verify that duplicate records contain identical values for fields that impact financial calculations.
*/

--VALIDATION 1: Do duplicate records have the identical cost_price value?
--Find duplicates in the products table.
WITH duplicate_in_products AS (
    SELECT *
    FROM `urbanloom_analytics.products`
    WHERE product_id IN (
       SELECT product_id
       FROM `urbanloom_analytics.products` 
       GROUP BY product_id
       HAVING COUNT(*) > 1)
)
--Find out how many unique cost_price for each duplicate product_id.
SELECT
    product_id,
    COUNT(DISTINCT cost_price) AS unique_cost_count
FROM duplicate_in_products
GROUP BY product_id -- all unique_cost_count = 1, great news! -- If unique_cost_count = 1 for all product_ids: All duplicates have identical cost_price.
-- This confirms it's safe to remove duplicates after JOIN without affecting calculations.
-- Any product_id with unique_cost_count > 1 would require further investigation.


--VALIDATION 2: Examine all fields in the duplicate records.
SELECT *
FROM `urbanloom_analytics.order_transactions`
WHERE order_transaction_id IN (
    SELECT order_transaction_id
    FROM `urbanloom_analytics.order_transactions`
    GROUP BY order_transaction_id
    HAVING COUNT(*) > 1)
--OBSERVATION: The order_transactions table contains no fields directly related to cost_price, quantity, or revenue calculations.
--CONCLUSION: Safe to deduplicate after JOIN without impacting financial accuracy.
