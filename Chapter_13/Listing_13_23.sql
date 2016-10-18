SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT /*+ inline */
                       prod_name
                       ,prod_category
                       ,SUM (amount_sold) total_amt_sold
                   FROM sh.sales JOIN sh.products USING (prod_id)
                  WHERE prod_category = 'Electronics'
               GROUP BY prod_name, prod_category)
          ,q2
           AS (SELECT 1 AS order_col, prod_name, total_amt_sold FROM q1
               UNION ALL
               SELECT 2, 'Total', SUM (total_amt_sold) FROM q1)
          ,q3 AS (SELECT /*+ materialize */
                        * FROM q2)
        SELECT prod_name, total_amt_sold
          FROM q3
      ORDER BY order_col, prod_name;

SELECT * FROM TABLE (DBMS_XPLAN.display);