insert into sat_customer
select customer_id::text::bytea,
	now(),
	'oltp',
	concat_ws('||', name, coalesce(email,''), coalesce(phone,''))::bytea,
	name, 
	email, 
	phone
from customers
where not exists (select 1 from sat_customer
					where customer_hash_key = customer_id::text::bytea
					and hashdiff = concat_ws('||', name, coalesce(email,''), coalesce(phone,''))::bytea);

insert into sat_product
select product_id::text::bytea,
	now(),
	'oltp',
	concat_ws('||', product_name, coalesce(category,''), price::text)::bytea,
	product_name, 
	category,
	price
from products
where not exists (select 1 from sat_product
					where product_hash_key = product_id::text::bytea
					and hashdiff = concat_ws('||', product_name, coalesce(category,''), price::text)::bytea);

insert into sat_order_status
select status_name::bytea,
	now(),
	'oltp',
  	coalesce(description,'')::bytea,
	description
from order_statuses
where not exists (select 1 from sat_order_status
					where status_hash_key = status_name::bytea
					and hashdiff = coalesce(description,'')::bytea);

insert into sat_order
select order_id::text::bytea,
	now(),
	'oltp',
	concat_ws('||', order_date::text, total_amount::text, quantity::text)::bytea,
	order_date,
	total_amount,
	quantity
from orders
where not exists (select 1 from sat_order
					where order_hash_key = order_id::text::bytea
					and hashdiff = concat_ws('||', order_date::text, total_amount::text, quantity::text)::bytea);