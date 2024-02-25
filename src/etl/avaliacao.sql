with tb_join as (

select DISTINCT
        t3.seller_id,
        t1.*,
        t2.*

from olist_orders_dataset as t1

LEFT join olist_order_reviews_dataset as t2
on t1.order_id = t2.order_id

left join olist_order_items_dataset as t3
on t1.order_id = t3.order_id

where t1.order_purchase_timestamp < '2018-01-01'
and t1.order_purchase_timestamp >= '2017-01-01'
and t3.seller_id is not null

),

tb_summary as(

SELECT
    seller_id,
    avg(review_score) as avgReview,
    count (DISTINCT review_score) as ContReview,
    min(review_score) as minReview,
    max(review_score) as maxReview,
    count(review_score) / count(order_id) as pctReview


from tb_join

group by 1
order by 3 desc

)

select '2018-01-01' as dtReference,
        *
from tb_summary;
