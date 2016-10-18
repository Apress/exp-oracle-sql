DROP INDEX t1_n1;

CREATE INDEX t1_n1_n2
   ON t1 (n1, n2)
   NOLOGGING
   PARALLEL 10;

COLUMN index_name FORMAT a10

SELECT index_name, clustering_factor
  FROM all_indexes
 WHERE index_name = 'T1_N1_N2';

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

SELECT /*+ index(t1 t1_n1_n2) */
       MAX (filler)
  FROM t1
 WHERE n1 = 2;

SELECT *
  FROM TABLE (
          DBMS_XPLAN.display_cursor (NULL
                                    ,NULL
                                    ,'basic cost iostats -predicate'));