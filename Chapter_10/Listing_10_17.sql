SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
SELECT /*+ and_equal(e (manager_id) (job_id)) */
      employee_id
      ,first_name
      ,last_name
      ,email
  FROM hr.employees e
 WHERE e.manager_id = 124 AND e.job_id = 'SH_CLERK';

SELECT * FROM TABLE (DBMS_XPLAN.display);