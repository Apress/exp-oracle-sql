SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+
 leading (t4 t3 t2 t1)
 use_nl(t3)
 use_nl(t2)
 use_nl(t1)
 */
             *
        FROM t1
            ,t2
            ,t3
            ,t4
       WHERE t1.c1 = t2.c2 AND t2.c2 = t3.c3 AND t3.c3 = t4.c4;


SELECT * FROM TABLE (DBMS_XPLAN.display);