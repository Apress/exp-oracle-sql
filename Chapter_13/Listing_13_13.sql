SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ no_factorize_join(@set$1) */
             *
        FROM sh.sales s, sh.customers c
       WHERE     c.cust_first_name = 'Abner'
             AND c.cust_last_name = 'Everett'
             AND s.cust_id = c.cust_id
      /* AND prod_id = 13
      AND time_id = DATE '2001-09-13' */
      UNION ALL
      SELECT /*+ qb_name(u2) */
             *
        FROM sh.sales s, sh.customers c
       WHERE     c.cust_first_name = 'Abigail'
             AND c.cust_last_name = 'Ruddy'
             AND s.cust_id = c.cust_id
/* AND prod_id = 13
AND time_id = DATE '2001-09-13' */;


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+   factorize_join(@set$1(s@u1 S@u2)) qb_name(u1) */
             *
        FROM sh.sales s, sh.customers c
       WHERE     c.cust_first_name = 'Abner'
             AND c.cust_last_name = 'Everett'
             AND s.cust_id = c.cust_id
      /* AND prod_id = 13
      AND time_id = DATE '2001-09-13' */
      UNION ALL
      SELECT /*+ qb_name(u2) */
             *
        FROM sh.sales s, sh.customers c
       WHERE     c.cust_first_name = 'Abigail'
             AND c.cust_last_name = 'Ruddy'
             AND s.cust_id = c.cust_id
/* AND prod_id = 13
AND time_id = DATE '2001-09-13' */;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_jf
           AS (SELECT *
                 FROM sh.customers c
                WHERE     c.cust_first_name = 'Abner'
                      AND c.cust_last_name = 'Everett'
               UNION ALL
               SELECT *
                 FROM sh.customers c
                WHERE     c.cust_first_name = 'Abigail'
                      AND c.cust_last_name = 'Ruddy')
      SELECT *
        FROM sh.sales s, vw_jf
       WHERE s.cust_id = vw_jf.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);