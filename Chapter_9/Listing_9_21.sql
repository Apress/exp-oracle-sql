BEGIN
   DBMS_STATS.delete_table_stats (
      ownname         => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname         => 'STATEMENT_PART'
     ,partname        => NULL
     ,cascade_parts   => TRUE);

   DBMS_STATS.set_table_prefs (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT_PART'
     ,pname     => 'INCREMENTAL'
     ,pvalue    => 'FALSE');
END;
/

DECLARE
   extension_name   all_tab_cols.column_name%TYPE;
BEGIN
   extension_name :=
      DBMS_STATS.create_extended_stats (
         ownname     => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
        ,tabname     => 'STATEMENT_PART'
        ,extension   => '(TRANSACTION_DATE,POSTING_DATE)');

   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,partname      => NULL
     ,granularity   => 'GLOBAL'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1'
     ,cascade       => FALSE);
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