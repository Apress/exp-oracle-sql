SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ cardinality(c 46000) leading(co) use_nl(c) */
             *
        FROM sh.countries co JOIN sh.customers c USING (country_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ cardinality(c 46000) leading(co) use_nl(c) */
             *
        FROM sh.countries co JOIN sh.customers c USING (country_id)
       WHERE country_region = 'Asia';

SELECT * FROM TABLE (DBMS_XPLAN.display);