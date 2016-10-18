SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ index_ss_desc(t1 (c1,c2)) */
               *
          FROM t1
         WHERE c2 = 3
      ORDER BY c1 DESC, c2 DESC;

SELECT * FROM TABLE (DBMS_XPLAN.display);