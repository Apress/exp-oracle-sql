SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT prod_id
                     ,amount_sold
                     ,cust_id
                     ,ROW_NUMBER ()
                      OVER (PARTITION BY prod_id
                            ORDER BY amount_sold DESC, cust_id ASC)
                         rn
                 FROM sh.sales)
      SELECT prod_id, amount_sold largest_sale, cust_id largest_sale_customer
        FROM q1
       WHERE rn = 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);