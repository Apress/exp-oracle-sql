SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT MAX (amount_sold) largest_sale
            ,MIN (cust_id) KEEP (DENSE_RANK FIRST ORDER BY amount_sold DESC)
                largest_sale_customer
        FROM sh.sales;

SELECT * FROM TABLE (DBMS_XPLAN.display);