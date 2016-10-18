EXPLAIN PLAN
   FOR
        SELECT channel_id
              ,AVG (sales_amount)
              ,SUM (sales_amount)
              ,STDDEV (sales_amount)
              ,COUNT (*)
          FROM t1
      GROUP BY channel_id;


SELECT * FROM TABLE (DBMS_XPLAN.display);