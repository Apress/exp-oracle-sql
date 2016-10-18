DROP INDEX t1_cust_ix;
DROP INDEX t1_prod_ix;

CREATE INDEX t1_cust_ix2
   ON t1 (time_id, cust_id);

CREATE INDEX t1_prod_ix2
   ON t1 (time_id, prod_id);

SET LINES 200 PAGES 0
EXPLAIN PLAN
   FOR
      SELECT /*+ index_join(t1) index_combine(t1) */
             COUNT (*)
        FROM t1
       WHERE time_id = DATE '2001-12-28' AND cust_id = 1673 AND prod_id = 44;

SELECT * FROM TABLE (DBMS_XPLAN.display);