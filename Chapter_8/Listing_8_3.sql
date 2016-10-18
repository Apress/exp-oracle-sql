SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1 AS (SELECT c1 FROM t1)
          ,q2 AS (SELECT /*+  no_merge */
                        c2 FROM t2)
      SELECT COUNT (*)
        FROM q1, q2 myalias
       WHERE c1 = c2;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +ALIAS'));