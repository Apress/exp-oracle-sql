SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT /*+ cardinality(s1 1e9) */
                        ROWID rid
                   FROM sh.sales s1
               ORDER BY cust_id)
      SELECT /*+ cardinality(s2 1e9) leading(q1 s2 c p)
             use_nl(s2)
             rowid(s2)
             use_hash(c)
             use_hash(p)
             swap_join_inputs(c)
             swap_join_inputs(p)
             */
             *
        FROM q1
             JOIN sh.sales s2 ON s2.ROWID = q1.rid
             JOIN sh.customers c USING (cust_id)
             JOIN sh.products p USING (prod_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);