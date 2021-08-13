create local temp table ecom_sandbox.sduranber_base_ on commit preserve rows as

  select
    g.ga_sessions_date::date            as date,
    g.full_visitor_id                   as visitor_id,
    g.unique_visit_id                   as visit_id,
    g.visit_number                      as visit_number,
    g.product_merch_classification2     as mc2,
    g.product_category_level1           as category,
    g.product_part_number               as item,
    g.product_brand                     as brand,
    case g.event_label
      when 'In Stock' then true
      when 'Out of Stock' then false
      else true end                     as is_instock,
    rank() over (
      partition by (g.unique_visit_id,
                    g.product_merch_classification2,
                    g.product_category_level1)
      order by g.hit_timestamp asc
      )                                 as rank
  from ga.ga_sessions_hits_products as g
  where g.event_action = 'detail'
    and g.ga_sessions_date between '{start_date}' and '{end_date}'
  order by visit_id desc
;

with base as (

  select b.*
  from ecom_sandbox.sduranber_base_ as b
  where b.mc2 = '{class}'

), sales as (

  -- sales data at (visit, mc2, category) level
  select distinct
    s.visit_id,
    s.mc2,
    s.category,
    sum(s.quantity)     as quantity,
    sum(s.total_price)  as cart_size
  from (
    select distinct
      g.unique_visit_id                   as visit_id,
      g.product_merch_classification2     as mc2,
      g.product_category_level1           as category,
      g.product_part_number               as item,
      g.product_brand                     as brand,
      g.product_quantity                  as quantity,
      g.product_price*g.product_quantity  as total_price
    from ga.ga_sessions_hits_products as g
    where g.event_action = 'purchase'
      and g.unique_visit_id in (select distinct visit_id from base)
      and g.product_quantity > 0
    ) as s
  where s.mc2 = '{class}'
  group by 1,2,3

)

select
  b.date,
  b.item,
  b.brand,
  sum(case when b.is_instock then 1 else 0 end) as instock_views,
  sum(case when b.is_instock then 0 else 1 end) as oos_views,
  sum(case when b.is_instock and s.quantity > 0 then 1 else 0 end) as instock_conversions,
  sum(case when (not b.is_instock) and s.quantity > 0 then 1 else 0 end) as oos_conversions,
  sum(case when b.is_instock then s.quantity else 0 end) as instock_quantity,
  sum(case when b.is_instock then 0 else s.quantity end) as oos_quantity,
  sum(case when b.is_instock then s.cart_size else 0 end) as instock_price,
  sum(case when b.is_instock then 0 else s.cart_size end) as oos_price
from base as b
left join sales as s
  using (visit_id, mc2, category)
group by 1, 2, 3

;
