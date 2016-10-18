SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
SELECT *            
  FROM sh.sales                
       JOIN sh.products        
          USING (prod_id)    
       LEFT JOIN sh.customers
          USING (cust_id);    
                    
                       


SELECT * FROM TABLE (DBMS_XPLAN.display);

PAUSE

EXPLAIN PLAN
   FOR
    SELECT /*+
    leading (sales customers products)
    use_hash(customers)
    use_hash(products)
    no_swap_join_inputs(customers)
    swap_join_inputs(products)
    */
    *
FROM sh.sales
    JOIN sh.products USING (prod_id)
    LEFT JOIN sh.customers USING (cust_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);