/* 
''' This query will show the orders over time '''
select 
    DATE(order_purchase_timestamp) as dtPedido,
    count(*) as qtPedido
FROM olist_orders_dataset

group by 1
order by 1 */

with tb_join as

(select t2.*,
        t3.seller_id

from olist_orders_dataset as t1

left join olist_order_payments_dataset as t2
on t1.order_id = t2.order_id

left join olist_order_items_dataset as t3
on t1.order_id = t3.order_id

where t1.order_purchase_timestamp < '2018-01-01'
and t1.order_purchase_timestamp > '2017-07-01'
and t3.seller_id is not null

),

tb_group as (

select seller_id,
        payment_type,
        count(DISTINCT order_id) as qntPedidoMeioPagamento,
        sum(payment_value) as payment_type_value

from tb_join

group by 1, 2
order by 1, 2

)

select DISTINCT payment_type from tb_group
