SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ cardinality(c 46000) leading(co) use_nl(c)
                 column_stats(sh.customers, country_id, scale, distinct=23)
                 index_stats(sh.customers, customers_pk, scale,
                            clustering_factor=1, index_rows=1 blocks=1000)
                 table_stats(sh.customers, scale, blocks=100 rows=46000)
                */
             *
        FROM sh.countries co JOIN sh.customers c USING (country_id)
       WHERE country_region = 'Asia';

SELECT * FROM TABLE (DBMS_XPLAN.display);