SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement
       WHERE SUBSTR (description, 1, 1) = 'F';

SELECT * FROM TABLE (DBMS_XPLAN.display);