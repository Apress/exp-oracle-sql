SET LINES 200 PAGES 900

COLUMN c1 FORMAT a20
COLUMN cl1 FORMAT a30
COLUMN extension_name FORMAT a50

TRUNCATE TABLE ch9_stats;

BEGIN
   DBMS_STATS.export_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT'
     ,statown   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,stattab   => 'CH9_STATS');

   DBMS_STATS.drop_extended_stats (
      ownname     => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname     => 'STATEMENT'
     ,extension   => '(TRANSACTION_DATE,POSTING_DATE)');

   DBMS_STATS.drop_extended_stats (
      ownname     => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname     => 'STATEMENT'
     ,extension   => q'[(CASE WHEN DESCRIPTION <> 'Flight'
                                      AND TRANSACTION_AMOUNT > 100
                                 THEN 'HIGH' END)]');

   DBMS_STATS.delete_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT');
END;
/

SELECT c1, SUBSTR (c4, 1, 10) c4, DBMS_LOB.SUBSTR (cl1, 60, 1) cl1
  FROM ch9_stats
 WHERE TYPE = 'E';

  SELECT extension_name
    FROM all_stat_extensions
   WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
         AND table_name = 'STATEMENT'
ORDER BY extension_name;

BEGIN
   DBMS_STATS.import_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT'
     ,statown   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,stattab   => 'CH9_STATS');
END;
/

  SELECT extension_name
    FROM all_stat_extensions
   WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
         AND table_name = 'STATEMENT'
ORDER BY extension_name;