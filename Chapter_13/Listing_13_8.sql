SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.sales s
       WHERE EXISTS
                (SELECT /*+  no_semi_to_inner(c) */
                        1
                   FROM sh.customers c
                  WHERE     c.cust_id = s.cust_id
                        AND cust_first_name = 'Abner'
                        AND cust_last_name = 'Everett');


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.sales s
       WHERE EXISTS
                (SELECT /*+   semi_to_inner(c) */
                        1
                   FROM sh.customers c
                  WHERE     c.cust_id = s.cust_id
                        AND cust_first_name = 'Abner'
                        AND cust_last_name = 'Everett');

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT DISTINCT cust_id
                 FROM sh.customers
                WHERE     cust_first_name = 'Abner'
                      AND cust_last_name = 'Everett')
      SELECT s.*
        FROM sh.sales s JOIN q1 ON s.cust_id = q1.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);