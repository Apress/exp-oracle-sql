SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT cust_id
                       ,time_id
                       ,SUM (amount_sold) todays_sales
                       ,AVG (
                           NVL (SUM (amount_sold), 0))
                        OVER (
                           PARTITION BY cust_id
                           ORDER BY time_id
                           RANGE BETWEEN INTERVAL '6' DAY PRECEDING
                                 AND     CURRENT ROW)
                           avg_daily_sales
                       ,STDDEV (
                           NVL (SUM (amount_sold), 0))
                        OVER (
                           PARTITION BY cust_id
                           ORDER BY time_id
                           RANGE BETWEEN INTERVAL '6' DAY PRECEDING
                                 AND     CURRENT ROW)
                           stddev_daily_sales
                   FROM sh.times t
                        LEFT JOIN sh.sales s
                           PARTITION BY (cust_id)
                           USING (time_id)
               GROUP BY cust_id, time_id)
      SELECT *
        FROM q1
       WHERE todays_sales > 0 AND time_id >= DATE '1998-01-07';

SELECT * FROM TABLE (DBMS_XPLAN.display);