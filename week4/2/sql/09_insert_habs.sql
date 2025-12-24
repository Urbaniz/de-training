insert into hub_customer
select customer_id::text::bytea,
	now(),
	'oltp',
	customer_id::text
from customers on conflict (customer_number) do nothing;

insert into hub_product
select product_id::text::bytea,
	now(),
	'oltp',
	product_id::text
from products on conflict (product_number) do nothing;

insert into hub_order_status
select status_name::text::bytea,
	now(),
	'oltp',
	status_name
from order_statuses on conflict (status_name) do nothing;

insert into hub_order
select order_id::text::bytea,
	now(),
	'oltp',
	order_id::text
from orders on conflict (order_number) do nothing;