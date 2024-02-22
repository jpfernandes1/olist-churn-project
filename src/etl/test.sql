WITH RankedPayments AS (
  SELECT
    payment_installments,
    ROW_NUMBER() OVER (ORDER BY payment_installments) AS rowindex,
    COUNT(*) OVER () AS total_rows
  FROM
    olist_order_payments_dataset
)
SELECT
  payment_installments AS Mediana
FROM
  RankedPayments as t1
WHERE
  rowindex IN (((COUNT(*) OVER () AS total_rows) + 1) / 2, ROUND(((COUNT(*) OVER () AS total_rows) + 1) / 2.0))
ORDER BY
  rowindex;
