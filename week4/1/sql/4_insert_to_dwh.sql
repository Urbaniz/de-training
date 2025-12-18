insert into customers_dim(customer_id, name, email, phone, from_date)
select c.customer_id,
    c.name,
    c.email,
    c.phone,
    '2025-12-10'
FROM customers c;

insert into products_dim(product_id, product_name, category, from_date)
select p.product_id, 
    p.product_name,
    p.category,
    '2025-12-10'
from products p;

insert into sales_fact (sale_id, customer_dim_id, product_dim_id, sale_date, amount, quantity)
select s.sale_id,
    cd.customer_dim_id,
    pd.product_dim_id,
    s.sale_date,
    s.amount,
    s.quantity
from sales s join customers_dim cd on cd.customer_id = s.customer_id and cd.is_current = true
			join products_dim pd on pd.product_id = s.product_id and pd.is_current = true;