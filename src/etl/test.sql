 select 
        t3.product_category_name
      
from olist_orders_dataset as t1

left join olist_order_items_dataset as t2
on t1.order_id = t2.order_id

left join olist_products_dataset as t3
on t2.product_id = t3.product_id

where t1.order_purchase_timestamp < '2018-01-01'
and t1.order_purchase_timestamp > '2017-07-01'
and t2.seller_id is not NULL

group by 1
order by count(DISTINCT t2.order_id) desc
limit 15;
