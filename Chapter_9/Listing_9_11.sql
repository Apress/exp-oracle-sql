SET LINES 200 PAGES 0

--
-- Query and associated execution plan without extended statistics
--

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement t
       WHERE     transaction_date = DATE '2013-01-02'
             AND posting_date = DATE '2013-01-02';

SELECT * FROM TABLE (DBMS_XPLAN.display);

--
-- Now we gather extended statistics for the two columns
--

DECLARE
   extension_name   all_tab_col_statistics.column_name%TYPE;
BEGIN
   extension_name :=
      DBMS_STATS.create_extended_stats (
         ownname     => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
        ,tabname     => 'STATEMENT'
        ,extension   => '(TRANSACTION_DATE,POSTING_DATE)');

   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT'
     ,partname      => NULL
     ,granularity   => 'GLOBAL'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1'
     ,cascade       => FALSE);
END;
/

--
-- Now let us look at the new execution plan for the query
--
EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement t
       WHERE     transaction_date = DATE '2013-01-02'
             AND posting_date = DATE '2013-01-02';

SELECT * FROM TABLE (DBMS_XPLAN.display);