SET LINES 200 PAGES 900 SERVEROUT OFF
COLUMN PLAN_TABLE_OUTPUT FORMAT a200

SELECT e.*
      ,d.dname
      ,d.loc
      , (SELECT COUNT (*)
           FROM scott.emp i
          WHERE i.deptno = e.deptno)
          dept_count
  FROM scott.emp e, scott.dept d
 WHERE e.deptno = d.deptno;


SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (format => 'ALLSTATS LAST'));