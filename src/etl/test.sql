-- Calcular para cada vendedor a quantidade de tipo de pagamento

select *
from olist_sellers_dataset

group by seller_id, 