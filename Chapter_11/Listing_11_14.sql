SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ leading(c) */
             *
        FROM sh.customers c
       WHERE country_id NOT IN (SELECT country_id FROM sh.countries);


SELECT * FROM TABLE (DBMS_XPLAN.display);

PAUSE

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.customers c
       WHERE country_id NOT IN (SELECT country_id FROM sh.countries);


SELECT * FROM TABLE (DBMS_XPLAN.display);