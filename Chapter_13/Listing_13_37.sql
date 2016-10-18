ALTER SESSION SET star_transformation_enabled=temp_disable;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT prod_id
            ,cust_id
            ,prod_name
            ,cust_first_name
            ,time_id
            ,amount_sold
        FROM sh.sales s
             JOIN sh.products USING (prod_id)
             JOIN sh.customers USING (cust_id)
       WHERE     cust_id IN (SELECT c.cust_id
                               FROM sh.customers c
                              WHERE cust_last_name = 'Everett')
             AND prod_id IN (SELECT p.prod_id
                               FROM sh.products p
                              WHERE prod_category = 'Electronics');

SELECT * FROM TABLE (DBMS_XPLAN.display);