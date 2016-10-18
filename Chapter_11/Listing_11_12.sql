SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.countries
       WHERE country_id IN (SELECT country_id FROM sh.customers);

SELECT * FROM TABLE (DBMS_XPLAN.display);

PAUSE

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.countries
       WHERE country_id IN (SELECT /*+ NO_UNNEST */
                                  country_id FROM sh.customers);


SELECT * FROM TABLE (DBMS_XPLAN.display);