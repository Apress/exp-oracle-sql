SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT transaction_date_time
        FROM statement t
       WHERE transaction_date_time =
                TIMESTAMP '2013-01-02 12:00:00.00 -05:00';

SELECT * FROM TABLE (DBMS_XPLAN.display);