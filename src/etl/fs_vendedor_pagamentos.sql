/* 
 This query will show the orders over time just to evaluate if there is seasonalities.
Once we noticed it, we splited the DF selecting a period not affected by this. 
select 
    DATE(order_purchase_timestamp) as dtPedido,
    count(*) as qtPedido
FROM olist_orders_dataset

group by 1
order by 1; */
 
 -- The view bellow select only the orders we want to evaluate, excluding Null values

with tb_pedidos as (

    select DISTINCT
        t1.order_id,
        t2.seller_id

    from olist_orders_dataset as t1

    left join olist_order_items_dataset as t2
    on t1.order_id = t2.order_id

    where t1.order_purchase_timestamp < '{date}'
    and t1.order_purchase_timestamp >= date('{date}', '-6 months')
    and t2.seller_id is not null

),

tb_join as (

select 
        t1.seller_id,
        t2.*,
        ROW_NUMBER() OVER (ORDER BY payment_installments) AS rowindex

from tb_pedidos as t1

left join olist_order_payments_dataset as t2
on t1.order_id = t2.order_id

),

tb_group as (

select seller_id,
        payment_type,
        count(DISTINCT order_id) as qntPedidoMeioPagamento,
        sum(payment_value) as vlPedidoMeioPagamento

from tb_join

group by 1, 2
order by 1, 2

),

tb_summary as (

select seller_id,

sum(case when payment_type = 'credit_card' then qntPedidoMeioPagamento else 0 end) as qtdecredit_card_pedido,
sum(case when payment_type = 'boleto' then qntPedidoMeioPagamento else 0 end) as qtdeboleto_pedido,
sum(case when payment_type = 'debit_card' then qntPedidoMeioPagamento else 0 end) as qtdedebit_card_pedido,
sum(case when payment_type = 'voucher' then qntPedidoMeioPagamento else 0 end) as qtdevoucher_pedido,

sum(case when payment_type = 'credit_card' then vlPedidoMeioPagamento else 0 end) as valor_credit_card_pedido,
sum(case when payment_type = 'boleto' then vlPedidoMeioPagamento else 0 end) as valor_boleto_pedido,
sum(case when payment_type = 'debit_card' then vlPedidoMeioPagamento else 0 end) as valor_debit_card_pedido,
sum(case when payment_type = 'voucher' then vlPedidoMeioPagamento else 0 end) as valor_voucher_pedido,

sum(case when payment_type = 'credit_card' then qntPedidoMeioPagamento else 0 end) / sum(qntPedidoMeioPagamento) as pct_qtd_credit_card_pedido,
sum(case when payment_type = 'boleto' then qntPedidoMeioPagamento else 0 end) / sum(qntPedidoMeioPagamento) as pct_qtd_boleto_pedido,
sum(case when payment_type = 'debit_card' then qntPedidoMeioPagamento else 0 end) / sum(qntPedidoMeioPagamento) as pct_qtd_debit_card_pedido,
sum(case when payment_type = 'voucher' then qntPedidoMeioPagamento else 0 end) / sum(qntPedidoMeioPagamento) as pct_qtd_voucher_pedido,

sum(case when payment_type = 'credit_card' then vlPedidoMeioPagamento else 0 end) / sum(vlPedidoMeioPagamento) as pct_valor_credit_card_pedido,
sum(case when payment_type = 'boleto' then vlPedidoMeioPagamento else 0 end) / sum(vlPedidoMeioPagamento) as pct_valor_boleto_pedido,
sum(case when payment_type = 'debit_card' then vlPedidoMeioPagamento else 0 end) / sum(vlPedidoMeioPagamento) as pct_valor_debit_card_pedido,
sum(case when payment_type = 'voucher' then vlPedidoMeioPagamento else 0 end) / sum(vlPedidoMeioPagamento) as pct_valor_voucher_pedido

from tb_group

group by 1

),

tb_cartao as (

select 
        seller_id,
        avg(payment_installments) as avgQtdeParcelas,
        max(payment_installments) as maxQtdeParcelas,
        min(payment_installments) as minQtdeParcelas
from tb_join
where payment_type = 'credit_card'

group by seller_id

)

select 
    '{date}' as dtReference,
    date('now') as dtIngestion,
    t1.*,
    t2.avgQtdeParcelas,
    t2.maxQtdeParcelas,
    t2.minQtdeParcelas

from tb_summary as t1

left join tb_cartao as t2
on t1.seller_id = t2.seller_id 