SET LINES 200 PAGES 0
EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT /*+ no_merge */
                      ROWID rid
                 FROM t1
                WHERE time_id = DATE '2001-12-28' AND cust_id = 1673)
          ,q2
           AS (SELECT /*+ no_merge */
                      ROWID rid
                 FROM t1
                WHERE time_id = DATE '2001-12-28' AND prod_id = 44)
      SELECT /*+ leading(q1 q2) use_nl(t1) */
             COUNT (*)
        FROM q1 NATURAL JOIN q2;

SELECT * FROM TABLE (DBMS_XPLAN.display);