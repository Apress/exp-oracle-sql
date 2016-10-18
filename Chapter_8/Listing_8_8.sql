SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      INSERT /*+ APPEND */
            INTO  t2 (c2)
         WITH q1
              AS (SELECT *
                    FROM book.t1@loopback t1)
         SELECT /*+
          BEGIN_OUTLINE_DATA
          USE_HASH(@"SEL$F1D6E378" "T1"@"SEL$1")
          LEADING(@"SEL$F1D6E378" "T1"@"SEL$1" "T2"@"SEL$3")
          FULL(@"SEL$F1D6E378" "T1"@"SEL$1")
          FULL(@"SEL$F1D6E378" "T2"@"SEL$3")
          USE_HASH(@"SEL$4" "T4"@"SEL$4")
          LEADING(@"SEL$4" "T3"@"SEL$4" "T4"@"SEL$4")
          FULL(@"SEL$4" "T4"@"SEL$4")
          FULL(@"SEL$4" "T3"@"SEL$4")
          USE_HASH(@"SEL$2" "from$_subquery$_003"@"SEL$2")
          LEADING(@"SEL$2" "T3"@"SEL$2" "from$_subquery$_003"@"SEL$2")
          NO_ACCESS(@"SEL$2" "from$_subquery$_003"@"SEL$2")
          FULL(@"SEL$2" "T3"@"SEL$2")
          FULL(@"INS$1" "T2"@"INS$1")
          OUTLINE(@"SEL$1")
          OUTLINE(@"SEL$3")
          OUTLINE_LEAF(@"INS$1")
          OUTLINE_LEAF(@"SEL$2")
          OUTLINE_LEAF(@"SET$1")
          OUTLINE_LEAF(@"SEL$4")
          MERGE(@"SEL$1")
          OUTLINE_LEAF(@"SEL$F1D6E378")
          ALL_ROWS
          OPT_PARAM('star_transformation_enabled' 'temp_disable')
          DB_VERSION('12.1.0.1')
          OPTIMIZER_FEATURES_ENABLE('12.1.0.1')
          IGNORE_OPTIM_EMBEDDED_HINTS
          END_OUTLINE_DATA
      */
                COUNT (*)
           FROM (SELECT *
                   FROM q1, t2
                  WHERE q1.c1 = t2.c2
                 UNION ALL
                 SELECT *
                   FROM t3, t4
                  WHERE t3.c3 = t4.c4)
               ,t3
          WHERE c1 = c3;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'ADVANCED'));