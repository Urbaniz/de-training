select
  s.sale_id,
  s.sale_date,
  s.amount,
  s.quantity,
  c.customer_id,
  c.from_date as customer_from_date,
  p.product_id,
  p.from_date as product_from_date
from {{ source('oltp','sales') }} s
    join {{ ref('customers_dim') }} c on c.customer_id = s.customer_id
                                    and s.sale_date >= c.from_date
                                    and (c.to_date is null or s.sale_date < c.to_date)
join {{ ref('products_dim') }} p on p.product_id = s.product_id
                                    and s.sale_date >= p.from_date
                                    and (p.to_date is null or s.sale_date < p.to_date)