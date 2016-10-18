CREATE TABLE t1
AS
     SELECT *
       FROM sh.sales s
   ORDER BY time_id, cust_id, prod_id;

CREATE INDEX t1_cust_ix
   ON t1 (cust_id)
   COMPRESS 1;

CREATE INDEX t1_prod_ix
   ON t1 (prod_id)
   COMPRESS 1;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT /*+ no_merge */
                     c.cust_first_name, s.ROWID rid
                 FROM sh.customers c JOIN t1 s USING (cust_id)
                WHERE c.cust_last_name = 'Everett')
          ,q2
           AS (SELECT /*+ no_merge */
                     p.prod_name, s.ROWID rid
                 FROM sh.products p JOIN t1 s USING (prod_id)
                WHERE p.prod_category = 'Electronics')
      SELECT /*+ no_eliminate_join(s) leading(q1 q2 s) use_nl(s) */
            q2.prod_name
            ,q1.cust_first_name
            ,s.time_id
            ,s.amount_sold
        FROM q1 NATURAL JOIN q2 JOIN t1 s ON rid = s.ROWID;

SELECT * FROM TABLE (DBMS_XPLAN.display);