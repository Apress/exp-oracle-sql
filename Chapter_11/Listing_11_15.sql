SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM sh.customers c
       WHERE NOT EXISTS
                (SELECT 1
                   FROM sh.products p
                  WHERE prod_src_id = cust_src_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);

PAUSE

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM sh.customers c
       WHERE c.cust_src_id NOT IN (SELECT prod_src_id
                                     FROM sh.products p);

SELECT * FROM TABLE (DBMS_XPLAN.display);