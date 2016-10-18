DELETE FROM statement_part
      WHERE transaction_date NOT IN (DATE '2013-01-01', DATE '2013-01-06');

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
     ,partname      => 'P1'
     ,granularity   => 'PARTITION'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1');

   DBMS_STATS.copy_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,srcpartname   => 'P1'
     ,dstpartname   => 'P2');

   DBMS_STATS.copy_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,srcpartname   => 'P1'
     ,dstpartname   => 'P3');
END;
/

CREATE OR REPLACE FUNCTION convert_date_stat (raw_value RAW)
   RETURN DATE
IS
   date_value   DATE;
BEGIN
   DBMS_STATS.convert_raw_value (rawval => raw_value, resval => date_value);
   RETURN date_value;
END convert_date_stat;
/

SET PAGES 900
COLUMN COLUMN_NAME FORMAT a20

  SELECT column_name
        ,partition_name
        ,convert_date_stat (low_value) low_value
        ,convert_date_stat (high_value) high_value
        ,num_distinct
    FROM all_part_col_statistics
   WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
         AND table_name = 'STATEMENT_PART'
         AND column_name IN ('TRANSACTION_DATE', 'POSTING_DATE')
ORDER BY column_name DESC, partition_name;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM statement_part
       WHERE transaction_date = DATE '2013-01-06';

SELECT * FROM TABLE (DBMS_XPLAN.display);