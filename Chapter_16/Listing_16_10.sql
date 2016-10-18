CREATE OR REPLACE VIEW sales_data
AS
   SELECT *
     FROM sh.sales
          JOIN sh.customers USING (cust_id)
          JOIN sh.products USING (prod_id);


SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT prod_name, SUM (amount_sold)
          FROM sales_data
      GROUP BY prod_name;

SELECT * FROM TABLE (DBMS_XPLAN.display);