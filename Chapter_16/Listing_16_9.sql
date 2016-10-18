SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM mostly_boring
       WHERE special_flag = 'Y' AND :b1 = 'Y'
      UNION ALL
      SELECT *
        FROM mostly_boring
       WHERE special_flag = 'N' AND :b1 = 'N';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ use_concat */
             *
        FROM mostly_boring
       WHERE    (special_flag = 'Y' AND :b1 = 'Y')
             OR (special_flag = 'N' AND :b1 = 'N');

SELECT * FROM TABLE (DBMS_XPLAN.display);