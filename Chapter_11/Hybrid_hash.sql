SET LINES 200 PAGES 900 SERVEROUT OFF ECHO ON
--
-- The following queries are not shown in the book but demonstrate
-- that the hybrid distribution mechanism is not fixed like the
-- adaptive join mechanism.
--
-- First here is the query that uses the hybrid distribution
-- we use a degree of parallelism of 2.
--

EXPLAIN PLAN
   FOR
      SELECT /*+ full(s) parallel(s 2)
                    parallel(s 2)
                   leading(c)
                   use_hash(s)
                   no_swap_join_inputs(s)
                   pq_distribute(s HASH HASH) */
             COUNT (*) cnt
        FROM sh.sales s JOIN sh.customers c USING (cust_id)
       WHERE c.cust_last_name = :b1;

-- And here is the associated execution plan

PAUSE

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +PARALLEL'));

-- Now let us look at some possible values of CUST_LAST_NAME

PAUSE

--
-- We can see that there is only one customer with the name of Simmons,
-- 83 customers named Wade, and two customers named Foreman
--

  SELECT cust_last_name, COUNT (*) cnt
    FROM sh.customers c
   WHERE cust_last_name IN ('Simmons', 'Wade', 'Foreman')
GROUP BY cust_last_name;

-- Now let us see what happens when we specify Simmons
-- for the bind variable

PAUSE

VARIABLE b1 VARCHAR2(30);

EXEC :b1 := 'Simmons';

SELECT /*+ full(s) parallel(s 2)
              parallel(s 2)
             leading(c)
             use_hash(s)
             no_swap_join_inputs(s)
             pq_distribute(s HASH HASH) */
       COUNT (*) cnt
  FROM sh.sales s JOIN sh.customers c USING (cust_id)
 WHERE c.cust_last_name = :b1;

SELECT s.prev_sql_id, t.process, t.num_rows
  FROM v$pq_tqstat t, v$session s
 WHERE     s.sid = SYS_CONTEXT ('USERENV', 'SID')
       AND t.tq_id = 0
       AND server_type = 'Consumer  ';

--
-- We can see that the one row has been sent to both consumers
--
-- Now let us try Wade
--

PAUSE

EXEC :b1 := 'Wade';

SELECT /*+ full(s) parallel(s 2)
              parallel(s 2)
             leading(c)
             use_hash(s)
             no_swap_join_inputs(s)
             pq_distribute(s HASH HASH) */
       COUNT (*) cnt
  FROM sh.sales s JOIN sh.customers c USING (cust_id)
 WHERE c.cust_last_name = :b1;

SELECT s.prev_sql_id, t.process, t.num_rows
  FROM v$pq_tqstat t, v$session s
 WHERE     s.sid = SYS_CONTEXT ('USERENV', 'SID')
       AND t.tq_id = 0
       AND server_type = 'Consumer  ';

--
-- The 83 rows have been distributed amongst the consumers
--
-- Now let us try Foreman
--
PAUSE

EXEC :b1 := 'Foreman';

SELECT /*+ full(s) parallel(s 2)
              parallel(s 2)
             leading(c)
             use_hash(s)
             no_swap_join_inputs(s)
             pq_distribute(s HASH HASH) */
       COUNT (*) cnt
  FROM sh.sales s JOIN sh.customers c USING (cust_id)
 WHERE c.cust_last_name = :b1;

SELECT s.prev_sql_id, t.process, t.num_rows
  FROM v$pq_tqstat t, v$session s
 WHERE     s.sid = SYS_CONTEXT ('USERENV', 'SID')
       AND t.tq_id = 0
       AND server_type = 'Consumer  ';

--
-- We can see that we have reverted to the broadcast approach
-- because the two rows have been sent to both consumers
--