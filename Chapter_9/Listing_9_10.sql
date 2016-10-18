SET LINES 200 PAGES 900
--
-- Query 1: using an explictly declared
-- virtual column
--
EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE posting_delay = 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);

--
-- Query 2: using an expression equivalent to
-- an explictly declared virtual column.
--
EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE (posting_date - transaction_date) = 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);

--
-- Query 3: using an expression not identical to
-- virtual column.
--
EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE (transaction_date - posting_date) = -1;

SELECT * FROM TABLE (DBMS_XPLAN.display);

--
-- Query 4: using a hidden column
--
EXPLAIN PLAN
   FOR
      SELECT /*+ full(s) */
             sys_nc00010$
        FROM statement s
       WHERE sys_nc00010$ = TIMESTAMP '2013-01-02 17:00:00.00';

SELECT * FROM TABLE (DBMS_XPLAN.display);

--
-- Query 5: using an expression equivalent to
-- a hidden column.
--

EXPLAIN PLAN
   FOR
      SELECT SYS_EXTRACT_UTC (transaction_date_time)
        FROM statement s
       WHERE SYS_EXTRACT_UTC (transaction_date_time) =
                TIMESTAMP '2013-01-02 17:00:00.00';

SELECT * FROM TABLE (DBMS_XPLAN.display);

--
-- Query 6: using the timestamp with time zone column
--

EXPLAIN PLAN
   FOR
      SELECT transaction_date_time
        FROM statement s
       WHERE transaction_date_time =
                TIMESTAMP '2013-01-02 12:00:00.00 -05:00';

SELECT * FROM TABLE (DBMS_XPLAN.display);