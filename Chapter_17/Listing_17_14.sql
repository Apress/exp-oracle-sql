SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT /*+ cardinality(s1 1e9) */
                        ROWID rid
                   FROM sh.sales s1
               ORDER BY cust_id)
          ,q2
           AS (SELECT ROWNUM rn, rid
                 FROM q1
                WHERE ROWNUM <= 40)
          ,q3
           AS (SELECT rid
                 FROM q2
                WHERE rn > 20)
      SELECT /*+ cardinality(s2 1e9) leading(q2 s2 c p)
                 use_nl(s2)
                 rowid(s2)
                 use_nl(c) index(c)
                 use_nl(p) index(p)
                 */
             *
        FROM q3
             JOIN sh.sales s2 ON s2.ROWID = q3.rid
             JOIN sh.customers c USING (cust_id)
             JOIN sh.products p USING (prod_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);