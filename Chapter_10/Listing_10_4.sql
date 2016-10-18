SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ index(t1 (c1,c2)) */
            MAX (c1) FROM t1;

SELECT * FROM TABLE (DBMS_XPLAN.display);