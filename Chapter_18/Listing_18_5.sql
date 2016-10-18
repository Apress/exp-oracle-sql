SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ first_rows(2000) */
               *
          FROM sh.sales s JOIN sh.customers c USING (cust_id)
      ORDER BY cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT /*+ first_rows(3000) */
               *
          FROM sh.sales s JOIN sh.customers c USING (cust_id)
      ORDER BY cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);