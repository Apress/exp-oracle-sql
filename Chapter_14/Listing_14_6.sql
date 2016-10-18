CREATE TABLE t3
AS
       SELECT ROWNUM c1
         FROM DUAL
   CONNECT BY LEVEL <= 10;

CREATE TABLE t4
AS
       SELECT MOD (ROWNUM, 10) + 100 c1
         FROM DUAL
   CONNECT BY LEVEL <= 100;

CREATE TABLE t5
AS
       SELECT MOD (ROWNUM, 10) c1, RPAD ('X', 30) filler
         FROM DUAL
   CONNECT BY LEVEL <= 10000;

CREATE INDEX t5_i1
   ON t5 (c1);

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM t3, t5
       WHERE t3.c1 = t5.c1 AND t3.c1 = 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM t3, t4, t5
       WHERE t3.c1 = t4.c1 AND t4.c1 = t5.c1;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM t3, t4, t5
       WHERE t3.c1 = t5.c1 AND t4.c1 = t5.c1;

SELECT * FROM TABLE (DBMS_XPLAN.display);