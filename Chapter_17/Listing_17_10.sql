SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT cust_id
              ,time_id
              ,SUM (amount_sold) daily_amount
              ,SUM (
                  SUM (amount_sold))
               OVER (PARTITION BY cust_id
                     ORDER BY time_id DESC
                     RANGE BETWEEN CURRENT ROW AND INTERVAL '6' DAY FOLLOWING)
                  weekly_amount
          FROM sh.sales
      GROUP BY cust_id, time_id
      ORDER BY cust_id, time_id DESC;

SELECT * FROM TABLE (DBMS_XPLAN.display);