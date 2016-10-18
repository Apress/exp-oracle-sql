BEGIN
   EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level=all';
END;
/

SET PAGES 900 LINES 200 SERVEROUTPUT OFF
COMMIT;
ALTER SESSION ENABLE PARALLEL DML;

CREATE TABLE t1
(
   n1       INT
  ,n2       INT
  ,filler   CHAR (10)
)
NOLOGGING;

INSERT /*+ parallel(t1 10) */
      INTO  t1
   WITH generator
        AS (    SELECT ROWNUM rn
                  FROM DUAL
            CONNECT BY LEVEL <= 4500)
   SELECT TRUNC (ROWNUM / 80000)
         ,ROWNUM + 5000 * (MOD (ROWNUM, 2))
         ,RPAD ('X', 10)
     FROM generator, generator;

COMMIT;

CREATE INDEX t1_n1
   ON t1 (n1)
   NOLOGGING
   PARALLEL 10;


COLUMN index_name FORMAT a10

SELECT index_name, clustering_factor
  FROM all_indexes
 WHERE index_name = 'T1_N1';

ALTER SYSTEM FLUSH BUFFER_CACHE;

SELECT MAX (filler)
  FROM t1
 WHERE n1 = 2;

SELECT *
  FROM TABLE (
          DBMS_XPLAN.display_cursor (NULL
                                    ,NULL
                                    ,'basic cost iostats -predicate'));


ALTER SYSTEM FLUSH BUFFER_CACHE;

SELECT /*+ full(t1) */
       MAX (filler)
  FROM t1
 WHERE n1 = 2;

SELECT *
  FROM TABLE (
          DBMS_XPLAN.display_cursor (NULL
                                    ,NULL
                                    ,'basic cost iostats -predicate'));