SET LINES 200 PAGES 0

CREATE OR REPLACE VIEW sales_analytics
AS
   SELECT s.*
         ,AVG (
             amount_sold)
          OVER (PARTITION BY cust_id
                ORDER BY time_id
                RANGE BETWEEN INTERVAL '6' DAY PRECEDING AND CURRENT ROW)
             avg_weekly_amount
     FROM sh.sales s;

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sales_analytics
       WHERE time_id = DATE '2001-10-18';

SELECT * FROM TABLE (DBMS_XPLAN.display);