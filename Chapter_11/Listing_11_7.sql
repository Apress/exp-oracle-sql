CREATE TABLE t1
AS
   SELECT ROWNUM c1
     FROM all_objects
    WHERE ROWNUM <= 100;

CREATE TABLE t2
AS
   SELECT c1 + 1 c2 FROM t1;

CREATE TABLE t3
AS
   SELECT c2 + 1 c3 FROM t2;

CREATE TABLE t4
AS
   SELECT c3 + 1 c4 FROM t3;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ leading (t1) use_merge(t2) */
             *
        FROM t1, t2
       WHERE t1.c1 > 3 AND t2.c2 < t1.c1;


SELECT * FROM TABLE (DBMS_XPLAN.display);