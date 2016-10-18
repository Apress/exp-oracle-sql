SET LINES 200 PAGES 0

CREATE OR REPLACE TYPE sales_analytics_ot
   FORCE AS OBJECT
(
   prod_id NUMBER
  ,cust_id NUMBER
  ,time_id DATE
  ,channel_id NUMBER
  ,promo_id NUMBER
  ,quantity_sold NUMBER (10, 2)
  ,amount_sold NUMBER (10, 2)
  ,avg_weekly_amount NUMBER (10, 2)
);
/

CREATE OR REPLACE TYPE sales_analytics_tt AS TABLE OF sales_analytics_ot;
/

CREATE OR REPLACE VIEW sales_analytics
AS
   SELECT t1.time_id min_time, t2.time_id max_time, s2.*
     FROM sh.times t1
         ,sh.times t2
         ,TABLE (
             CAST (
                MULTISET (
                   SELECT s.*
                         ,AVG (
                             amount_sold)
                          OVER (
                             PARTITION BY cust_id
                             ORDER BY time_id
                             RANGE BETWEEN INTERVAL '6' DAY PRECEDING
                                   AND     CURRENT ROW)
                             avg_weekly_amount
                     FROM sh.sales s
                    WHERE s.time_id BETWEEN t1.time_id - 6 AND t2.time_id) AS sales_analytics_tt)) s2
    WHERE s2.time_id >= t1.time_id;

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sales_analytics
       WHERE min_time = DATE '2001-10-01' AND max_time = DATE '2002-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);