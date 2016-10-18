BEGIN 
   DBMS_STATS.reset_col_usage (ownname => 'SH', tabname => NULL); -- Optional

   DBMS_STATS.seed_col_usage (NULL, NULL, 3600);
END;
/

--- Wait a little over an hour
PAUSE

DECLARE
   dummy   CLOB;
BEGIN
   FOR r
      IN (SELECT DISTINCT object_name
            FROM dba_objects, sys.col_group_usage$
           WHERE obj# = object_id AND owner = 'SH' AND object_type = 'TABLE')
   LOOP
      SELECT DBMS_STATS.create_extended_stats ('SH', r.object_name)
        INTO dummy
        FROM DUAL;
   END LOOP;
END;
/