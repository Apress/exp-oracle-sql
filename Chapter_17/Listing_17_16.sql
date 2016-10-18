SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT s.*
                     ,AVG (
                         amount_sold)
                      OVER (
                         PARTITION BY cust_id
                         ORDER BY time_id
                         RANGE BETWEEN INTERVAL '6' DAY PRECEDING
                               AND     CURRENT ROW)
                         avg_weekly_amount
                 FROM sh.sales s
                WHERE     time_id >= DATE '2001-10-12'
                      AND time_id <= DATE '2001-10-18')
      SELECT *
        FROM q1
       WHERE time_id = DATE '2001-10-18';

SELECT * FROM TABLE (DBMS_XPLAN.display);