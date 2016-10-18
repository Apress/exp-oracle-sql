SET LINES 200 PAGES 0

DROP TABLE t1;
DROP TABLE t2;

CREATE TABLE t1
AS
   SELECT ROWNUM c1
     FROM all_objects
    WHERE ROWNUM <= 5;

CREATE TABLE t2
AS
   SELECT c1 + 1 c2 FROM t1;

CREATE TABLE t3
AS
   SELECT c2 + 1 c3 FROM t2;

CREATE TABLE t4
AS
   SELECT c3 + 1 c4 FROM t3;

EXPLAIN PLAN
   FOR
      SELECT *
        FROM (t1 JOIN t2 ON t1.c1 = t2.c2)
             JOIN (t3 JOIN t4 ON t3.c3 = t4.c4)
                ON t1.c1 + t2.c2 = t3.c3 + t4.c4;

SELECT * FROM TABLE (DBMS_XPLAN.display);