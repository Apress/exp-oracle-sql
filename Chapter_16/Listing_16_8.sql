SET PAGES 900

WITH q1
     AS (SELECT cust_first_name, cust_last_name
           FROM sh.customers
          WHERE cust_first_name = 'Abner'
         UNION ALL
         SELECT cust_first_name, cust_last_name
           FROM sh.customers
          WHERE cust_last_name = 'Everett')
SELECT COUNT (*)
  FROM q1;

WITH q1
     AS (SELECT cust_first_name, cust_last_name
           FROM sh.customers
          WHERE cust_first_name = 'Abner'
         UNION
         SELECT cust_first_name, cust_last_name
           FROM sh.customers
          WHERE cust_last_name = 'Everett')
SELECT COUNT (*)
  FROM q1;

WITH q1
     AS (SELECT cust_first_name, cust_last_name
           FROM sh.customers
          WHERE cust_first_name = 'Abner' OR cust_last_name = 'Everett')
SELECT COUNT (*)
  FROM q1;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT cust_first_name, cust_last_name
        FROM sh.customers
       WHERE cust_first_name = 'Abner'
      UNION ALL
      SELECT cust_first_name, cust_last_name
        FROM sh.customers
       WHERE cust_last_name = 'Everett';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT cust_first_name, cust_last_name
        FROM sh.customers
       WHERE cust_first_name = 'Abner'
      UNION
      SELECT cust_first_name, cust_last_name
        FROM sh.customers
       WHERE cust_last_name = 'Everett';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT cust_first_name, cust_last_name
        FROM sh.customers
       WHERE cust_first_name = 'Abner' OR cust_last_name = 'Everett';

SELECT * FROM TABLE (DBMS_XPLAN.display);