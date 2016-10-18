EXPLAIN PLAN
   FOR
        SELECT ROW_NUMBER () OVER (ORDER BY sales_amount) rn
              ,RANK () OVER (ORDER BY sales_amount) rank_sales
              ,t1.*
          FROM t1
      ORDER BY sales_amount;


SELECT * FROM TABLE (DBMS_XPLAN.display);