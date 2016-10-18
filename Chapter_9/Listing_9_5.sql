SET LINES 200 PAGES 900

column num_rows format 999999999
column column_name format a20
column num_nulls format 999999999
column avg_col_len format 999999999
column num_distinct format 999999999
column density format 9.999

SELECT num_rows
      ,column_name
      ,num_nulls
      ,avg_col_len
      ,num_distinct
      ,ROUND (density, 3) density
  FROM all_tab_col_statistics c, all_tab_statistics t
 WHERE     t.owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND t.table_name = 'STATEMENT'
       AND c.owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND c.table_name = 'STATEMENT'
       AND c.column_name IN ('TRANSACTION_DATE'
                            ,'DESCRIPTION'
                            ,'POSTING_DATE'
                            ,'POSTING_DELAY');

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE description = 'Flight' AND posting_delay = 0;

SELECT * FROM TABLE (DBMS_XPLAN.display);