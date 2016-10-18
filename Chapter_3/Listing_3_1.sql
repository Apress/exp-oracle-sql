SET LINES 200 PAGESIZE 0 FEEDBACK OFF

EXPLAIN PLAN
   FOR
      SELECT e.*
            ,d.dname
            ,d.loc
            , (SELECT COUNT (*)
                 FROM scott.emp i
                WHERE i.deptno = e.deptno)
                dept_count
        FROM scott.emp e, scott.dept d
       WHERE e.deptno = d.deptno;

SELECT * FROM TABLE (DBMS_XPLAN.display);