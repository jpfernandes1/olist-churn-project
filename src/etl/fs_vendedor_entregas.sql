with tb_pedido as (

select 
        t1.order_id,
        t2.seller_id,
        t1.order_status,
        t1.order_purchase_timestamp,
        t1.order_approved_at,
        t1.order_delivered_customer_date,
        t1.order_estimated_delivery_date,
        sum(t2.freight_value) as totalFrete
-- o sum fará como que o valor do frete fique a nível de pedido, não de item;
from olist_orders_dataset as t1

left join olist_order_items_dataset as t2
on t1.order_id = t2.order_id

where t1.order_purchase_timestamp < '{date}'
and t1.order_purchase_timestamp >= DATE('{date}', '-6 months')
and t2.seller_id is not NULL

group by t1.order_id,
        t2.seller_id,
        t1.order_status,
        t1.order_purchase_timestamp,
        t1.order_approved_at,
        t1.order_delivered_customer_date,
        t1.order_estimated_delivery_date
)

select 
        '{date}' as dtReference,
        DATE('now') as dtIngestion,
        seller_id,
       count(DISTINCT case when date(coalesce(order_delivered_customer_date, '{date}')) 
       > date(order_estimated_delivery_date) then order_id END) 
       / count(DISTINCT case WHEN order_status = 'delivered' then order_id end) as pctPedidoAtraso,
       count(DISTINCT case when order_status = 'canceled' then order_id end) 
       / count(DISTINCT order_id) as pctPedidoCancelado,
       avg(totalFrete) as avgFrete,
       max(totalFrete) as maxFrete,
       min(totalFrete) as minFrete,
       AVG(JULIANDAY(COALESCE(order_delivered_customer_date, '{date}')) - JULIANDAY(order_approved_at)) AS qtdDiasAprovadoxEntrega,
       avg(julianday(coalesce(order_delivered_customer_date, '{date}')) - julianday(order_purchase_timestamp)) AS qtdDiasPedidoEntrega,
       AVG(JULIANDAY(order_estimated_delivery_date) - JULIANDAY(COALESCE(order_delivered_customer_date, '{date}'))) AS qtdDiasEntregaxPromessa
from tb_pedido

group by 1,2,3