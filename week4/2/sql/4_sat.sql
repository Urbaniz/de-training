CREATE TABLE sat_customer (
    customer_hash_key BYTEA NOT NULL REFERENCES hub_customer(customer_hash_key),
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    hashdiff BYTEA NOT NULL,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(255),
    
    PRIMARY KEY (customer_hash_key, load_date)
);

CREATE TABLE sat_product (
    product_hash_key BYTEA NOT NULL REFERENCES hub_product(product_hash_key),
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    hashdiff BYTEA NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    
    PRIMARY KEY (product_hash_key, load_date)
);

CREATE TABLE sat_order_status (
    status_hash_key BYTEA NOT NULL REFERENCES hub_order_status(status_hash_key),
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    hashdiff BYTEA NOT NULL,
    description VARCHAR(255),
    
    PRIMARY KEY (status_hash_key, load_date)
);

CREATE TABLE sat_order (
    order_hash_key BYTEA NOT NULL REFERENCES hub_order(order_hash_key),
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    hashdiff BYTEA NOT NULL,
    order_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL,
    
    PRIMARY KEY (order_hash_key, load_date)
);

CREATE TABLE sat_lnk_line_order(
	link_hash_key BYTEA NOT NULL REFERENCES lnk_line_order(link_hash_key),
	load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	record_source VARCHAR(255) NOT NULL,
	from_date TIMESTAMP NOT NULL,
	to_date TIMESTAMP,
	PRIMARY KEY (link_hash_key, load_date)
);