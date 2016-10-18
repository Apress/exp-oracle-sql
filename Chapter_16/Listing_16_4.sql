TRUNCATE TABLE mostly_boring;

INSERT INTO mostly_boring (primary_key_id, special_flag)
       SELECT ROWNUM, DECODE (MOD (ROWNUM, 10000), 0, 'Y', NULL)
         FROM DUAL
   CONNECT BY LEVEL <= 100000;

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'MOSTLY_BORING');
END;
/

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM mostly_boring
       WHERE special_flag = 'Y';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM mostly_boring
       WHERE special_flag IS NULL;

SELECT * FROM TABLE (DBMS_XPLAN.display);