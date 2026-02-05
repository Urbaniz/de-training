{% snapshot customers_snapshot %}

{{
  config(
    target_schema='analytics',
    unique_key='customer_id',
    strategy='timestamp',
    updated_at='updated_at'
  )
}}

select
  customer_id,
  name,
  email,
  phone,
  updated_at
from {{ source('oltp', 'customers') }}

{% endsnapshot %}