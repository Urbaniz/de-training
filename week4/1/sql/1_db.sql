CREATE TABLE customers(
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(150) unique NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(255)
);

CREATE TABLE products(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) UNIQUE NOT NULL,
    category VARCHAR(100)
);


CREATE TABLE sales(
    sale_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    sale_date TIMESTAMP NOT NULL,
    amount DECIMAL(10, 2)NOT NULL,
    quantity INTEGER NOT NULL
);
