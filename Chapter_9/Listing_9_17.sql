SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement_part
       WHERE     transaction_date = DATE '2013-01-01'
             AND posting_date = DATE '2013-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement_part
       WHERE     transaction_date = DATE '2013-01-06'
             AND posting_date = DATE '2013-01-06';

SELECT * FROM TABLE (DBMS_XPLAN.display);