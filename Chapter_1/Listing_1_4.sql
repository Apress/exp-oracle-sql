SET SERVEROUT ON

DECLARE
   PROCEDURE check_sql_id (p_literal VARCHAR2)
   IS
      dummy_variable   VARCHAR2 (100);
      sql_id           v$session.sql_id%TYPE;
   BEGIN
      SELECT p_literal INTO dummy_variable FROM DUAL;

      SELECT prev_sql_id
        INTO sql_id
        FROM v$session
       WHERE sid = SYS_CONTEXT ('USERENV', 'SID');

      DBMS_OUTPUT.put_line (sql_id);
   END check_sql_id;

BEGIN
   check_sql_id ('LITERAL 1');
   check_sql_id ('LITERAL 2');
END;
/
