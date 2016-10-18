SET LINES 200 PAGES 0

CREATE INDEX t1_i3
   ON t1 (c5);

CREATE BITMAP INDEX t1_bix1
   ON t1 (c3);

EXPLAIN PLAN
   FOR
      SELECT /*+ index_combine(t) no_expand */
             *
        FROM t1 t
       WHERE (c1 > 0 AND c5 = 1 AND c3 > 0) OR c4 > 0;

SELECT * FROM TABLE (DBMS_XPLAN.display);