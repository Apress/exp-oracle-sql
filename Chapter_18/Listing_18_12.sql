SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT time_id
                       ,cust_id
                       ,MIN (amount_sold) min_as
                       ,MAX (amount_sold) max_as
                       ,SUM (amount_sold) sum_as
                       ,  100
                        * ratio_to_report (SUM (amount_sold))
                             OVER (PARTITION BY time_id)
                           pct_total
                   FROM sh.sales
               GROUP BY time_id, cust_id)
      SELECT *
        FROM q1
       WHERE time_id = DATE '1999-12-31' AND min_as < 100
      UNION ALL
      SELECT *
        FROM q1
       WHERE time_id = DATE '2000-01-01' AND max_as > 100;


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT /*+ inline */
                       time_id
                       ,cust_id
                       ,MIN (amount_sold) min_as
                       ,MAX (amount_sold) max_as
                       ,SUM (amount_sold) sum_as
                       ,  100
                        * ratio_to_report (SUM (amount_sold))
                             OVER (PARTITION BY time_id)
                           pct_total
                   FROM sh.sales
               GROUP BY time_id, cust_id)
      SELECT *
        FROM q1
       WHERE time_id = DATE '1999-12-31' AND min_as < 100
      UNION ALL
      SELECT *
        FROM q1
       WHERE time_id = DATE '2000-01-01' AND max_as > 100;

SELECT * FROM TABLE (DBMS_XPLAN.display);