SELECT t1.*
      ,AVG (
          sales_amount)
       OVER (PARTITION BY cust_id
             ORDER BY transaction_date
             RANGE INTERVAL '10' DAY PRECEDING)
          mov_avg
  FROM t1;