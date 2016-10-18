SET LINES 200 PAGES 900

BEGIN
   DBMS_STATS.set_table_prefs (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT_PART'
     ,pname     => 'PUBLISH'
     ,pvalue    => 'TRUE');
END;
/

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,partname      => NULL
     ,granularity   => 'GLOBAL'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1'
     ,cascade       => FALSE);
END;
/

BEGIN
   DBMS_STATS.set_table_prefs (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT_PART'
     ,pname     => 'PUBLISH'
     ,pvalue    => 'FALSE');
END;
/

DECLARE
   srec   DBMS_STATS.statrec;
BEGIN
   FOR r
      IN (SELECT *
            FROM all_tab_cols
           WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
                 AND table_name = 'STATEMENT_PART'
                 AND column_name = 'TRANSACTION_AMOUNT')
   LOOP
      srec.epc := 3;
      srec.bkvals := DBMS_STATS.numarray (600, 400, 600);
      DBMS_STATS.prepare_column_values (srec
                                       ,DBMS_STATS.numarray (-1e7, 8, 1e7));
      DBMS_STATS.set_column_stats (ownname   => r.owner
                                  ,tabname   => r.table_name
                                  ,colname   => r.column_name
                                  ,distcnt   => 3
                                  ,density   => 1 / 250
                                  ,nullcnt   => 0
                                  ,srec      => srec
                                  ,avgclen   => r.avg_col_len);
   END LOOP;
END;
/

SET AUTOTRACE OFF

SELECT endpoint_number, endpoint_value
  FROM all_tab_histograms
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT_PART'
       AND column_name = 'TRANSACTION_AMOUNT';

SELECT endpoint_number, endpoint_value
  FROM all_tab_histgrm_pending_stats
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT_PART'
       AND column_name = 'TRANSACTION_AMOUNT';

SET AUTOTRACE TRACEONLY EXPLAIN

SELECT *
  FROM statement_part
 WHERE transaction_amount = 8;

ALTER SESSION SET optimizer_use_pending_statistics=TRUE;

SELECT *
  FROM statement_part
 WHERE transaction_amount = 8;

BEGIN
   DBMS_STATS.publish_pending_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT_PART');
END;
/

ALTER SESSION SET optimizer_use_pending_statistics=FALSE;

SELECT *
  FROM statement_part
 WHERE transaction_amount = 8;

SET AUTOTRACE OFF

SELECT endpoint_number, endpoint_value
  FROM all_tab_histograms
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT_PART'
       AND column_name = 'TRANSACTION_AMOUNT';

SELECT endpoint_number, endpoint_value
  FROM all_tab_histgrm_pending_stats
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT_PART'
       AND column_name = 'TRANSACTION_AMOUNT';