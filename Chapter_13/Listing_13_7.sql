SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+  no_full_outer_join_to_outer(cust) */
             *
        FROM sh.countries
             FULL OUTER JOIN sh.customers cust USING (country_id)
       WHERE cust.cust_id IS NOT NULL;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+    full_outer_join_to_outer(cust) */
             *
        FROM sh.countries
             FULL OUTER JOIN sh.customers cust USING (country_id)
       WHERE cust.cust_id IS NOT NULL;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.countries
             RIGHT OUTER JOIN sh.customers cust USING (country_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);