SET SERVEROUT OFF

BEGIN
   DBMS_RESULT_CACHE.flush;
END;
/

ALTER SESSION SET result_cache_mode=force;

SELECT COUNT (*) FROM scott.emp;

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (format => 'ALLSTATS LAST'));

SELECT COUNT (*) FROM scott.emp;

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (format => 'ALLSTATS LAST'));

ALTER SESSION SET result_cache_mode=manual;