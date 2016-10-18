SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.sales s, sh.customers c
       WHERE     c.cust_marital_status = 'married'
             AND c.cust_gender = 'M'
             AND c.cust_year_of_birth = 1976
             AND c.cust_id = s.cust_id
             AND s.prod_id = 136;

SELECT * FROM TABLE (DBMS_XPLAN.display);