{% snapshot products_snapshot %}

{{
  config(
    target_schema='analytics',
    unique_key='product_id',
    strategy='timestamp',
    updated_at='updated_at'
  )
}}

select
  product_id,
  product_name,
  category,
  updated_at
from {{ source('oltp', 'products') }}

{% endsnapshot %}