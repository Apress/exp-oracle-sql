SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
  SELECT /*+ parallel(t_part1 8)
           parallel(t1 8) full(t1)
           leading(t1)
           no_swap_join_inputs(t_part1)
           px_join_filter(t_part1)
           pq_distribute(t_part1 PARTITION NONE) */
       *
  FROM t_part1 JOIN t1 USING (c1);

SELECT * FROM TABLE (DBMS_XPLAN.display);