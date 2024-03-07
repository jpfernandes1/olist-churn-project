with tb_activate as (

select DISTINCT seller_id,
                min(date(order_purchase_timestamp))

from olist_orders_dataset as t1

left join olist_order_items_dataset as t2
on t1.order_id = t2.order_id

where t1.order_purchase_timestamp >= '2018-01-01'
and t1.order_purchase_timestamp <= date('2018-01-01', '+45 days')
and seller_id is not null

group by 1

)

select * from tb_activate