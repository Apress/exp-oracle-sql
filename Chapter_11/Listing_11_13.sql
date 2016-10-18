SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ optimizer_features_enable('11.2.0.3') */
             *
        FROM t1
       WHERE    t1.c1 IS NULL
             OR EXISTS
                   (SELECT *
                      FROM t2
                     WHERE t1.c1 = t2.c2);


SELECT * FROM TABLE (DBMS_XPLAN.display);

PAUSE

EXPLAIN PLAN
   FOR
      SELECT *
        FROM t1
       WHERE    t1.c1 IS NULL
             OR EXISTS
                   (SELECT *
                      FROM t2
                     WHERE t1.c1 = t2.c2);


SELECT * FROM TABLE (DBMS_XPLAN.display);