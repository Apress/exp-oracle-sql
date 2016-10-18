SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT            /*+
parallel(t1) full(t1)
pq_filter(NONE)
*/
             *
        FROM t1
       WHERE EXISTS
                (SELECT NULL
                   FROM t2
                  WHERE t1.c1 != t2.c2);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT            /*+
parallel(t1) full(t1)
pq_filter(HASH)
*/
             *
        FROM t1
       WHERE EXISTS
                (SELECT NULL
                   FROM t2
                  WHERE t1.c1 != t2.c2);

SELECT * FROM TABLE (DBMS_XPLAN.display);