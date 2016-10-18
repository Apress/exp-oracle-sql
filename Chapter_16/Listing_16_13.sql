SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT p.prod_id
            ,p.prod_name
            ,p.prod_category
            , (SELECT SUM (amount_sold)
                 FROM sh.sales s
                WHERE s.prod_id = p.prod_id)
                sum_amount_sold
            , (SELECT SUM (quantity_sold)
                 FROM sh.sales s
                WHERE s.prod_id = p.prod_id)
                sum_quantity_sold
        FROM sh.products p;

SELECT * FROM TABLE (DBMS_XPLAN.display);