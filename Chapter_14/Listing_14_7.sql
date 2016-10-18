SET PAGES 0 LINES 200

CREATE TABLE t6
AS
 SELECT ROWNUM c1, MOD (ROWNUM, 2) c2, RPAD ('X', 10) filler
         FROM DUAL
   CONNECT BY LEVEL <= 1000;

CREATE TABLE t7
AS
       SELECT ROWNUM c1, ROWNUM c2
         FROM DUAL
   CONNECT BY LEVEL <= 10;

CREATE INDEX t6_i1
   ON t6 (c2, c1, filler);

EXPLAIN PLAN
   FOR
      WITH subq
           AS (  SELECT /*+ no_merge */
                       t6.c2, MAX (t6.c1) max_c1
                   FROM t6
               GROUP BY t6.c2)
      SELECT c2, subq.max_c1
        FROM t7 LEFT JOIN subq USING (c2);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT c2
            , (SELECT /*+ no_unnest */
                      MAX (c1)
                 FROM t6
                WHERE t6.c2 = t7.c2)
                max_c1
        FROM t7;

SELECT * FROM TABLE (DBMS_XPLAN.display);