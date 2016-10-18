EXPLAIN PLAN
   FOR
      SELECT t1.*
            ,SUM (sales_amount)
                OVER (PARTITION BY cust_id ORDER BY transaction_date)
                moving_balance
        FROM t1;


SELECT * FROM TABLE (DBMS_XPLAN.display);

SELECT t1.*
      ,SUM (sales_amount)
          OVER (PARTITION BY cust_id ORDER BY transaction_date)
          moving_balance
  FROM t1;