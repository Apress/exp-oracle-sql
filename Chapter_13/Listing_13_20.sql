SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT /*+ no_merge */
                      CASE prod_category
                         WHEN 'Electronics' THEN amount_sold * 0.9
                         ELSE amount_sold
                      END
                         AS adjusted_amount_sold
                 FROM sh.sales JOIN sh.products USING (prod_id))
        SELECT adjusted_amount_sold, COUNT (*) cnt
          FROM q1
      GROUP BY adjusted_amount_sold;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT /*+   merge */
                     CASE prod_category
                         WHEN 'Electronics' THEN amount_sold * 0.9
                         ELSE amount_sold
                      END
                         AS adjusted_amount_sold
                 FROM sh.sales JOIN sh.products USING (prod_id))
        SELECT adjusted_amount_sold, COUNT (*) cnt
          FROM q1
      GROUP BY adjusted_amount_sold;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT CASE prod_category
                  WHEN 'Electronics' THEN amount_sold * 0.9
                  ELSE amount_sold
               END
                  AS adjusted_amount_sold
          FROM sh.sales JOIN sh.products USING (prod_id)
      GROUP BY CASE prod_category
                  WHEN 'Electronics' THEN amount_sold * 0.9
                  ELSE amount_sold
               END;

SELECT * FROM TABLE (DBMS_XPLAN.display);