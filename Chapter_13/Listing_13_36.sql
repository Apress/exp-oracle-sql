ALTER SESSION SET star_transformation_enabled=temp_disable;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ no_table_lookup_by_nl(s) */
            s.time_id, s.amount_sold
        FROM sh.sales s
       WHERE     s.cust_id IN (SELECT c.cust_id
                                 FROM sh.customers c
                                WHERE cust_last_name = 'Everett')
             AND s.prod_id IN (SELECT p.prod_id
                                 FROM sh.products p
                                WHERE prod_category = 'Electronics');

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /* no_table_lookup_by_nl(s) */
            s.time_id, s.amount_sold
        FROM sh.sales s
       WHERE     s.cust_id IN (SELECT c.cust_id
                                 FROM sh.customers c
                                WHERE cust_last_name = 'Everett')
             AND s.prod_id IN (SELECT p.prod_id
                                 FROM sh.products p
                                WHERE prod_category = 'Electronics');

SELECT * FROM TABLE (DBMS_XPLAN.display);