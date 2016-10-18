SET LINES 200 PAGES 0

CREATE UNIQUE INDEX t1_i2
   ON t1 (c2);

EXPLAIN PLAN
   FOR
      SELECT /*+ index(t1 (c2)) */
             *
        FROM t1
       WHERE c2 = 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);