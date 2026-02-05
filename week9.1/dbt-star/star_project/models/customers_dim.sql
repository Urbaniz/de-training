select
  customer_id,
  dbt_valid_from as from_date,
  name,
  email,
  phone,
  dbt_valid_to as to_date,
  (dbt_valid_to is null) as is_current
from {{ ref('customers_snapshot') }}