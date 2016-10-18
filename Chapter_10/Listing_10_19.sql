SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ index_combine(t) */
             COUNT (*)
        FROM t1 t
       WHERE (c1 > 0 AND c5 = 1 AND c3 > 0) OR c4 > 0;

SELECT * FROM TABLE (DBMS_XPLAN.display);