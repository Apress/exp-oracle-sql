ALTER SESSION SET query_rewrite_integrity=trusted;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ no_expand_gset_to_union */
               DECODE (GROUPING (t.time_id), 1, 'Month total', t.time_id)
                  AS time_id
              ,t.calendar_month_desc
              ,SUM (s.amount_sold) AS dollars
          FROM sh.sales s, sh.times t
         WHERE s.time_id = t.time_id
      GROUP BY ROLLUP (t.time_id), t.calendar_month_desc
      ORDER BY calendar_month_desc, time_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT /*+   expand_gset_to_union */
              DECODE (GROUPING (t.time_id), 1, 'Month total', t.time_id)
                  AS time_id
              ,t.calendar_month_desc
              ,SUM (s.amount_sold) AS dollars
          FROM sh.sales s, sh.times t
         WHERE s.time_id = t.time_id
      GROUP BY ROLLUP (t.time_id), t.calendar_month_desc
      ORDER BY calendar_month_desc, time_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_gbc
           AS (  SELECT s.time_id, SUM (s.amount_sold) AS dollars
                   FROM sh.sales s
               GROUP BY s.time_id)
          ,gset_union
           AS (  SELECT TO_CHAR (vw_gbc.time_id) AS time_id
                       ,t.calendar_month_desc
                       ,SUM (vw_gbc.dollars) AS dollars
                   FROM vw_gbc, sh.times t
                  WHERE vw_gbc.time_id = t.time_id
               GROUP BY vw_gbc.time_id, t.calendar_month_desc
               UNION ALL
               SELECT 'Month Total' AS time_id
                     ,mv.calendar_month_desc
                     ,mv.dollars
                 FROM sh.cal_month_sales_mv mv)
        SELECT *
          FROM gset_union u
      ORDER BY u.calendar_month_desc, u.time_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);