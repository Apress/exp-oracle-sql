DECLARE
   dummy   NUMBER := 0;
BEGIN
   FOR r IN (WITH q1 AS (SELECT /*+ TAG1 */
                               * FROM t1)
             SELECT *
               FROM (SELECT *
                       FROM q1, t2
                      WHERE q1.c1 = t2.c2 AND c1 > dummy
                     UNION ALL
                     SELECT *
                       FROM t3, t4
                      WHERE t3.c3 = t4.c4 AND c3 > dummy)
                   ,t3
              WHERE c1 = c3)
   LOOP
      NULL;
   END LOOP;
END;
/

SET LINES 200 PAGES 0

SELECT p.*
  FROM v$sql s
      ,TABLE (
          DBMS_XPLAN.display_cursor (s.sql_id
                                    ,s.child_number
                                    ,'BASIC +PEEKED_BINDS')) p
 WHERE sql_text LIKE 'WITH%SELECT /*+ TAG1 */%';
