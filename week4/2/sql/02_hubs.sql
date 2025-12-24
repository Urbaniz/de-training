CREATE TABLE hub_customer(
    customer_hash_key BYTEA PRIMARY KEY,
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    customer_number VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE hub_product(
    product_hash_key BYTEA PRIMARY KEY,
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    product_number VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE hub_order_status(
    status_hash_key BYTEA PRIMARY KEY,
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE hub_order(
    order_hash_key BYTEA PRIMARY KEY,
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    order_number VARCHAR(255) NOT NULL UNIQUE
);