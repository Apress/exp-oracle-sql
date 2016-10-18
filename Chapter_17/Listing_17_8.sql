SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ cardinality(s 1e9) */
               s.*
          FROM sh.sales s, sh.customers c
         WHERE s.cust_id = c.cust_id
      ORDER BY s.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);