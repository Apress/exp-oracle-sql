SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ no_outer_join_to_inner(@SEL$13BD1B6A c@sel$2) */
             *
        FROM cust_sales c
       WHERE cust_id IS NOT NULL;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+   outer_join_to_inner(@SEL$13BD1B6A c@sel$2) */
             *
        FROM cust_sales c
       WHERE cust_id IS NOT NULL;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH sales_q
           AS (  SELECT cust_id
                       ,SUM (amount_sold) amount_sold
                       ,AVG (amount_sold) avg_sold
                       ,COUNT (*) cnt
                   FROM sh.sales s
               GROUP BY cust_id)
      SELECT c.*
            ,s.cust_id AS sales_cust_id
            ,s.amount_sold
            ,s.avg_sold
            ,cnt
        FROM sh.customers c JOIN sales_q s ON c.cust_id = s.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);