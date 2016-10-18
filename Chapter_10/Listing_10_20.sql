SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ index_combine(e) */
       /* THIS HINT INNEFFECTIVE IN THIS QUERY */
      employee_id
      ,first_name
      ,last_name
      ,email
  FROM hr.employees e
 WHERE    manager_id IN (SELECT employee_id
                           FROM hr.employees
                          WHERE salary > 14000)
       OR job_id = 'SH_CLERK';

SELECT * FROM TABLE (DBMS_XPLAN.display);