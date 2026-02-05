select
  product_id,
  dbt_valid_from as from_date,
  product_name,
  category,
  dbt_valid_to as to_date,
  (dbt_valid_to is null) as is_current
from {{ ref('products_snapshot') }}