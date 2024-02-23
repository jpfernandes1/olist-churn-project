with tb_join as (

select DISTINCT
    t1.order_id,
    t1.customer_id,
    t2.seller_id,
    t3.customer_state

from olist_orders_dataset as t1

LEFT join olist_order_items_dataset as t2
on t1.order_id = t2.order_id

left join olist_customers_dataset as t3
on t1.customer_id  = t3.customer_id

where order_purchase_timestamp < '2018-01-01'
and order_purchase_timestamp >= '2017-07-01'
and seller_id is not null

),

tb_group as (

    select
        seller_id,
        count(DISTINCT customer_state) as qtdUFsPedidos,
        count(distinct case when customer_state = 'AC' then order_id end) / count(DISTINCT order_id) as pctPedidoAC,
        count(distinct case when customer_state = 'AL' then order_id end) / count(DISTINCT order_id) as pctPedidoAL,
        count(distinct case when customer_state = 'AM' then order_id end) / count(DISTINCT order_id) as pctPedidoAM,
        count(distinct case when customer_state = 'AP' then order_id end) / count(DISTINCT order_id) as pctPedidoAP,
        count(distinct case when customer_state = 'BA' then order_id end) / count(DISTINCT order_id) as pctPedidoBA,
        count(distinct case when customer_state = 'CE' then order_id end) / count(DISTINCT order_id) as pctPedidoCE,
        count(distinct case when customer_state = 'DF' then order_id end) / count(DISTINCT order_id) as pctPedidoDF,
        count(distinct case when customer_state = 'ES' then order_id end) / count(DISTINCT order_id) as pctPedidoES,
        count(distinct case when customer_state = 'GO' then order_id end) / count(DISTINCT order_id) as pctPedidoGO,
        count(distinct case when customer_state = 'MA' then order_id end) / count(DISTINCT order_id) as pctPedidoMA,
        count(distinct case when customer_state = 'MG' then order_id end) / count(DISTINCT order_id) as pctPedidoMG,
        count(distinct case when customer_state = 'MS' then order_id end) / count(DISTINCT order_id) as pctPedidoMS,
        count(distinct case when customer_state = 'MT' then order_id end) / count(DISTINCT order_id) as pctPedidoMT,
        count(distinct case when customer_state = 'PA' then order_id end) / count(DISTINCT order_id) as pctPedidoPA,
        count(distinct case when customer_state = 'PB' then order_id end) / count(DISTINCT order_id) as pctPedidoPB,
        count(distinct case when customer_state = 'PE' then order_id end) / count(DISTINCT order_id) as pctPedidoPE,
        count(distinct case when customer_state = 'PI' then order_id end) / count(DISTINCT order_id) as pctPedidoPI,
        count(distinct case when customer_state = 'PR' then order_id end) / count(DISTINCT order_id) as pctPedidoPR,
        count(distinct case when customer_state = 'RJ' then order_id end) / count(DISTINCT order_id) as pctPedidoRJ,
        count(distinct case when customer_state = 'RN' then order_id end) / count(DISTINCT order_id) as pctPedidoRN,
        count(distinct case when customer_state = 'RO' then order_id end) / count(DISTINCT order_id) as pctPedidoRO,
        count(distinct case when customer_state = 'RR' then order_id end) / count(DISTINCT order_id) as pctPedidoRR,
        count(distinct case when customer_state = 'RS' then order_id end) / count(DISTINCT order_id) as pctPedidoRS,
        count(distinct case when customer_state = 'SC' then order_id end) / count(DISTINCT order_id) as pctPedidoSC,
        count(distinct case when customer_state = 'SE' then order_id end) / count(DISTINCT order_id) as pctPedidoSE,
        count(distinct case when customer_state = 'SP' then order_id end) / count(DISTINCT order_id) as pctPedidoSP,
        count(distinct case when customer_state = 'TO' then order_id end) / count(DISTINCT order_id) as pctPedidoTO


from tb_join
group by seller_id

)

select 
    '2018-01-01' as dtReference,
    *
from tb_group