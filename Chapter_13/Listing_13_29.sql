SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ no_expand */
             SUM (amount_sold) cnt
        FROM sh.sales JOIN sh.products USING (prod_id)
       WHERE time_id = DATE '1998-03-31' OR prod_name = 'Y Box';


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ use_concat */
             SUM (amount_sold) cnt
        FROM sh.sales JOIN sh.products USING (prod_id)
       WHERE time_id = DATE '1998-03-31' OR prod_name = 'Y Box';


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT amount_sold
                 FROM sh.sales JOIN sh.products USING (prod_id)
                WHERE prod_name = 'Y Box'
               UNION ALL
               SELECT amount_sold
                 FROM sh.sales JOIN sh.products USING (prod_id)
                WHERE     time_id = DATE '1998-03-31'
                      AND LNNVL (prod_name = 'Y Box'))
      SELECT SUM (amount_sold) cnt
        FROM q1;

SELECT * FROM TABLE (DBMS_XPLAN.display);