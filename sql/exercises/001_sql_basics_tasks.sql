/*
SQL baseline exercises

Purpose:
Evaluate the current SQL knowledge using filtering, sorting,
aggregations, grouping, HAVING, date calculations, and a JOIN.

Rules:
1. Solve each task before opening the solution file.
2. Execute each query separately.
3. Add short notes when a result is unexpected.
4. Do not modify the raw source tables.
*/


-- ============================================================
-- Exercise 1: Newest orders
-- Business question:
-- Which 20 orders were purchased most recently?
--
-- Requirements:
-- - Return order_id, order_status, and order_purchase_timestamp.
-- - Sort newest orders first.
-- - Limit the result to 20 rows.
-- ============================================================

-- Write your query here:
select 
	order_id, 
	order_status, 
	order_purchase_timestamp 
from raw.olist_orders
order by order_purchase_timestamp desc
limit 20;


-- ============================================================
-- Exercise 2: Delivered orders within a defined period
-- Business question:
-- Which orders purchased during the first quarter of 2018
-- were successfully delivered?
--
-- Requirements:
-- - Return order_id, order_status, and order_purchase_timestamp.
-- - Include purchases from 2018-01-01 up to, but not including,
--   2018-04-01.
-- - Include only delivered orders.
-- - Sort chronologically.
-- ============================================================

-- Write your query here:
select
	order_id,
	order_status,
	order_purchase_timestamp
from raw.olist_orders
where order_status = 'delivered'
	and order_purchase_timestamp >= TIMESTAMP '2018-01-01 00:00:00'
  	and order_purchase_timestamp < TIMESTAMP '2018-04-01 00:00:00'
order by order_purchase_timestamp;


-- ============================================================
-- Exercise 3: Orders without payment approval
-- Business question:
-- Which orders do not have a recorded payment-approval timestamp?
--
-- Requirements:
-- - Return order_id, order_status, order_purchase_timestamp,
--   and order_approved_at.
-- - Filter for missing approval timestamps.
-- - Show the oldest orders first.
-- ============================================================

-- Write your query here:
select
	order_id,
	order_status,
	order_purchase_timestamp,
	order_approved_at
from raw.olist_orders
where order_approved_at is null
order by order_purchase_timestamp;


-- ============================================================
-- Exercise 4: Total number of orders
-- Business question:
-- How many orders are available in the source table?
--
-- Requirements:
-- - Return one row.
-- - Name the result column total_orders.
-- ============================================================

-- Write your query here:
select 
	count(*) as total_orders
from raw.olist_orders;


-- ============================================================
-- Exercise 5: Orders by status
-- Business question:
-- How many orders exist for each order status?
--
-- Requirements:
-- - Return order_status and order_count.
-- - Group the rows by order status.
-- - Show the most common status first.
-- ============================================================

-- Write your query here:
select
	order_status,
	count(*) as order_count
from raw.olist_orders
group by order_status
order by order_count desc;


-- ============================================================
-- Exercise 6: Monthly order development
-- Business question:
-- How did order volume develop by purchase month?
--
-- Requirements:
-- - Create a purchase_month value from order_purchase_timestamp.
-- - Count distinct order_id values.
-- - Return purchase_month and order_count.
-- - Sort chronologically.
-- ============================================================

-- Write your query here:
select
	date_trunc(
		'month',
		order_purchase_timestamp
	)::date as purchase_month,
	count(distinct order_id) as order_count
from raw.olist_orders
group by
	date_trunc('month', order_purchase_timestamp)
order by purchase_month;


-- ============================================================
-- Exercise 7: Relevant order statuses
-- Business question:
-- Which order statuses occur at least 100 times?
--
-- Requirements:
-- - Return order_status and order_count.
-- - Group by order status.
-- - Keep only groups with at least 100 orders.
-- - Show the largest group first.
-- ============================================================

-- Write your query here:
select 
	order_status,
	count(*) as order_count
from raw.olist_orders 
group by order_status
having count(*) >= 100
order by order_count desc;


-- ============================================================
-- Exercise 8: Average delivery duration
-- Business question:
-- How many days does delivery take on average for delivered orders?
--
-- Requirements:
-- - Use the time between order_purchase_timestamp and
--   order_delivered_customer_date.
-- - Include only delivered orders.
-- - Exclude rows without a customer-delivery timestamp.
-- - Return the average as a numeric number of days.
-- - Round the result to two decimal places.
-- ============================================================

-- Write your query here:
select 
	round(
		avg(
			extract(
				epoch from (
					order_delivered_customer_date
					- order_purchase_timestamp
				)
			) / 86400.0
		),
		2
	) as avg_delivery_days
from raw.olist_orders
where order_status = 'delivered'
	and order_delivered_customer_date is not null;


-- ============================================================
-- Exercise 9: Late-delivery performance
-- Business question:
-- How many delivered orders arrived late, and what percentage
-- of the evaluated delivered orders does this represent?
--
-- Requirements:
-- - Include only delivered orders.
-- - Both actual and estimated delivery dates must be available.
-- - An order is late when the actual delivery timestamp is later
--   than the estimated delivery timestamp.
-- - Return:
--     evaluated_orders
--     late_orders
--     late_delivery_rate_percent
-- - Round the percentage to two decimal places.
-- ============================================================

-- Write your query here:
select
	count(*) as evaluated_orders,
	count(*) filter (
		where order_delivered_customer_date
			> order_estimated_delivery_date
	) as late_orders,
	round(
		100.0
		* count(*) filter (
			where order_delivered_customer_date
				> order_estimated_delivery_date
		)
		/ nullif (count(*), 0),
		2
	) as late_delivery_rate_percent
from raw.olist_orders
where order_status = 'delivered'
	and order_delivered_customer_date is not null 
	and order_estimated_delivery_date is not null;


-- ============================================================
-- Exercise 10: Delivered orders by customer state
-- Business question:
-- Which customer states have the highest number of delivered orders?
--
-- Requirements:
-- - JOIN raw.olist_orders with raw.olist_customers.
-- - Connect both tables using customer_id.
-- - Include only delivered orders.
-- - Return customer_state and delivered_order_count.
-- - Count distinct order_id values.
-- - Show the ten states with the most delivered orders.
-- ============================================================

-- Write your query here:
select 
	customers.customer_state,
	count(distinct orders.order_id) as delivered_order_count
from raw.olist_orders as orders
inner join raw.olist_customers as customers
	on orders.customer_id = customers.customer_id 
where orders.order_status = 'delivered'
group by customers.customer_state 
order by delivered_order_count desc
limit 10;