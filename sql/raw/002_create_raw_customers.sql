-- Create the raw customers table.
-- One row represents one customer record used for a specific order.

CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.olist_customers (
    customer_id text PRIMARY KEY,
    customer_unique_id text NOT NULL,
    customer_zip_code_prefix text,
    customer_city text,
    customer_state text
);

COMMENT ON TABLE raw.olist_customers IS
    'Raw customer data imported from olist_customers_dataset.csv.';

COMMENT ON COLUMN raw.olist_customers.customer_id IS
    'Identifier used to connect a customer record with an order.';

COMMENT ON COLUMN raw.olist_customers.customer_unique_id IS
    'Identifier used to recognize the same customer across multiple orders.';

COMMENT ON COLUMN raw.olist_customers.customer_zip_code_prefix IS
    'First digits of the customer postal code, stored as text to preserve leading zeros.';

COMMENT ON COLUMN raw.olist_customers.customer_city IS
    'Customer city from the source dataset.';

COMMENT ON COLUMN raw.olist_customers.customer_state IS
    'Two-letter Brazilian state code.';