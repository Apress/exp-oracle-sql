SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT prod_id
                     ,amount_sold
                     ,MAX (amount_sold) OVER (PARTITION BY prod_id)
                         largest_sale
                     ,FIRST_VALUE (
                         cust_id)
                      OVER (PARTITION BY prod_id
                            ORDER BY amount_sold DESC, cust_id ASC)
                         largest_sale_customer
                 FROM sh.sales)
      SELECT DISTINCT prod_id, largest_sale, largest_sale_customer
        FROM q1
       WHERE amount_sold = largest_sale;

SELECT * FROM TABLE (DBMS_XPLAN.display);