SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT p.prod_id
              ,p.prod_name
              ,p.prod_category
              ,SUM (amount_sold) sum_amount_sold
              ,SUM (quantity_sold) sum_quantity_sold
          FROM sh.sales s, sh.products p
         WHERE s.prod_id = p.prod_id
      GROUP BY p.prod_id, p.prod_name, p.prod_category;

SELECT * FROM TABLE (DBMS_XPLAN.display);