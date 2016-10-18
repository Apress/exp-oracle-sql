DECLARE
   distcnt   NUMBER;
   density   NUMBER;
   nullcnt   NUMBER;
   srec      DBMS_STATS.statrec;
   avgclen   NUMBER;
BEGIN
   DBMS_STATS.get_column_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'T3'
     ,colname   => 'C2'
     ,distcnt   => distcnt
     ,density   => density
     ,nullcnt   => nullcnt
     ,srec      => srec
     ,avgclen   => avgclen);

   DBMS_STATS.delete_column_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'T3'
     ,colname   => 'C2');

   DBMS_STATS.set_column_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'T3'
     ,colname   => 'C2'
     ,distcnt   => distcnt
     ,density   => density
     ,nullcnt   => nullcnt
     ,srec      => NULL
     ,avgclen   => avgclen);
END;
/