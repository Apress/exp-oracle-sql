EXPLAIN PLAN
   FOR
      WITH t1t2
           AS (SELECT /*+ NO_MERGE */
                     t1.c1, t2.c2
                 FROM t1, t2
                WHERE t1.c1 = t2.c2)
          ,t3t4
           AS (SELECT /*+ NO_MERGE */
                     t3.c3, t4.c4
                 FROM t3, t4
                WHERE t3.c3 = t4.c4)
      SELECT COUNT (*)
        FROM t1t2 j1, t3t4 j2
       WHERE j1.c1 + j1.c2 = j2.c3 + j2.c4;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +COST'));