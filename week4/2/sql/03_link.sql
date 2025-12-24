CREATE TABLE lnk_line_order(
    link_hash_key BYTEA PRIMARY KEY,
    order_hash_key BYTEA NOT NULL REFERENCES hub_order(order_hash_key),
    customer_hash_key BYTEA NOT NULL REFERENCES hub_customer(customer_hash_key),
    product_hash_key BYTEA NOT NULL REFERENCES hub_product(product_hash_key),
    status_hash_key BYTEA NOT NULL REFERENCES hub_order_status(status_hash_key),
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    UNIQUE (order_hash_key, customer_hash_key, product_hash_key, status_hash_key)
);

