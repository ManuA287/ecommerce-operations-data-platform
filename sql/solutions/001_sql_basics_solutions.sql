/*
Solutions for the SQL baseline exercises.

These queries are reference solutions. Different queries may also
be correct if they answer the same business question and produce
the required result.
*/


-- ============================================================
-- Solution 1: Newest orders
-- ============================================================

SELECT
    order_id,
    order_status,
    order_purchase_timestamp
FROM raw.olist_orders
ORDER BY order_purchase_timestamp DESC
LIMIT 20;


-- ============================================================
-- Solution 2: Delivered orders within a defined period
-- ============================================================

SELECT
    order_id,
    order_status,
    order_purchase_timestamp
FROM raw.olist_orders
WHERE order_status = 'delivered'
  AND order_purchase_timestamp >= TIMESTAMP '2018-01-01 00:00:00'
  AND order_purchase_timestamp < TIMESTAMP '2018-04-01 00:00:00'
ORDER BY order_purchase_timestamp;


-- ============================================================
-- Solution 3: Orders without payment approval
-- ============================================================

SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at
FROM raw.olist_orders
WHERE order_approved_at IS NULL
ORDER BY order_purchase_timestamp;


-- ============================================================
-- Solution 4: Total number of orders
-- ============================================================

SELECT
    COUNT(*) AS total_orders
FROM raw.olist_orders;


-- ============================================================
-- Solution 5: Orders by status
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS order_count
FROM raw.olist_orders
GROUP BY order_status
ORDER BY order_count DESC;


-- ============================================================
-- Solution 6: Monthly order development
-- ============================================================

SELECT
    DATE_TRUNC(
        'month',
        order_purchase_timestamp
    )::date AS purchase_month,
    COUNT(DISTINCT order_id) AS order_count
FROM raw.olist_orders
GROUP BY
    DATE_TRUNC('month', order_purchase_timestamp)
ORDER BY purchase_month;


-- ============================================================
-- Solution 7: Relevant order statuses
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS order_count
FROM raw.olist_orders
GROUP BY order_status
HAVING COUNT(*) >= 100
ORDER BY order_count DESC;


-- ============================================================
-- Solution 8: Average delivery duration
-- ============================================================

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400.0
        ),
        2
    ) AS average_delivery_days
FROM raw.olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- ============================================================
-- Solution 9: Late-delivery performance
-- ============================================================

SELECT
    COUNT(*) AS evaluated_orders,

    COUNT(*) FILTER (
        WHERE order_delivered_customer_date
              > order_estimated_delivery_date
    ) AS late_orders,

    ROUND(
        100.0
        * COUNT(*) FILTER (
            WHERE order_delivered_customer_date
                  > order_estimated_delivery_date
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_rate_percent

FROM raw.olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- ============================================================
-- Solution 10: Delivered orders by customer state
-- ============================================================

SELECT
    customers.customer_state,
    COUNT(DISTINCT orders.order_id) AS delivered_order_count
FROM raw.olist_orders AS orders
INNER JOIN raw.olist_customers AS customers
    ON orders.customer_id = customers.customer_id
WHERE orders.order_status = 'delivered'
GROUP BY customers.customer_state
ORDER BY delivered_order_count DESC
LIMIT 10;