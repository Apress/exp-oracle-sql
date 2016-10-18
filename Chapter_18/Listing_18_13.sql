SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT s3.*, v2.country_sales_total
        FROM (  SELECT v1.sales_rowid
                      , (SELECT SUM (amount_sold)
                           FROM sh.customers c1
                                JOIN sh.sales s1 USING (cust_id)
                          WHERE c1.country_id = v1.country_id)
                          country_sales_total
                  FROM (  SELECT c2.country_id, s2.ROWID sales_rowid
                            FROM sh.customers c2 JOIN sh.sales s2 USING (cust_id)
                           WHERE s2.time_id BETWEEN DATE '2000-01-01'
                                                AND DATE '2000-12-31'
                        ORDER BY c2.country_id, s2.ROWID) v1
              ORDER BY country_sales_total) v2
            ,sh.sales s3
       WHERE s3.ROWID = v2.sales_rowid;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ leading(v2) use_nl(s3) */
            s3.*, v2.country_sales_total
        FROM (  SELECT /*+ no_merge */
                      v1.sales_rowid
                      , (SELECT /*+ no_unnest */
                                SUM (amount_sold)
                           FROM sh.customers c1
                                JOIN sh.sales s1 USING (cust_id)
                          WHERE c1.country_id = v1.country_id)
                          country_sales_total
                  FROM (  SELECT /*+ no_merge no_eliminate_oby */
                                c2.country_id, s2.ROWID sales_rowid
                            FROM sh.customers c2 JOIN sh.sales s2 USING (cust_id)
                           WHERE s2.time_id BETWEEN DATE '2000-01-01'
                                                AND DATE '2000-12-31'
                        ORDER BY c2.country_id, s2.ROWID) v1
              ORDER BY country_sales_total) v2
            ,sh.sales s3
       WHERE s3.ROWID = v2.sales_rowid;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'PROJECTION'));