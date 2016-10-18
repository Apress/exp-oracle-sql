SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE transaction_amount = 8;

SELECT * FROM TABLE (DBMS_XPLAN.display);