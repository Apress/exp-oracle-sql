SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT e1.*, e3.avg_sal
        FROM scott.emp e1
            ,LATERAL (SELECT AVG (e2.sal) avg_sal
                        FROM scott.emp e2
                       WHERE e1.deptno != e2.deptno) e3;

SELECT * FROM TABLE (DBMS_XPLAN.display);