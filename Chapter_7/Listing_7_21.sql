EXPLAIN PLAN
   FOR
        SELECT GREATEST (
                  ratio_to_report (FLOOR (SUM (LEAST (sales_amount, 100))))
                     OVER ()
                 ,0)
                  n1
          FROM t1
      GROUP BY cust_id;


SELECT * FROM TABLE (DBMS_XPLAN.display);