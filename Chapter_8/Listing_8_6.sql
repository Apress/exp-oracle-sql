SET LINES 200 PAGES 0

ALTER SESSION SET star_transformation_enabled=temp_disable;

EXPLAIN PLAN
   FOR
      INSERT /*+ APPEND */
            INTO  t2 (c2)
         WITH q1
              AS (SELECT *
                    FROM book.t1@loopback t1)
         SELECT COUNT (*)
           FROM (SELECT *
                   FROM q1, t2
                  WHERE q1.c1 = t2.c2
                 UNION ALL
                 SELECT *
                   FROM t3, t4
                  WHERE t3.c3 = t4.c4 -- ORDER BY 1  … see the explanation of column projections below
                                     )
               ,t3
          WHERE c1 = c3;

COMMIT;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'ADVANCED'));

ALTER SESSION SET star_transformation_enabled=FALSE;