BEGIN
   DBMS_STATS.delete_table_stats (
      ownname           => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname           => 'STATEMENT_PART'
     ,cascade_parts     => TRUE
     ,cascade_indexes   => TRUE
     ,cascade_columns   => TRUE);

   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,granularity   => 'GLOBAL'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1');

   tstats.adjust_column_stats_v2 (
      p_owner        => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,p_table_name   => 'STATEMENT_PART');
END;
/

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM statement_part t
       WHERE transaction_date = DATE '2013-01-06';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ full(t) */
             COUNT (*)
        FROM statement_part t
       WHERE transaction_date = DATE '2013-01-06';

SELECT * FROM TABLE (DBMS_XPLAN.display);