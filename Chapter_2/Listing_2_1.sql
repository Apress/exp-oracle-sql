CREATE TABLE t
AS
       SELECT 1 c1
         FROM DUAL
   CONNECT BY LEVEL <= 100;

CREATE INDEX i
   ON t (c1);

--
-- Use optimizer hints to allow the CBO to consider parallel operations
--
EXPLAIN PLAN
   FOR
      SELECT /*+ parallel(10) */
            * FROM t;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC'));

--
-- Enable parallel operations on operations involving table T
--
ALTER TABLE t PARALLEL (DEGREE 10);
--
-- Enable parallel operations on index I
--

ALTER INDEX i
   PARALLEL (DEGREE 10);

--
-- Attempt to force parallel queries of degree 10 on all SQL statements.
-- Be aware that FORCE doesn’t mean parallelism is guaranteed!
--
ALTER SESSION FORCE PARALLEL QUERY PARALLEL 10;
--
-- Setup Auto DOP for the system (logged in as SYS user, RESTART REQUIRED)
--

DELETE FROM sys.resource_io_calibrate$;

INSERT INTO sys.resource_io_calibrate$
     VALUES (CURRENT_TIMESTAMP
            ,CURRENT_TIMESTAMP
            ,0
            ,0
            ,200
            ,0
            ,0);

COMMIT;

ALTER SYSTEM SET parallel_degree_policy=auto;

ALTER SESSION ENABLE PARALLEL QUERY;