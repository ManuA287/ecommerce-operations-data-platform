-- 1. Count all imported orders.
SELECT COUNT(*) AS total_orders
FROM raw.olist_orders;

-- 2. Display a small sample.
SELECT *
FROM raw.olist_orders
ORDER BY order_purchase_timestamp
LIMIT 10;

-- 3. Check the number of distinct order IDs.
SELECT
    COUNT(*) as total_rows,
    COUNT(DISTINCT order_id) AS distinct_order_ids
FROM raw.olist_orders;

-- 4. Review order status distribution.
SELECT
    order_status,
    COUNT(*) AS order_count
FROM raw.olist_orders
GROUP BY order_status
ORDER BY order_count DESC;

-- 5. Review the covered purchase period.
SELECT
    MIN(order_purchase_timestamp) AS first_purchase,
    MAX(order_purchase_timestamp) AS last_purchase
FROM raw.olist_orders;

-- 6. Count missing values in optional timestamp columns.
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE order_approved_at IS NULL
    ) AS missing_approved_at,
    COUNT(*) FILTER (
        WHERE order_delivered_carrier_date IS NULL
    ) AS missing_carrier_date,
    COUNT(*) FILTER (
        WHERE order_delivered_customer_date IS NULL
    ) AS missing_customer_delivery_date,
    COUNT(*) FILTER (
        WHERE order_estimated_delivery_date IS NULL
    ) AS missing_estimated_delivery_date
FROM raw.olist_orders;

-- 7. Check for duplicate order IDs.
-- Expected result: zero rows.
SELECT
    order_id,
    COUNT(*) AS occurrence_count
FROM raw.olist_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 8. Identify potentially illogical delivery timestamps.
SELECT COUNT(*) AS delivered_before_purchase
FROM raw.olist_orders
WHERE order_delivered_customer_date < order_purchase_timestamp;