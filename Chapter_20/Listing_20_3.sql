SET PAGES 0 LINES 200

EXEC tstats.adjust_column_stats_v2(p_table_name=>'PAYMENTS');

EXPLAIN PLAN
   FOR
      SELECT *
        FROM payments
       WHERE special_flag = 'Y';

SELECT * FROM TABLE (DBMS_XPLAN.display);