BEGIN
   DBMS_STATS.transfer_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT'
     ,dblink    => 'DBLINK_NAME');
END;
/
