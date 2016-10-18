CREATE PUBLIC DATABASE LINK "loopback"
USING 'localhost:1521/orcl';                                                         -- Customize for your database name and port

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ driving_site(s) */
              cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,SUM (s.amount_sold) sum_sales
          FROM sh.customers c JOIN sh.sales@loopback s USING (cust_id)
      GROUP BY cust_id, c.cust_first_name, c.cust_last_name;

SELECT * FROM TABLE (DBMS_XPLAN.display);