SET LINES 200 PAGES 0

SELECT /*+
gather_plan_statistics
leading(e)
use_hash(d)
*/
      e.*, d.loc
  FROM scott.emp e, scott.dept d
 WHERE hiredate > DATE '1980-12-17' AND e.deptno = d.deptno;

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC +IOSTATS LAST'));