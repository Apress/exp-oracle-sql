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