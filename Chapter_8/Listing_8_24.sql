COMMIT;

ALTER SESSION ENABLE PARALLEL DML;

EXPLAIN PLAN
   FOR
      INSERT /*+ parallel(t_part1 8) pq_distribute(t_part1 RANDOM)  */
            INTO  t_part1
         SELECT /*+ parallel(t_part2 8) */
               * FROM t_part2;

SET LINES 200 PAGES 0

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +PARTITION'));