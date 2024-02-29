with tb_join as (

select *

from olist_orders_dataset as t1

left join olist_order_items_dataset as t2
on t1.order_id = t2.order_id

where t1.order_purchase_timestamp < '2018-01-01'
and t1.order_purchase_timestamp > '2017-07-01'
and seller_id is not NULL

),

tb_summary as (

SELECT 
    seller_id,
    COUNT(DISTINCT order_id) AS qntPedidos,
    COUNT(DISTINCT DATE(order_purchase_timestamp)) AS qtdDias,
    COUNT(order_item_id) AS qntItens,
    MAX(JULIANDAY('2018-01-01') - JULIANDAY(order_purchase_timestamp)) AS qtdRecencia,
    SUM(COALESCE(price, 0)) / COUNT(DISTINCT order_id) AS ticketMedio,
    AVG(COALESCE(price, 0)) AS avgValorProduto,
    MAX(COALESCE(price, 0)) AS maxValorProduto,
    MIN(COALESCE(price, 0)) AS minValorProduto,
    count(order_item_id) / count(DISTINCT order_id) as avgProdutoPedido

FROM
    tb_join
GROUP BY
    1

),

tb_pedido_summary as (

select 
        seller_id,
        order_id,
        sum(price) as vlPreco

from tb_join

group by 1, 2

),

tb_min_max as (

select 
        seller_id,
        min(vlPreco) as minVlPedido,
        max(vlPreco) as maxVlPedido

from tb_pedido_summary

group by seller_id

),

tb_life as (

select 
        t2.seller_id,
        sum(price) as LTV,
         MAX(JULIANDAY('2018-01-01') 
         - JULIANDAY(order_purchase_timestamp)) AS qtdeDiasBase

from olist_orders_dataset as t1

left join olist_order_items_dataset as t2
on t1.order_id = t2.order_id

where t1.order_purchase_timestamp < '2018-01-01'
and seller_id is not NULL

group by t2.seller_id 

),

tb_dtpedido as (

select distinct 
            seller_id,
            date(order_purchase_timestamp) as dtPedido

from tb_join

order by 1, 2

),

tb_lag as (

select *,
        lag(dtPedido) over (partition by seller_id order by dtPedido) as lag1
from tb_dtpedido

),

tb_intervalo as (

select 
    seller_id,
    avg(julianday(dtPedido) - julianday(lag1)) as avgIntervaloVendas

from tb_lag

group by seller_id

)

select 
       '2018-01-01' as dtReference,
       t1.*,
       t2.minVlPedido,
       t2.maxVlPedido,
       t3.LTV,
       t3.qtdeDiasBase,
       t4.avgIntervaloVendas

from tb_summary as t1

left join tb_min_max as t2
on t1.seller_id = t2.seller_id

left join tb_life as t3
on t1.seller_id = t3.seller_id

left join tb_intervalo as t4
on t1.seller_id = t4.seller_id