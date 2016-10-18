SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT prod_id
              ,MAX (amount_sold) largest_sale
              ,MIN (cust_id) KEEP (DENSE_RANK FIRST ORDER BY amount_sold DESC)
                  largest_sale_customer
          FROM sh.sales
      GROUP BY prod_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);