SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ no_partial_join(s1) no_partial_join(s2)     no_place_distinct(s1) */
             DISTINCT cust_id, prod_id
        FROM sh.sales s1 JOIN sh.sales s2 USING (cust_id, prod_id)
       WHERE     s1.time_id < DATE '2000-01-01'
             AND s2.time_id >= DATE '2000-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+  no_partial_join(s1) no_partial_join(s2) place_distinct(s1) */
             DISTINCT cust_id, prod_id
        FROM sh.sales s1 JOIN sh.sales s2 USING (cust_id, prod_id)
       WHERE     s1.time_id < DATE '2000-01-01'
             AND s2.time_id >= DATE '2000-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_dtp
           AS (SELECT /*+ no_partial_join(s1) no_merge */
                      DISTINCT s1.cust_id, s1.prod_id
                 FROM sh.sales s1
                WHERE s1.time_id < DATE '2000-01-01')
      SELECT /*+ no_partial_join(s2) */
             DISTINCT cust_id, prod_id
        FROM vw_dtp NATURAL JOIN sh.sales s2
       WHERE s2.time_id >= DATE '2000-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);

--
-- The following example relates to a discussion
-- following Listing 13-21
--

EXPLAIN PLAN
   FOR
      WITH vw_dtp
           AS (SELECT /*+ no_partial_join(s1) merge */
                      DISTINCT s1.cust_id, s1.prod_id
                 FROM sh.sales s1
                WHERE s1.time_id < DATE '2000-01-01')
      SELECT /*+ no_partial_join(s2) */ DISTINCT cust_id, prod_id
        FROM vw_dtp NATURAL JOIN sh.sales s2
       WHERE s2.time_id >= DATE '2000-01-01';

SELECT * FROM TABLE (DBMS_XPLAN.display);