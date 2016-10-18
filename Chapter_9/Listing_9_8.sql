DECLARE
   srec   DBMS_STATS.statrec;
BEGIN
   FOR r
      IN (SELECT *
            FROM all_tab_cols
           WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
                 AND table_name = 'STATEMENT'
                 AND column_name = 'TRANSACTION_AMOUNT')
   LOOP
      srec.epc := 3;
      srec.bkvals := DBMS_STATS.numarray (600, 400, 600);
      DBMS_STATS.prepare_column_values (srec
                                       ,DBMS_STATS.numarray (-1e7, 8, 1e7));
      DBMS_STATS.set_column_stats (ownname   => r.owner
                                  ,tabname   => r.table_name
                                  ,colname   => r.column_name
                                  ,distcnt   => 3
                                  ,density   => 1 / 250
                                  ,nullcnt   => 0
                                  ,srec      => srec
                                  ,avgclen   => r.avg_col_len);
   END LOOP;
END;
/

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE transaction_amount = 8;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE transaction_amount = 1640;

SELECT * FROM TABLE (DBMS_XPLAN.display);