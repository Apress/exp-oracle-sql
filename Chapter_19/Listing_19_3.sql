SET LINES 200 PAGES 0
EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT /*+ no_merge */
                      ROWID rid
                 FROM t1
                WHERE cust_id = 462)
          ,q2
           AS (SELECT /*+ no_merge */
                      ROWID rid
                 FROM t1
                WHERE prod_id = 19)
      SELECT /*+ leading(q1 q2) use_nl(t1) */
             t1.*
        FROM q1, q2, t1
       WHERE q1.rid = q2.rid AND q2.rid = t1.ROWID;

SELECT * FROM TABLE (DBMS_XPLAN.display);