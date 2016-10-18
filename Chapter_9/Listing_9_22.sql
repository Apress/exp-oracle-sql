SET SERVEROUT ON

DECLARE
   original_stats_time   DATE;
   num_rows              all_tab_statistics.num_rows%TYPE;
   sowner                all_tab_statistics.owner%TYPE;
BEGIN
   SELECT owner, last_analyzed
     INTO sowner, original_stats_time
     FROM all_tab_statistics
    WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
          AND table_name = 'STATEMENT_PART'
          AND partition_name IS NULL;

   DELETE FROM statement_part;

   DBMS_STATS.gather_table_stats (ownname       => sowner
                                 ,tabname       => 'STATEMENT_PART'
                                 ,partname      => NULL
                                 ,GRANULARITY   => 'GLOBAL'
                                 ,method_opt    => 'FOR ALL COLUMNS SIZE 1'
                                 ,cascade       => FALSE);

   SELECT num_rows
     INTO num_rows
     FROM all_tab_statistics
    WHERE     owner = sowner
          AND table_name = 'STATEMENT_PART'
          AND partition_name IS NULL;

   DBMS_OUTPUT.put_line (
      'After deletion and gathering num_rows is: ' || num_rows);

   DBMS_STATS.restore_table_stats (
      ownname           => sowner
     ,tabname           => 'STATEMENT_PART'
     ,as_of_timestamp   => original_stats_time + 1 / 86400
     ,no_invalidate     => FALSE);

   SELECT num_rows
     INTO num_rows
     FROM all_tab_statistics
    WHERE     owner = sowner
          AND table_name = 'STATEMENT_PART'
          AND partition_name IS NULL;

   DBMS_OUTPUT.put_line (
      'After restoring earlier statistics num_rows is: ' || num_rows);


   INSERT INTO statement_part
      SELECT * FROM statement;

   COMMIT;
END;
/
