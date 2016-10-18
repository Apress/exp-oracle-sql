SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM t1
       WHERE NOT EXISTS
                (SELECT /*+ unnest use_nl(t2) */
                        1
                   FROM t2
                  WHERE t2.c2 = t1.c1);

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'ADVANCED'));