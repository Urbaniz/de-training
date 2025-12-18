insert into customers (name, email, phone) values
('Александр',   'alex@gmail.com',   '654849');

update customers
set email = 'corpp@ya.ru'
where customer_id = 2;

update products
set product_name = 'спагетти'
where product_id = 3;

insert into products (product_name, category) values
('Макароны', 'крупа'),
('Овсянка',   'крупа');

update products
set category = 'Бакалея'
where category = 'крупа';

insert into sales (customer_id, product_id, sale_date, amount, quantity) values
(4, 4, '2025-12-15', 500.00, 6),
(4, 6, '2025-12-15', 79.90, 1);



update customers_dim cd
set to_date = CURRENT_TIMESTAMP, is_current = false
from customers c
where cd.customer_id = c.customer_id and cd.is_current = true
	and (cd.name is distinct from c.name or
        cd.email is distinct from c.email or
        cd.phone is distinct from c.phone);

insert into customers_dim (customer_id, name, email, phone, from_date)
select c.customer_id,
    c.name,
    c.email,
    c.phone,
    CURRENT_TIMESTAMP
from customers c left join customers_dim cd on cd.customer_id = c.customer_id and cd.is_current = true             
where cd.customer_id is null or (
	cd.name is distinct from c.name or 
	cd.email is distinct from c.email or 
	cd.phone is distinct from c.phone
    );


update products_dim pd
set to_date = CURRENT_TIMESTAMP, is_current = false
from products p
where pd.product_id = p.product_id and pd.is_current = true and (
	pd.product_name is distinct from p.product_name or
	pd.category is distinct from p.category
);

insert into products_dim (product_id, product_name, category, from_date)
select p.product_id,
    p.product_name,
    p.category,
    CURRENT_TIMESTAMP
from products p left join products_dim pd on pd.product_id = p.product_id and pd.is_current = true
where pd.product_id is null or (
        pd.product_name is distinct from p.product_name or 
        pd.category is distinct from p.category
);


insert into sales_fact(sale_id, customer_dim_id, product_dim_id, sale_date, amount, quantity)
select s.sale_id,
    cd.customer_dim_id,
    pd.product_dim_id,
    s.sale_date,
    s.amount,
    s.quantity
from sales s join customers_dim cd on cd.customer_id = s.customer_id and cd.is_current = true
			join products_dim pd on pd.product_id = s.product_id and pd.is_current = true
			left join sales_fact sf on sf.sale_id = s.sale_id
where sf.sale_id is null;
