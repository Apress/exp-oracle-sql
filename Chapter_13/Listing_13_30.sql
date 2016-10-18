EXEC dbms_mview.refresh('SH.CAL_MONTH_SALES_MV');

ALTER SESSION SET query_rewrite_integrity=trusted;


SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ no_rewrite */
               t.calendar_month_desc, SUM (s.amount_sold) AS dollars
          FROM sh.sales s, sh.times t
         WHERE s.time_id = t.time_id
      GROUP BY t.calendar_month_desc;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT /*+   rewrite(sh.cal_month_sales_mv) */
              t.calendar_month_desc, SUM (s.amount_sold) AS dollars
          FROM sh.sales s, sh.times t
         WHERE s.time_id = t.time_id
      GROUP BY t.calendar_month_desc;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.cal_month_sales_mv mv;

SELECT * FROM TABLE (DBMS_XPLAN.display);