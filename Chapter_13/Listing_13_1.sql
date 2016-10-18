SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT COUNT (cust_income_level) FROM sh.customers;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT COUNT (cust_id) FROM sh.customers;

SELECT * FROM TABLE (DBMS_XPLAN.display);