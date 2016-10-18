SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ cardinality(s 1e9) index(s (cust_id)) */
               s.*
          FROM sh.sales s
      ORDER BY s.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);