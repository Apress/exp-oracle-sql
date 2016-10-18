SET LINES 200 PAGES 0
EXPLAIN PLAN
   FOR
      SELECT /*+ no_eliminate_join(t1) no_eliminate_join(t2) leading(t1) use_nl(t2) rowid(t2) */
             t2.*
        FROM sh.sales t1, sh.sales t2
       WHERE MOD (t1.cust_id, 10000) = 1 AND t2.ROWID = t1.ROWID;

SELECT * FROM TABLE (DBMS_XPLAN.display);