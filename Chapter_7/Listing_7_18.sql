CREATE TABLE t2
(
   c1            NUMBER
  ,c2            NUMBER
  ,big_column1   CHAR (2000)
  ,big_column2   CHAR (2000)
);


INSERT /*+ APPEND */
      INTO  t2 (c1
               ,c2
               ,big_column1
               ,big_column2)
       SELECT ROWNUM
             ,MOD (ROWNUM, 5)
             ,RPAD ('X', 2000)
             ,RPAD ('X', 2000)
         FROM DUAL
   CONNECT BY LEVEL <= 50000;

COMMIT;

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT c2, AVG (c1) avg_c1
                   FROM t2
               GROUP BY c2)
      SELECT *
        FROM t2 NATURAL JOIN q1;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT t2.*, AVG (c1) OVER (PARTITION BY c2) avg_c1 FROM t2;

SELECT * FROM TABLE (DBMS_XPLAN.display);