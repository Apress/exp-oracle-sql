CREATE TABLE date_table
(
   mydate     DATE
  ,filler_1   CHAR (2000)
)
PCTFREE 0;

INSERT INTO date_table (mydate, filler_1)
       SELECT SYSDATE, RPAD ('x', 2000)
         FROM DUAL
   CONNECT BY LEVEL <= 1000;

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'DATE_TABLE');
END;
/

CREATE INDEX date_index
   ON date_table (mydate);

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT mydate
        FROM date_table
       WHERE mydate = SYSTIMESTAMP;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT mydate
        FROM date_table
       WHERE mydate = SYSDATE;

SELECT * FROM TABLE (DBMS_XPLAN.display);