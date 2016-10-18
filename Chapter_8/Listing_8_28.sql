SET LINES 200 PAGES 0
EXPLAIN PLAN
   FOR
      SELECT /*+
                 LEADING(@"SEL$2" "T1"@"SEL$2" "T2"@"SEL$2")
                 USE_NL(@"SEL$2" "T2"@"SEL$2")
             */
             *
        FROM v1, t3
       WHERE v1.c1 = t3.c3;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'ADVANCED'));