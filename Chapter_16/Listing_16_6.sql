DROP TABLE mostly_boring;

CREATE TABLE mostly_boring
(
   primary_key_id   INTEGER PRIMARY KEY
  ,special_flag     CHAR (1)
  ,boring_field     CHAR (100) DEFAULT RPAD ('BORING', 100)
)
PCTFREE 0;

INSERT INTO mostly_boring (primary_key_id, special_flag)
       SELECT ROWNUM, DECODE (MOD (ROWNUM, 10000), 0, 'Y', 'N')
         FROM DUAL
   CONNECT BY LEVEL <= 100000;

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname      => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname      => 'MOSTLY_BORING'
     ,method_opt   => 'FOR COLUMNS SPECIAL_FLAG SIZE 2');
END;
/

CREATE INDEX special_index
   ON mostly_boring (special_flag);

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM mostly_boring
       WHERE special_flag = :b1;

SELECT * FROM TABLE (DBMS_XPLAN.display);