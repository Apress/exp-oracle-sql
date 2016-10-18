SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT cust_id
                       ,time_id
                       ,SUM (amount_sold) todays_sales
                       ,  SUM (
                             NVL (SUM (amount_sold), 0))
                          OVER (
                             PARTITION BY cust_id
                             ORDER BY time_id
                             RANGE BETWEEN INTERVAL '6' DAY PRECEDING
                                   AND     CURRENT ROW)
                        / 7
                           avg_daily_sales
                       ,AVG (
                           NVL (SUM (amount_sold), 0))
                        OVER (
                           PARTITION BY cust_id
                           ORDER BY time_id
                           RANGE BETWEEN INTERVAL '6' DAY PRECEDING
                                 AND     CURRENT ROW)
                           avg_daily_sales_orig
                       ,VAR_POP (
                           NVL (SUM (amount_sold), 0))
                        OVER (
                           PARTITION BY cust_id
                           ORDER BY time_id
                           RANGE BETWEEN INTERVAL '6' DAY PRECEDING
                                 AND     CURRENT ROW)
                           variance_daily_sales_orig
                       ,COUNT (
                           time_id)
                        OVER (
                           PARTITION BY cust_id
                           ORDER BY time_id
                           RANGE BETWEEN INTERVAL '6' DAY PRECEDING
                                 AND     CURRENT ROW)
                           count_distinct
                   FROM sh.sales
               GROUP BY cust_id, time_id)
      SELECT cust_id
            ,time_id
            ,todays_sales
            ,avg_daily_sales
            ,SQRT (
                  (  (  count_distinct
                      * (  variance_daily_sales_orig
                         + POWER (avg_daily_sales_orig - avg_daily_sales, 2)))
                   + ( (7 - count_distinct) * POWER (avg_daily_sales, 2)))
                / 6)
                stddev_daily_sales
        FROM q1
       WHERE time_id >= DATE '1998-01-07';

SELECT * FROM TABLE (DBMS_XPLAN.display);