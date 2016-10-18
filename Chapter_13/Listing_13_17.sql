SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ no_place_group_by */
               cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_category
              ,SUM (s.amount_sold) total_amt_sold
          FROM sh.sales s
               JOIN sh.customers c USING (cust_id)
               JOIN sh.products p USING (prod_id)
      GROUP BY cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_category;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT /*+   place_group_by((s p)) */
              cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_category
              ,SUM (s.amount_sold) total_amt_sold
          FROM sh.sales s
               JOIN sh.customers c USING (cust_id)
               JOIN sh.products p USING (prod_id)
      GROUP BY cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_category;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_gbc
           AS (  SELECT /*+ no_place_group_by */
                       s.cust_id
                       ,p.prod_category
                       ,SUM (s.amount_sold) total_amt_sold
                   FROM sh.sales s JOIN sh.products p USING (prod_id)
               GROUP BY s.cust_id, p.prod_category, prod_id)
        SELECT /*+ no_place_group_by leading(vw_gbc)
                  use_hash(c) no_swap_join_inputs(c) */
              cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,vw_gbc.prod_category
              ,SUM (vw_gbc.total_amt_sold) total_amt_sold
          FROM vw_gbc JOIN sh.customers c USING (cust_id)
      GROUP BY cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,vw_gbc.prod_category;

SELECT * FROM TABLE (DBMS_XPLAN.display);