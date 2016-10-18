CREATE GLOBAL TEMPORARY TABLE cust_cache ON COMMIT PRESERVE ROWS
AS
   SELECT cust_id, cust_first_name
     FROM sh.customers c
    WHERE cust_last_name = 'Everett';

CREATE GLOBAL TEMPORARY TABLE prod_cache ON COMMIT PRESERVE ROWS
AS
   SELECT prod_id, prod_name
     FROM sh.products p
    WHERE prod_category = 'Electronics';

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT s.prod_id
            ,s.cust_id
            ,p.prod_name
            ,c.cust_first_name
            ,s.time_id
            ,s.amount_sold
        FROM sh.sales s
             JOIN cust_cache c ON s.cust_id = c.cust_id
             JOIN prod_cache p ON s.prod_id = p.prod_id
       WHERE     s.prod_id IN (SELECT prod_id FROM prod_cache)
             AND s.cust_id IN (SELECT cust_id FROM cust_cache);


SELECT * FROM TABLE (DBMS_XPLAN.display);