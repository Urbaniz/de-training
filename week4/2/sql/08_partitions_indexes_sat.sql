ALTER TABLE sat_order RENAME TO sat_order_old;

CREATE TABLE sat_order (
	order_hash_key BYTEA NOT NULL REFERENCES hub_order(order_hash_key),
    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_source VARCHAR(255) NOT NULL,
    hashdiff BYTEA NOT NULL,
    order_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY (order_hash_key, order_date, load_date)
)PARTITION BY RANGE (order_date);

CREATE TABLE sat_order_y2023
PARTITION OF sat_order
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE sat_order_y2024
PARTITION OF sat_order
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE sat_order_y2025
PARTITION OF sat_order
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE sat_order_default
PARTITION OF sat_order DEFAULT;

CREATE INDEX idx_sat_order_order_date ON sat_order (order_date);

CREATE INDEX idx_sat_order_order_hk   ON sat_order (order_hash_key);

CREATE INDEX idx_sat_order_load_date  ON sat_order (load_date);