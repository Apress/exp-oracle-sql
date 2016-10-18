SET LINES 200 PAGES 0 SERVEROUT OFF

CREATE TABLE t1
(
   c1   NOT NULL
  ,c2   NOT NULL
  ,c3   NOT NULL
  ,c4   NOT NULL
  ,c5   NOT NULL
  ,c6   NOT NULL
)
AS
       SELECT ROWNUM
             ,ROWNUM
             ,ROWNUM
             ,ROWNUM
             ,ROWNUM
             ,ROWNUM
         FROM DUAL
   CONNECT BY LEVEL < 100;

CREATE BITMAP INDEX t1_bix2
   ON t1 (c4);


BEGIN
   FOR r IN (SELECT t1.*, ORA_ROWSCN oscn, ROWID rid
               FROM t1
              WHERE c1 = 1)
   LOOP
      LOOP
         UPDATE /*+ TAG1 */
               t1
            SET c3 = r.c3 + 1
          WHERE ROWID = r.rid AND ORA_ROWSCN = r.oscn;

         IF SQL%ROWCOUNT > 0 -- Update succeeded
         THEN
            EXIT;
         END IF;
      -- Display some kind of error message
      END LOOP;
   END LOOP;
END;
/

SELECT p.*
  FROM v$sql s
      ,TABLE (
          DBMS_XPLAN.display_cursor (sql_id => s.sql_id, format => 'BASIC')) p
 WHERE sql_text LIKE 'UPDATE%TAG1%';