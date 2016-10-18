SET LINES 2000 PAGES 0
BEGIN
   DBMS_STATS.gather_table_stats (SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
                                 ,'T3'
                                 ,no_invalidate   => FALSE);
END;
/

BEGIN
   FOR r IN (SELECT *
               FROM t3
              WHERE t3.c2 = TO_DATE ( :b1, 'DD-MON-YYYY'))
   LOOP
      NULL;
   END LOOP;
END;
/

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (sql_id => 'dgcvn46zatdqr'));