SELECT tableoid::regclass AS partition_name, *
FROM orders
ORDER BY order_date;

INSERT INTO orders (customer_id, product_id, status_name, order_date, total_amount, quantity)
VALUES
  (1, 2, 'CLOSED',  '2025-12-10', 75.6, 1),
  (2, 3, 'NEW',  '2025-08-10', 165.6, 1);

SELECT *
FROM orders
WHERE order_date >= '2025-01-01' and customer_id = 1;


SELECT *
FROM orders
WHERE order_date <= '2023-01-01';

