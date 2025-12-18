CREATE TABLE customers_dim( 
	customer_dim_id SERIAL PRIMARY KEY, 
	customer_id INTEGER NOT NULL, 
	name VARCHAR(150) NOT NULL, 
	email VARCHAR(255), 
	phone VARCHAR(255), 
	from_date TIMESTAMP NOT NULL, 
	to_date TIMESTAMP, 
	is_current BOOLEAN DEFAULT TRUE 
); 

CREATE TABLE products_dim(
	product_dim_id SERIAL PRIMARY KEY, 
	product_id INTEGER NOT NULL, 
	product_name VARCHAR(255) NOT NULL, 
	category VARCHAR(100), 
	from_date TIMESTAMP NOT NULL, 
	to_date TIMESTAMP, 
	is_current BOOLEAN DEFAULT TRUE 
); 

CREATE TABLE sales_fact( 
	sale_fact_id SERIAL PRIMARY KEY, 
	sale_id INTEGER NOT NULL, 
	customer_dim_id INTEGER NOT NULL REFERENCES customers_dim(customer_dim_id), 
	product_dim_id INTEGER NOT NULL REFERENCES products_dim(product_dim_id), 
	sale_date TIMESTAMP, 
	amount DECIMAL(10, 2), 
	quantity INTEGER 
);