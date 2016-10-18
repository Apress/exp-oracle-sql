SET PAGES 0 LINES 200 SERVEROUT OFF

DECLARE
   extension_name     all_stat_extensions.extension_name%TYPE;
   extension_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (extension_exists, -20007);
BEGIN
   extension_name :=
      DBMS_STATS.create_extended_stats (
         ownname     => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
        ,tabname     => 'PAYMENTS'
        ,extension   => '(PAYGRADE,PAYMENT_DATE)');
EXCEPTION
   WHEN extension_exists
   THEN
      NULL;
END;
/

EXEC tstats.amend_time_based_statistics(date '2014-05-01');

ALTER SESSION SET statistics_level='ALL';

SELECT COUNT (*)
  FROM payments
 WHERE paygrade = 1 AND payment_date = DATE '2014-04-30';


SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC IOSTATS LAST'));

SELECT COUNT (*)
  FROM payments
 WHERE paygrade = 10 AND payment_date = DATE '2014-04-18';

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC IOSTATS LAST'));

SELECT COUNT (*)
  FROM payments
 WHERE paygrade = 4 AND payment_date = DATE '2014-04-18';

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC IOSTATS LAST'));

SELECT COUNT (*)
  FROM payments
 WHERE paygrade = 8 AND job_description = 'JUNIOR TECHNICIAN';

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC IOSTATS LAST'));

SELECT COUNT (*)
  FROM payments
 WHERE employee_id = 101;

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC IOSTATS LAST'));

EXEC tstats.amend_time_based_statistics(date '2015-05-01');

SELECT COUNT (*)
  FROM payments
 WHERE paygrade = 1 AND payment_date = DATE '2015-04-30';

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC +ROWS'));

SELECT COUNT (*)
  FROM payments
 WHERE paygrade = 10 AND payment_date = DATE '2015-04-20';

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC +ROWS'));

SELECT COUNT (*)
  FROM payments
 WHERE paygrade = 4 AND payment_date = DATE '2015-04-20';

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC +ROWS'));

SELECT COUNT (*)
  FROM payments
 WHERE paygrade = 8 AND job_description = 'JUNIOR TECHNICIAN';

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC +ROWS'));

SELECT COUNT (*)
  FROM payments
 WHERE employee_id = 101;

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC +ROWS'));