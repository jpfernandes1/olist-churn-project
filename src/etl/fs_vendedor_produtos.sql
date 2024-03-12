-- Categorias vendidas
with tb_join as (

select DISTINCT
        t2.seller_id,
        t3.*

from olist_orders_dataset as t1

left join olist_order_items_dataset as t2
on t1.order_id = t2.order_id

left join olist_products_dataset as t3
on t2.product_id = t3.product_id

where t1.order_purchase_timestamp < '{date}'
and t1.order_purchase_timestamp >= date('{date}', '-6 months')
and seller_id is not NULL

),

tb_summary as (

select
     seller_id,
     avg(coalesce(t1.product_photos_qty, 0)) as avgFotos,
     avg(t1.product_length_cm * t1.product_width_cm * t1.product_height_cm) as avgProduct_vol,
     min(t1.product_length_cm * t1.product_width_cm * t1.product_height_cm) as minVolProduct,
     max(t1.product_length_cm * t1.product_width_cm * t1.product_height_cm) as maxVolProduct,
     count(distinct case when product_category_name = 'cama_mesa_banho' then product_category_name end)/count(DISTINCT product_id) as pctCategoriacama_mesa_banho,
     count(distinct case when product_category_name = 'esporte_lazer' then product_category_name end)/count(DISTINCT product_id) as pctCategoriaesporte_lazer,
     count(distinct case when product_category_name = 'beleza_saude' then product_category_name end)/count(DISTINCT product_id) as pctCategoriabeleza_saude,
     count(distinct case when product_category_name = 'moveis_decoracao' then product_category_name end)/count(DISTINCT product_id) as pctCategoriamoveis_decoracao,
     count(distinct case when product_category_name = 'brinquedos' then product_category_name end)/count(DISTINCT product_id) as pctCategoriabrinquedos,
     count(distinct case when product_category_name = 'informatica_acessorios' then product_category_name end)/count(DISTINCT product_id) as pctCategoriainformatica_acessorios,
     count(distinct case when product_category_name = 'relogios_presentes' then product_category_name end)/count(DISTINCT product_id) as pctCategoriarelogios_presentes,
     count(distinct case when product_category_name = 'utilidades_domesticas' then product_category_name end)/count(DISTINCT product_id) as pctCategoriautilidades_domesticas,
     count(distinct case when product_category_name = 'cool_stuff' then product_category_name end)/count(DISTINCT product_id) as pctCategoriacool_stuff,
     count(distinct case when product_category_name = 'ferramentas_jardim' then product_category_name end)/count(DISTINCT product_id) as pctCategoriaferramentas_jardim,
     count(distinct case when product_category_name = 'telefonia' then product_category_name end)/count(DISTINCT product_id) as pctCategoriatelefonia,
     count(distinct case when product_category_name = 'perfumaria' then product_category_name end)/count(DISTINCT product_id) as pctCategoriaperfumaria,
     count(distinct case when product_category_name = 'automotivo' then product_category_name end)/count(DISTINCT product_id) as pctCategoriaautomotivo,
     count(distinct case when product_category_name = 'bebes' then product_category_name end)/count(DISTINCT product_id) as pctCategoriabebes,
     count(distinct case when product_category_name = 'papelaria' then product_category_name end)/count(DISTINCT product_id) as pctCategoriapapelaria


from tb_join as t1

group by 1

)

select '{date}' as dtReference,
        date('now') as dtIngestion,
        *
from tb_summary

/* 

'''The following query was used to get the 15 categories that sold the most''' 

 select 
        t3.product_category_name
      
from olist_orders_dataset as t1

left join olist_order_items_dataset as t2
on t1.order_id = t2.order_id

left join olist_products_dataset as t3
on t2.product_id = t3.product_id

where t1.order_purchase_timestamp < '{date}'
and t1.order_purchase_timestamp > '2017-07-01'
and t2.seller_id is not NULL

group by 1
order by count(DISTINCT t2.order_id) desc
limit 15;
*/ 

