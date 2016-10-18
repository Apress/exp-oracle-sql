CREATE TABLE t1
AS
       SELECT 1 c1
         FROM DUAL
   CONNECT BY LEVEL <= 100;

CREATE TABLE t2
AS
       SELECT 1 c2
         FROM DUAL
   CONNECT BY LEVEL <= 100;

CREATE TABLE t3
AS
       SELECT 1 c3
         FROM DUAL
   CONNECT BY LEVEL <= 100;

CREATE TABLE t4
AS
       SELECT 1 c4
         FROM DUAL
   CONNECT BY LEVEL <= 100;

EXPLAIN PLAN
   FOR
      WITH t1t2
           AS (SELECT t1.c1, t2.c2
                 FROM t1, t2
                WHERE t1.c1 = t2.c2)
          ,t3t4
           AS (SELECT t3.c3, t4.c4
                 FROM t3, t4
                WHERE t3.c3 = t4.c4)
      SELECT COUNT (*)
        FROM t1t2 j1, t3t4 j2
       WHERE j1.c1 + j1.c2 = j2.c3 + j2.c4;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +COST'));

PAUSE

-- The above query is transformed into the query below

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM t1
            ,t2
            ,t3
            ,t4
       WHERE     t1.c1 = t2.c2
             AND t3.c3 = t4.c4
             AND t1.c1 + t2.c2 = t3.c3 + t4.c4;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +COST'));