SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH fs AS (SELECT /*+ qb_name(qb1) no_merge */
                        * FROM t1)
      SELECT /*+ qb_name(qb2) */
             *
        FROM fs myalias, t2
       WHERE myalias.c1 = t2.c2;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +ALIAS'));

EXPLAIN PLAN
   FOR
      WITH fs AS (SELECT /*+ qb_name(qb1) */
                        * FROM t1)
      SELECT /*+ qb_name(qb2) no_merge(myalias) */
             *
        FROM fs myalias, t2
       WHERE myalias.c1 = t2.c2;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +ALIAS'));


EXPLAIN PLAN
   FOR
      WITH fs AS (SELECT /*+ qb_name(qb1) */
                        * FROM t1)
      SELECT /*+ qb_name(qb2) no_merge(@qb1) */
             *
        FROM fs myalias, t2
       WHERE myalias.c1 = t2.c2;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +ALIAS'));


EXPLAIN PLAN
   FOR
      WITH fs AS (SELECT /*+ qb_name(qb1) no_merge(@qb2 myalias) */
                        * FROM t1)
      SELECT /*+ qb_name(qb2)  */
             *
        FROM fs myalias, t2
       WHERE myalias.c1 = t2.c2;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +ALIAS'));