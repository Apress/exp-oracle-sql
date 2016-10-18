SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ parallel(t2 8)
               leading(t1)
               index_ffs(t1) parallel_index(t1)
               use_hash(t2)
               no_swap_join_inputs(t2)
               pq_distribute(t2 BROADCAST NONE)
               pq_replicate(t2)
             */
             *
        FROM t1 JOIN t2 ON t1.c1 = t2.c2;

SELECT * FROM TABLE (DBMS_XPLAN.display);

PAUSE

EXPLAIN PLAN
   FOR
      SELECT /*+ parallel(t2 8)
               leading(t2)
               index_ffs(t1) parallel_index(t1)
               use_hash(t1)
               swap_join_inputs(t1)
               pq_distribute(t1 NONE BROADCAST)
               pq_replicate(t1)
            */
             *
        FROM t1 JOIN t2 ON t1.c1 = t2.c2;

SELECT * FROM TABLE (DBMS_XPLAN.display);