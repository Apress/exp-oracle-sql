SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ leading(e) index_join(e) */
            e.first_name, m.last_name
        FROM hr.employees e, hr.employees m
       WHERE     m.last_name = 'Mourgos'
             AND e.manager_id = m.employee_id
             AND e.last_name = 'Grant'
             AND e.department_id = 50;

SELECT * FROM TABLE (DBMS_XPLAN.display);