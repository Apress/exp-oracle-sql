ALTER SESSION SET optimizer_adaptive_features=FALSE;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ full(t1) parallel(t1)
              parallel(t_part2 8)
             leading(t1)
             use_hash(t_part2)
             no_swap_join_inputs(t_part2)
             pq_distribute(t_part2 HASH HASH) */
             *
        FROM t1 JOIN t_part2 ON t1.c1 = t_part2.c4
       WHERE t_part2.c2 IN (1, 3, 5);

SELECT * FROM TABLE (DBMS_XPLAN.display);