CREATE OR REPLACE PACKAGE tstats
AS
   PROCEDURE adjust_column_stats_v1 (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE);

   PROCEDURE adjust_column_stats_v2 (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE);

   PROCEDURE amend_time_based_statistics (
      effective_date    DATE DEFAULT SYSDATE);

   PROCEDURE adjust_global_stats (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE
     ,p_mode          VARCHAR2 DEFAULT 'PMOP');

   PROCEDURE gather_table_stats (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE);

   PROCEDURE set_temp_table_stats (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE
     ,p_numrows       INTEGER DEFAULT 20000
     ,p_numblks       INTEGER DEFAULT 1000
     ,p_avgrlen       INTEGER DEFAULT 400);

   PROCEDURE import_table_stats (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE
     ,p_statown       all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_stat_table    all_tab_col_statistics.table_name%TYPE);
END tstats;
/