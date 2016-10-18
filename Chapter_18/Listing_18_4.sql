ALTER SESSION SET star_transformation_enabled=temp_disable;

EXPLAIN PLAN
   FOR
      SELECT    /*+ opt_param('_optimizer_adaptive_plans','false')
                    opt_param('_optimizer_gather_feedback','false')
                */
            * FROM t2;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'OUTLINE'));