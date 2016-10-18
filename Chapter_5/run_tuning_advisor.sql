VARIABLE t VARCHAR2(20)

BEGIN
   :t := DBMS_SQLTUNE.create_tuning_task (sql_id => '&SQL_ID');
   DBMS_SQLTUNE.execute_tuning_task (:t);
END;
/

SET LINES 32767 PAGES 0 TRIMSPOOL ON VERIFY OFF LONG 1000000 LONGC 1000000

SELECT DBMS_SQLTUNE.report_tuning_task (task_name => :t, TYPE => 'TEXT')
  FROM DUAL;

EXEC dbms_sqltune.drop_tuning_task(:t);
SET LINES 200