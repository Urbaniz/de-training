insert into lnk_line_order
select concat_ws('||', order_id::text, customer_id::text, product_id::text, status_name)::bytea,
	order_id::text::bytea,
	customer_id::text::bytea,
	product_id::text::bytea,
	status_name::bytea,
	now(),
	'oltp'
from orders on conflict (order_hash_key, customer_hash_key, product_hash_key, status_hash_key) do nothing;