EXPLAIN PLAN
   FOR
      SELECT t1.*
            ,AVG (
                sales_amount)
             OVER (PARTITION BY cust_id
                   ORDER BY transaction_date
                   ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
                mov_avg
        FROM t1;


SELECT * FROM TABLE (DBMS_XPLAN.display);

SELECT t1.*
      ,AVG (
          sales_amount)
       OVER (PARTITION BY cust_id
             ORDER BY transaction_date
             ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
          mov_avg
  FROM t1;