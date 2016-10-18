SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ no_set_to_join(@set$1) */
             prod_id
        FROM sh.sales s1
       WHERE time_id < DATE '2000-01-01' AND cust_id = 13
      MINUS
      SELECT prod_id
        FROM sh.sales s2
       WHERE time_id >= DATE '2000-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ set_to_join(@set$1) */
             prod_id
        FROM sh.sales s1
       WHERE time_id < DATE '2000-01-01' AND cust_id = 13
      MINUS
      SELECT prod_id
        FROM sh.sales s2
       WHERE time_id >= DATE '2000-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT DISTINCT s1.prod_id
        FROM sh.sales s1
       WHERE     time_id < DATE '2000-01-01'
             AND cust_id = 13
             AND prod_id NOT IN (SELECT prod_id
                                   FROM sh.sales s2
                                  WHERE time_id >= DATE '2000-01-01');

SELECT * FROM TABLE (DBMS_XPLAN.display);