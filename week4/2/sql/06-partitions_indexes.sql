ALTER TABLE orders RENAME TO orders_old;

CREATE TABLE orders(
    order_id SERIAL NOT NULL,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    status_name VARCHAR(50) NOT NULL REFERENCES order_statuses(status_name),
    order_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY(order_id, order_date)
) PARTITION BY RANGE (order_date);

CREATE TABLE orders_y2023
PARTITION OF orders
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE orders_y2024
PARTITION OF orders
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE orders_y2025
PARTITION OF orders
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

CREATE TABLE orders_default
PARTITION OF orders DEFAULT;

CREATE INDEX idx_orders_order_date ON orders(order_date);

CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

CREATE INDEX idx_orders_product ON orders(product_id);

INSERT INTO orders (order_id, customer_id, product_id, status_name, order_date, total_amount, quantity)
SELECT order_id, customer_id, product_id, status_name, order_date, total_amount, quantity
FROM orders_old;

SELECT setval(
  pg_get_serial_sequence('orders', 'order_id'),
  COALESCE((SELECT max(order_id) FROM orders), 0)
);