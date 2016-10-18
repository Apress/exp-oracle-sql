SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
     SELECT /*+ full(t1) */
            *
        FROM t1 SAMPLE (5);

SELECT * FROM TABLE (DBMS_XPLAN.display);