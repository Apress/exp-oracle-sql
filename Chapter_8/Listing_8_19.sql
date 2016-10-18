ALTER SESSION ENABLE PARALLEL DML;

-- The statement below succeeds

INSERT INTO t2 (c2)
   SELECT /*+ parallel */
         c1 FROM t1;

-- The statement below fails

INSERT INTO t2 (c2)
   SELECT c1 FROM t1;

COMMIT;

-- The statement below succeeds

INSERT INTO t2 (c2)
   SELECT c1 FROM t1;

-- The statement below succeeds

INSERT INTO t2 (c2)
   SELECT c1 FROM t1;

COMMIT;