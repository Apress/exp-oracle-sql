SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT COUNT (DISTINCT amount_sold)
        FROM sh.sales
       WHERE EXTRACT (YEAR FROM time_id) = 1998;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT COUNT (DISTINCT amount_sold)
        FROM sh.sales
       WHERE time_id >= DATE '1998-01-01' AND time_id < DATE '1999-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);