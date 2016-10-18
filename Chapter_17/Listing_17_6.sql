SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ cardinality(s 1e9) */
         s.*
    FROM sh.sales s
ORDER BY s.time_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);