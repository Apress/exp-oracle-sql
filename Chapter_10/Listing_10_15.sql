SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
WITH q1
     AS (SELECT /*+ no_merge */ first_name, ROWID r1
           FROM hr.employees
          WHERE last_name LIKE '%ran%')
    ,q2
     AS (SELECT /*+ no_merge */ ROWID r2
           FROM hr.employees
          WHERE manager_id >= 100)
SELECT first_name
  FROM q1, q2
 WHERE r1 = r2;

SELECT * FROM TABLE (DBMS_XPLAN.display);