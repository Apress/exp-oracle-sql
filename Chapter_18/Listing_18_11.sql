SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH t1_t2
           AS (SELECT /*+ no_merge */
                      *
                 FROM t1 JOIN t2 ON t1.c1 = t2.c2)
          ,t3_t4
           AS (SELECT /*+ no_merge */
                      *
                 FROM t3 JOIN t4 ON t3.c3 = t4.c4)
      SELECT /*+ use_hash(t1_t2) use_hash(t3_t4) */
             *
        FROM t1_t2 JOIN t3_t4 ON t1_t2.c1 + t1_t2.c2 = t3_t4.c3 + t3_t4.c4;

SELECT * FROM TABLE (DBMS_XPLAN.display);