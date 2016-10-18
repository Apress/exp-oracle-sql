CREATE /*+ NO_GATHER_OPTIMIZER_STATISTICS */ TABLE statement_part
PARTITION BY RANGE
   (transaction_date)
   (
      PARTITION p1 VALUES LESS THAN (DATE '2013-01-05')
     ,PARTITION p2 VALUES LESS THAN (maxvalue))
AS
   SELECT * FROM statement;

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,partname      => 'P1'
     ,GRANULARITY   => 'PARTITION'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1');

   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,partname      => 'P2'
     ,GRANULARITY   => 'PARTITION'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1');
END;
/

SELECT a.num_rows p1_rows
      ,a.global_stats p1_global_stats
      ,b.num_rows p2_rows
      ,b.global_stats p2_global_stats
      ,c.num_rows tab_rows
      ,c.global_stats tab_global_stats
  FROM all_tab_statistics a
       FULL JOIN all_tab_statistics b USING (owner, table_name)
       FULL JOIN all_tab_statistics c USING (owner, table_name)
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT_PART'
       AND a.partition_name = 'P1'
       AND b.partition_name = 'P2'
       AND c.partition_name IS NULL;