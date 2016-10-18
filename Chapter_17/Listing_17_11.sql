SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ cardinality(s 1e9) full(s) */
               *
          FROM sh.sales s
               JOIN sh.customers c USING (cust_id)
               JOIN sh.products p USING (prod_id)
      ORDER BY cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);