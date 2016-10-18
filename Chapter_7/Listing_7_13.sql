EXPLAIN PLAN
   FOR
        SELECT t1.*
              ,LAG (
                  sales_amount)
               OVER (PARTITION BY channel_id, cust_id
                     ORDER BY transaction_date)
                  prev_sales_amount
          FROM t1
      ORDER BY channel_id, sales_amount;


SELECT * FROM TABLE (DBMS_XPLAN.display);

  SELECT t1.*
        ,LAG (sales_amount)
            OVER (PARTITION BY channel_id, cust_id ORDER BY transaction_date)
            prev_sales_amount
    FROM t1
ORDER BY channel_id, sales_amount;