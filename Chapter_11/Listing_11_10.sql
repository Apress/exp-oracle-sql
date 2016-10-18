SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+
   leading (t1 t2 t3 t4)
   use_hash(t2)
   use_hash(t3)
   use_hash(t4)
   no_swap_join_inputs(t2)
   no_swap_join_inputs(t3)
   no_swap_join_inputs(t4)
   */
             *
        FROM t1
            ,t2
            ,t3
            ,t4
       WHERE t1.c1 = t2.c2 AND t2.c2 = t3.c3 AND t3.c3 = t4.c4;

SELECT * FROM TABLE (DBMS_XPLAN.display);

PAUSE

EXPLAIN PLAN
   FOR
      SELECT /*+
     leading (t1 t2 t3 t4)
     use_hash(t2)
     use_hash(t3)
     use_hash(t4)
     swap_join_inputs(t2)
     swap_join_inputs(t3)
     swap_join_inputs(t4)
      */
             *
        FROM t1
            ,t2
            ,t3
            ,t4
       WHERE t1.c1 = t2.c2 AND t2.c2 = t3.c3 AND t3.c3 = t4.c4;

SELECT * FROM TABLE (DBMS_XPLAN.display);