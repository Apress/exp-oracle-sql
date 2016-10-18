SET LINES 200 PAGES 0
EXPLAIN PLAN
   FOR
      SELECT /*+ cardinality(s 918) */
             *
        FROM sh.sales s
       WHERE     amount_sold > 100
             AND prod_id IN (SELECT /*+ no_unnest */
                                    prod_id
                               FROM sh.products p
                              WHERE prod_category = 'Hardware');

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ cardinality(s 918) */
             *
        FROM sh.sales s
       WHERE     amount_sold > 100
             AND prod_id IN (SELECT /*+ no_unnest push_subq */
                                    prod_id
                               FROM sh.products p
                              WHERE prod_category = 'Hardware');

SELECT * FROM TABLE (DBMS_XPLAN.display);