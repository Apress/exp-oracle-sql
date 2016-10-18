SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT COUNT (DISTINCT amount_sold)
        FROM sh.sales
       WHERE EXTRACT (MONTH FROM time_id) = 10;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT COUNT (DISTINCT amount_sold)
        FROM sh.sales s, sh.times t
       WHERE EXTRACT (MONTH FROM t.time_id) = 10 AND t.time_id = s.time_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);