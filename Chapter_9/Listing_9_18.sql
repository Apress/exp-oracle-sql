SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement_part
       WHERE     transaction_date = (SELECT DATE '2013-01-01' FROM DUAL)
             AND posting_date = DATE '2013-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);