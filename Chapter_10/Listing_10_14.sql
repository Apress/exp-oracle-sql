SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
SELECT
      e.first_name
  FROM hr.employees e
 WHERE e.manager_id >= 100 AND e.last_name LIKE '%ran%';

SELECT * FROM TABLE (DBMS_XPLAN.display);