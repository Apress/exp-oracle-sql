CREATE /*+ NO_GATHER_OPTIMIZER_STATISTICS  */
      TABLE t2
AS
   SELECT *
     FROM all_objects
    WHERE 1 = 0;

DECLARE
   TYPE obj_table_type IS TABLE OF all_objects%ROWTYPE;

   obj_table   obj_table_type;
BEGIN
   SELECT *
     BULK COLLECT INTO obj_table
     FROM all_objects;

   FORALL i IN 1 .. obj_table.COUNT
      INSERT /*+ TAGAV append_values */
            INTO  t2
           VALUES obj_table (i);

   COMMIT;
END;
/

SET LINES 200 PAGES 0

SELECT p.*
  FROM v$sql s
      ,TABLE (DBMS_XPLAN.display_cursor (s.sql_id, s.child_number, 'BASIC')) p
 WHERE s.sql_text LIKE 'INSERT /*+ TAGAV%';