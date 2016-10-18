SET LINES 200 PAGES 0

EXPLAIN PLAN FOR
MERGE /*+ rowid(t1) leading(q) use_nl(t1) */
     INTO  t1
     USING (WITH q1
                 AS (  SELECT /*+ leading(a) use_nl(b) */
                             ROWID rid, ROWNUM rn
                         FROM t1
                     ORDER BY ROWID)
            SELECT a.rid min_rid, b.rid max_rid
              FROM q1 a, q1 b
             WHERE a.rn = 11 AND b.rn = 20) q
        ON (t1.ROWID BETWEEN q.min_rid AND q.max_rid)
WHEN MATCHED
THEN
   UPDATE SET c3 = c3 + 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);