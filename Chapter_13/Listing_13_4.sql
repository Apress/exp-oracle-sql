CREATE OR REPLACE VIEW cust_sales
AS
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

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT sales_cust_id
            ,amount_sold
            ,avg_sold
            ,cnt
        FROM cust_sales;

SELECT * FROM TABLE (DBMS_XPLAN.display);

CREATE OR REPLACE VIEW cust_sales
AS
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
     FROM sh.customers c RIGHT JOIN sales_q s ON c.cust_id = s.cust_id;

EXPLAIN PLAN
   FOR
      SELECT /*+ no_eliminate_join(@SEL$13BD1B6A c@sel$2) */
            sales_cust_id
            ,amount_sold
            ,avg_sold
            ,cnt
        FROM cust_sales;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ eliminate_join(@SEL$13BD1B6A c@sel$2) */
            sales_cust_id
            ,amount_sold
            ,avg_sold
            ,cnt
        FROM cust_sales;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT cust_id AS sales_cust_id
              ,SUM (amount_sold) amount_sold
              ,AVG (amount_sold) avg_sold
              ,COUNT (*) cnt
          FROM sh.sales s
      GROUP BY cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);