SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM oe.customers
       WHERE UPPER (cust_last_name) = 'KANTH';

SELECT * FROM TABLE (DBMS_XPLAN.display);

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM oe.customers
       WHERE     UPPER (cust_first_name) = 'MALCOLM'
             AND UPPER (cust_last_name) = 'KANTH';


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM oe.customers
       WHERE UPPER (cust_first_name) = 'MALCOLM';

SELECT * FROM TABLE (DBMS_XPLAN.display);