SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ opt_estimate(table c rows=46000) leading(co) use_nl(c) */
             *
        FROM sh.countries co JOIN sh.customers c USING (country_id)
       WHERE country_region = 'Asia';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ opt_estimate(join (co, c) rows=20000) leading(co) use_nl(c) */
             *
        FROM sh.countries co JOIN sh.customers c USING (country_id)
       WHERE country_region = 'Asia';


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ index(c (cust_id))
              opt_estimate(index_scan c customers_pk scale_rows=0.1)
              */
             *
        FROM sh.customers c;

SELECT * FROM TABLE (DBMS_XPLAN.display);