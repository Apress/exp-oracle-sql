BEGIN
   DBMS_STATS.set_table_prefs (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT_PART'
     ,pname     => 'INCREMENTAL'
     ,pvalue    => 'TRUE');
END;
/

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,partname      => 'P1'
     ,GRANULARITY   => 'APPROX_GLOBAL AND PARTITION'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1');

   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,partname      => 'P2'
     ,granularity   => 'APPROX_GLOBAL AND PARTITION'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1');
END;
/

SELECT column_name
      ,a.num_distinct p1_distinct
      ,b.num_distinct p2_distinct
      ,c.num_distinct tab_distinct
  FROM all_part_col_statistics a
       FULL JOIN all_part_col_statistics b
          USING (owner, table_name, column_name)
       FULL JOIN all_tab_col_statistics c
          USING (owner, table_name, column_name)
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT_PART'
       AND a.partition_name = 'P1'
       AND b.partition_name = 'P2';