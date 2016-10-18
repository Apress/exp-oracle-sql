BEGIN
   DBMS_STATS.delete_table_stats (
      ownname    => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname    => 'STATEMENT_PART'
     ,partname   => 'P1');
END;
/

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement_part
       WHERE     transaction_date = DATE '2013-01-01'
             AND posting_date = DATE '2013-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);