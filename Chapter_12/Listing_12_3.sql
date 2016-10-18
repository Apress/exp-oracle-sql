SET LINES 200 PAGES 0 SERVEROUT OFF

SELECT /*+ gather_plan_statistics */ *
  FROM hr.employees e JOIN hr.departments d USING (department_id)
 WHERE e.job_id = 'SH_CLERK';

SELECT *
  FROM TABLE (
          DBMS_XPLAN.display_cursor (format => 'BASIC ROWS IOSTATS LAST'));
