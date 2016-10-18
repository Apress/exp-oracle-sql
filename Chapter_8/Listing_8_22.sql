COMMIT;

ALTER SESSION DISABLE PARALLEL DML;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT /*+
                           parallel(T1)
                           full(t1)
                           no_parallel(t2)
                           no_pq_replicate(t2)
                           no_gby_pushdown
                           pq_distribute(t2 none broadcast)
                           */
                       c1 + c2 c12, AVG (c1) avg_c1, COUNT (c2) cnt_c2
                   FROM t1, t2
                  WHERE c1 = c2 + 1
               GROUP BY c1 + c2
               ORDER BY 1)
          ,q2 AS (SELECT ROWNUM rn, c12 FROM q1)
        SELECT /*+ leading(q1)
                   pq_distribute(q2 none broadcast) */
               *
          FROM q1 NATURAL JOIN q2
      ORDER BY cnt_c2;

SELECT * FROM TABLE (DBMS_XPLAN.display(format=>'BASIC +PARALLEL'));