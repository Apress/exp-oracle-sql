SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+  no_expand_table(t) */
             COUNT (*)
        FROM t
       WHERE n = 8;


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+     expand_table(t) */
             COUNT (*)
        FROM t
       WHERE n = 8;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_te
           AS (SELECT *
                 FROM t PARTITION (t_q3_2013)
                WHERE n = 8
               UNION ALL
               SELECT *
                 FROM t
                WHERE     n = 8
                      AND (   d < TO_DATE ('2013-07-01', 'yyyy-mm-dd')
                           OR d >= TO_DATE ('2013-10-01', 'yyyy-mm-dd')))
      SELECT COUNT (*)
        FROM vw_te;

SELECT * FROM TABLE (DBMS_XPLAN.display);