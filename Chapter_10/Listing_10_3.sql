SET LINES 200 PAGES 0

CREATE INDEX t1_i1
   ON t1 (c1, c2);

EXPLAIN PLAN
   FOR
      SELECT /*+ index(t1 (c1,c2)) */
            * FROM t1;

SELECT * FROM TABLE (DBMS_XPLAN.display);