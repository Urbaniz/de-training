CREATE TABLE customers(
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(150) unique NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(255)
);

CREATE TABLE products(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) UNIQUE NOT NULL,
    category VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE order_statuses(
    status_name VARCHAR(50) NOT NULL PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE orders(
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    status_name VARCHAR(50) NOT NULL REFERENCES order_statuses(status_name),
    order_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    quantity INTEGER NOT NULL
);

