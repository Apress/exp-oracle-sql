SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE CASE
                WHEN description <> 'Flight' AND transaction_amount > 100
                THEN
                   'HIGH'
             END = 'HIGH';

SELECT * FROM TABLE (DBMS_XPLAN.display);

DECLARE
   extension_name   all_tab_cols.column_name%TYPE;
BEGIN
   extension_name :=
      DBMS_STATS.create_extended_stats (
         ownname     => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
        ,tabname     => 'STATEMENT'
        ,extension   => q'[(CASE WHEN DESCRIPTION <> 'Flight'
                                      AND TRANSACTION_AMOUNT > 100
                                 THEN 'HIGH' END)]');

   DBMS_STATS.gather_table_stats (
      ownname      => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname      => 'STATEMENT'
     ,partname     => NULL
     ,method_opt   => 'FOR ALL COLUMNS SIZE 1'
     ,cascade      => FALSE);
END;
/

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE CASE
                WHEN description <> 'Flight' AND transaction_amount > 100
                THEN
                   'HIGH'
             END = 'HIGH';

SELECT * FROM TABLE (DBMS_XPLAN.display);