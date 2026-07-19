-- Create the raw schema for unmodified source data
CREATE SCHEMA IF NOT EXISTS raw;

-- Create first source table.
CREATE TABLE IF NOT EXISTS raw.olist_orders (
    order_id text PRIMARY KEY,
    customer_id text NOT NULL,
    order_status text NOT NULL,
    order_purchase_timestamp timestamp without time zone NOT NULL,
    order_approved_at timestamp without time zone,
    order_delivered_carrier_date timestamp without time zone,
    order_delivered_customer_date timestamp without time zone,
    order_estimated_delivery_date timestamp without time zone
);

COMMENT ON TABLE raw.olist_orders IS
    'Raw order data imported from olist_orders_dataset.csv.';

COMMENT ON COLUMN raw.olist_orders.order_id IS
    'Unique identifier of an order. One row represents one order.';

COMMENT ON COLUMN raw.olist_orders.customer_id IS
    'Customer identifier used to join the orders and customers datasets.';

COMMENT ON COLUMN raw.olist_orders.order_status IS
    'Current or final status of the order.';

COMMENT ON COLUMN raw.olist_orders.order_purchase_timestamp IS
    'Timestamp when the customer placed the order.';

COMMENT ON COLUMN raw.olist_orders.order_approved_at IS
    'Timestamp when payment approval was recorded.';

COMMENT ON COLUMN raw.olist_orders.order_delivered_carrier_date IS
    'Timestamp when the order was handed to the carrier.';

COMMENT ON COLUMN raw.olist_orders.order_delivered_customer_date IS
    'Timestamp when the order was delivered to the customer.';

COMMENT ON COLUMN raw.olist_orders.order_estimated_delivery_date IS
    'Estimated delivery timestamp communicated to the customer.';