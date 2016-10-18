SELECT sys.dbms_sqltune_util0.sqltext_to_sqlid (
          q'[SELECT 'LITERAL 1' FROM DUAL]' || CHR (0)) sql_id
  FROM DUAL;