CREATE TABLE t_part1
PARTITION BY HASH (c1)
   PARTITIONS 8
AS
   SELECT c1, ROWNUM AS c3 FROM t1;

CREATE TABLE t_part2
PARTITION BY HASH (c2)
   PARTITIONS 8
AS
   SELECT c1 AS c2, ROWNUM AS c4 FROM t1;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM t_part1, t_part2
       WHERE t_part1.c1 = t_part2.c2;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ parallel(t_part1 8) parallel(t_part2 8) leading(t_part1)
            pq_distribute(t_part2 NONE NONE) */
             *
        FROM t_part1, t_part2
       WHERE t_part1.c1 = t_part2.c2;

SELECT * FROM TABLE (DBMS_XPLAN.display);