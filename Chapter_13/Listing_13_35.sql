SET LINES 200 PAGES 0

ALTER SESSION SET star_transformation_enabled=TRUE;
EXPLAIN PLAN
   FOR
      SELECT prod_id
            ,cust_id
            ,p.prod_name
            ,c.cust_first_name
            ,s.time_id
            ,s.amount_sold
        FROM sh.sales s
             JOIN sh.customers c USING (cust_id)
             JOIN sh.products p USING (prod_id)
       WHERE c.cust_last_name = 'Everett' AND p.prod_category = 'Electronics';

SELECT * FROM TABLE (DBMS_XPLAN.display);