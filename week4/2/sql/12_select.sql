
select hc.customer_number,
	sum(so.total_amount) AS total_amount
from hub_customer hc
	join lnk_line_order l on l.customer_hash_key = hc.customer_hash_key
	join hub_order_status hs on hs.status_hash_key = l.status_hash_key
	join sat_order so on so.order_hash_key = l.order_hash_key
	where hs.status_name = 'CLOSED'
group by hc.customer_number;


select sp.category, 
	sum(so.total_amount) AS revenue
from lnk_line_order l
	join sat_order so on so.order_hash_key = l.order_hash_key
	join sat_product sp on sp.product_hash_key = l.product_hash_key
where so.order_date >= '2024-01-01' and so.order_date <  '2025-01-01'
group by sp.category
order by revenue desc;


select ho.order_number,
	sc.name,
	sp.product_name,
	hs.status_name,
	so.order_date,
	so.total_amount,
	so.quantity
from lnk_line_order l
	join hub_order ho on ho.order_hash_key = l.order_hash_key
	join hub_order_status hs on hs.status_hash_key = l.status_hash_key
	join sat_customer sc on sc.customer_hash_key = l.customer_hash_key
	join sat_product sp on sp.product_hash_key = l.product_hash_key
	join sat_order so on so.order_hash_key = l.order_hash_key
order by so.order_date;