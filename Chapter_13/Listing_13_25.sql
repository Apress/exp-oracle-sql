SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.sales s1
             JOIN sh.customers c USING (cust_id)
             JOIN sh.products p ON s1.prod_id = p.prod_id
       WHERE     s1.amount_sold > (SELECT /*+ push_subq */
                                          -- Hint inapplicable to hash joins
                                         AVG (s2.amount_sold)
                                    FROM sh.sales s2
                                   WHERE s2.prod_id = p.prod_id)
             AND p.prod_category = 'Electronics'
             AND c.cust_year_of_birth = 1919;


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ leading(p s1) use_nl(s1) */
             *
        FROM sh.sales s1
             JOIN sh.customers c USING (cust_id)
             JOIN sh.products p ON s1.prod_id = p.prod_id
       WHERE     s1.amount_sold > (SELECT /*+ push_subq */
                                          AVG (s2.amount_sold)
                                     FROM sh.sales s2
                                    WHERE s2.prod_id = p.prod_id)
             AND p.prod_category = 'Electronics'
             AND c.cust_year_of_birth = 1919;

SELECT * FROM TABLE (DBMS_XPLAN.display);