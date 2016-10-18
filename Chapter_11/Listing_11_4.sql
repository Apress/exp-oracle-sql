SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT
/*+ leading(e d1)
use_nl(d)
index(d)
rowid(d)
optimizer_features_enable('10.2.0.5') */
            e.*, d.loc
        FROM scott.emp e, scott.dept d1, scott.dept d
       WHERE     e.hiredate > DATE '1980-12-17'
             AND e.deptno = d1.deptno
             AND d.ROWID = d1.ROWID;

SELECT * FROM TABLE (DBMS_XPLAN.display);