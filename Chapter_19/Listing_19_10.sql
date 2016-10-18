CREATE OR REPLACE VIEW sales_simple
AS
   SELECT /*+ no_merge no_index(s (time_id)) */
         cust_id
         ,time_id
         ,promo_id
         ,amount_sold
         ,p.prod_id
         ,prod_name
     FROM sh.sales s, sh.products p
    WHERE s.prod_id = p.prod_id;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sales_simple v
             RIGHT JOIN sh.customers c
                ON c.cust_id = v.cust_id AND v.time_id = DATE '1998-03-31'
       WHERE     c.cust_first_name = 'Madison'
             AND cust_last_name = 'Roy'
             AND cust_gender = 'M';

SELECT * FROM TABLE (DBMS_XPLAN.display);