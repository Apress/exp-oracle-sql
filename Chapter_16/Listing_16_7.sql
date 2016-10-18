SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.customers
       WHERE cust_id = 3228
      UNION ALL
      SELECT *
        FROM sh.customers
       WHERE cust_id = 6783;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.customers
       WHERE cust_id = 3228
      UNION
      SELECT *
        FROM sh.customers
       WHERE cust_id = 6783;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.customers
       WHERE cust_id = 3228 OR cust_id = 6783;

SELECT * FROM TABLE (DBMS_XPLAN.display);