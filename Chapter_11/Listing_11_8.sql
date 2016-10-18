SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ leading (t1) use_merge_cartesian(t2) */
             *
        FROM t1, t2;


SELECT * FROM TABLE (DBMS_XPLAN.display);