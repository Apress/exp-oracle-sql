CREATE TABLE process_status
(
   process_id                 INTEGER PRIMARY KEY
  ,status                     INTEGER
  ,last_job_id                INTEGER
  ,last_job_completion_time   DATE
  ,filler_1                   CHAR (100) DEFAULT RPAD (' ', 100)
)
PCTFREE 99
PCTUSED 1;

INSERT INTO process_status (process_id)
       SELECT ROWNUM
         FROM DUAL
   CONNECT BY LEVEL <= 50;

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'PROCESS_STATUS');
END;
/

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      UPDATE process_status
         SET status = 1, last_job_id = 1, last_job_completion_time = SYSDATE
       WHERE process_id = 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);