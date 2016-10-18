SET LINES 200 PAGES 0

CREATE OR REPLACE VIEW sales_analytics
AS
   SELECT s2.prod_id
         ,s2.cust_id
         ,t.time_id
         ,s2.channel_id
         ,s2.promo_id
         ,s2.quantity_sold s2
         ,s2.amount_sold
         ,s2.avg_weekly_amount
     FROM sh.times t
         ,LATERAL (
             SELECT s.*
                   ,AVG (
                       amount_sold)
                    OVER (
                       PARTITION BY cust_id
                       ORDER BY s.time_id
                       RANGE BETWEEN INTERVAL '6' DAY PRECEDING
                             AND     CURRENT ROW)
                       avg_weekly_amount
               FROM sh.sales s
              WHERE s.time_id BETWEEN t.time_id - 6 AND t.time_id) s2
    WHERE s2.time_id = t.time_id;

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sales_analytics
       WHERE time_id = DATE '2001-10-18';

SELECT * FROM TABLE (DBMS_XPLAN.display);