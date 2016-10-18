SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement_part
       WHERE     transaction_date IN (DATE '2013-01-04', DATE '2013-01-05')
             AND posting_date = DATE '2013-01-05';


SELECT * FROM TABLE (DBMS_XPLAN.display);