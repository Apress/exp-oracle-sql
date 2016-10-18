CREATE OR REPLACE PACKAGE BODY tstats
AS
   FUNCTION get_srec
      RETURN DBMS_STATS.statrec
   IS
      srec   DBMS_STATS.statrec;
   BEGIN
      /*

      Workaround for issue in 12.1.0.1
      that produces wrong join cardinality
      when both tables have NULL for high
      and low values.  As a workaround this
      function sets the high value very high
      and the low value very low.
      */
      $IF DBMS_DB_VERSION.version >= 12
      $THEN
         srec.epc := 2; -- Two endpoints
         srec.bkvals := NULL; -- No histogram
         DBMS_STATS.prepare_column_values (
            srec
           ,DBMS_STATS.rawarray (
               HEXTORAW (
                  -- Min
                  '0000000000000000000000000000000000000000000000000000000000000000')
              -- Max
              ,HEXTORAW (
                  'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff')));
         RETURN srec;
      $ELSE
         RETURN NULL;
      $END
   END get_srec;

   PROCEDURE adjust_column_stats_v1 (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE)
   AS
      CURSOR c1
      IS
         SELECT *
           FROM all_tab_col_statistics
          WHERE     owner = p_owner
                AND table_name = p_table_name
                AND last_analyzed IS NOT NULL;
   BEGIN
      FOR r IN c1
      LOOP
         DBMS_STATS.delete_column_stats (ownname         => r.owner
                                        ,tabname         => r.table_name
                                        ,colname         => r.column_name
                                        ,cascade_parts   => TRUE
                                        ,no_invalidate   => TRUE
                                        ,force           => TRUE);
         DBMS_STATS.set_column_stats (ownname         => r.owner
                                     ,tabname         => r.table_name
                                     ,colname         => r.column_name
                                     ,distcnt         => r.num_distinct
                                     ,density         => r.density
                                     ,nullcnt         => r.num_nulls
                                     ,srec            => get_srec -- No HIGH_VALUE/LOW_VALUE
                                     ,avgclen         => r.avg_col_len
                                     ,no_invalidate   => FALSE
                                     ,force           => TRUE);
      END LOOP;
   END adjust_column_stats_v1;

   PROCEDURE adjust_column_stats_v2 (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE)
   AS
      CURSOR c1
      IS
         SELECT *
           FROM all_tab_col_statistics
          WHERE     owner = p_owner
                AND table_name = p_table_name
                AND last_analyzed IS NOT NULL;

      v_num_distinct   all_tab_col_statistics.num_distinct%TYPE;
   BEGIN
      FOR r IN c1
      LOOP
         DBMS_STATS.delete_column_stats (ownname         => r.owner
                                        ,tabname         => r.table_name
                                        ,colname         => r.column_name
                                        ,cascade_parts   => TRUE
                                        ,no_invalidate   => TRUE
                                        ,force           => TRUE);

         IF r.num_distinct = 1
         THEN
            v_num_distinct := 1 + 1e-14;
         ELSE
            v_num_distinct := r.num_distinct;
         END IF;

         DBMS_STATS.set_column_stats (ownname         => r.owner
                                     ,tabname         => r.table_name
                                     ,colname         => r.column_name
                                     ,distcnt         => v_num_distinct
                                     ,density         => 1 / v_num_distinct
                                     ,nullcnt         => r.num_nulls
                                     ,srec            => get_srec -- No HIGH_VALUE/LOW_VALUE
                                     ,avgclen         => r.avg_col_len
                                     ,no_invalidate   => FALSE
                                     ,force           => TRUE);
      END LOOP;
   END adjust_column_stats_v2;

   PROCEDURE amend_time_based_statistics (
      effective_date    DATE DEFAULT SYSDATE)
   IS
      distcnt   NUMBER;
      density   NUMBER;
      nullcnt   NUMBER;
      srec      DBMS_STATS.statrec;

      avgclen   NUMBER;
   BEGIN
      --
      -- Step 1: Remove data from previous run
      --
      DELETE FROM sample_payments;

      --
      -- Step 2:  Add data for standard pay for standard employees
      --
      INSERT INTO sample_payments (paygrade, payment_date, job_description)
         WITH payment_dates
              AS (    SELECT ADD_MONTHS (TRUNC (effective_date, 'MM') + 19
                                        ,1 - ROWNUM)
                                standard_paydate
                        FROM DUAL
                  CONNECT BY LEVEL <= 12)
             ,paygrades
              AS (    SELECT ROWNUM + 1 paygrade
                        FROM DUAL
                  CONNECT BY LEVEL <= 9)
             ,multiplier
              AS (    SELECT ROWNUM rid
                        FROM DUAL
                  CONNECT BY LEVEL <= 100)
         SELECT paygrade
               ,CASE MOD (standard_paydate - DATE '1001-01-06', 7)
                   WHEN 5 THEN standard_paydate - 1
                   WHEN 6 THEN standard_paydate - 2
                   ELSE standard_paydate
                END
                   payment_date
               ,'AAA' job_description
           FROM paygrades, payment_dates, multiplier;

      --
      -- Step 3:  Add data for paygrade 1
      --
      INSERT INTO sample_payments (paygrade, payment_date, job_description)
         WITH payment_dates
              AS (    SELECT ADD_MONTHS (LAST_DAY (TRUNC (effective_date))
                                        ,1 - ROWNUM)
                                standard_paydate
                        FROM DUAL
                  CONNECT BY LEVEL <= 12)
         SELECT 1 paygrade
               ,CASE MOD (standard_paydate - DATE '1001-01-06', 7)
                   WHEN 5 THEN standard_paydate - 1
                   WHEN 6 THEN standard_paydate - 2
                   ELSE standard_paydate
                END
                   payment_dates
               ,'zzz' job_description
           FROM payment_dates;

      --
      -- Step 4:  Add rows for exceptions.
      --
      INSERT INTO sample_payments (paygrade, payment_date, job_description)
         WITH payment_dates
              AS (    SELECT ADD_MONTHS (TRUNC (effective_date, 'MM') + 19
                                        ,1 - ROWNUM)
                                standard_paydate
                        FROM DUAL
                  CONNECT BY LEVEL <= 12)
             ,paygrades
              AS (    SELECT ROWNUM + 1 paygrade
                        FROM DUAL
                  CONNECT BY LEVEL <= 7)
         SELECT paygrade
               ,CASE MOD (standard_paydate - DATE '1001-01-06', 7)
                   WHEN 5 THEN standard_paydate - 2 + paygrade
                   WHEN 6 THEN standard_paydate - 3 + paygrade
                   ELSE standard_paydate - 1 + paygrade
                END
                   payment_date
               ,'AAA' job_description
           FROM paygrades, payment_dates;

      --
      -- Step 5:  Gather statistics for SAMPLE_PAYMENTS
      --
      DBMS_STATS.gather_table_stats (
         ownname      => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
        ,tabname      => 'SAMPLE_PAYMENTS'
        ,method_opt   =>    'FOR COLUMNS SIZE 1 JOB_DESCRIPTION '
                         || 'FOR COLUMNS SIZE 254 PAYGRADE,PAYMENT_DATE, '
                         || '(PAYGRADE,PAYMENT_DATE)');

      --
      -- Step 6:  Copy column statistics from SAMPLE_PAYMENTS to PAYMENTS
      --
      FOR r IN (SELECT column_name, histogram
                  FROM all_tab_cols
                 WHERE table_name = 'SAMPLE_PAYMENTS')
      LOOP
         DBMS_STATS.get_column_stats (
            ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
           ,tabname   => 'SAMPLE_PAYMENTS'
           ,colname   => r.column_name
           ,distcnt   => distcnt
           ,density   => density
           ,nullcnt   => nullcnt
           ,srec      => srec
           ,avgclen   => avgclen);


         DBMS_STATS.set_column_stats (
            ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
           ,tabname   => 'PAYMENTS'
           ,colname   => r.column_name
           ,distcnt   => distcnt
           ,density   => density
           ,nullcnt   => nullcnt
           ,srec      => srec
           ,avgclen   => avgclen);
      END LOOP;
   END amend_time_based_statistics;

   PROCEDURE adjust_global_stats (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE
     ,p_mode          VARCHAR2 DEFAULT 'PMOP')
   IS
      -- This helper function updates the statistic for the number of blocks in the
      -- table so that the average size of a partition is unaltered.  We sneak
      -- this value away in the unused CACHEDBLK statistic
      --
      numblks     NUMBER;
      numrows     NUMBER;
      avgrlen     NUMBER;
      cachedblk   NUMBER;
      cachehit    NUMBER;
   BEGIN
      DBMS_STATS.get_table_stats (ownname     => p_owner
                                 ,tabname     => p_table_name
                                 ,numrows     => numrows
                                 ,avgrlen     => avgrlen
                                 ,numblks     => numblks
                                 ,cachedblk   => cachedblk
                                 ,cachehit    => cachehit);

      IF p_mode = 'PMOP'
      THEN
         --
         -- Resetting NUMBLKS based on CACHEDBLK
         -- average segment size and current number
         -- of partitions.
         --
         IF cachedblk IS NULL
         THEN
            RETURN; -- No saved value
         END IF;

         --
         -- Recalculate the number of blocks based on
         -- the current number of partitions and the
         -- saved average segment size
         -- Avoid reference to DBA_SEGMENTS in case
         -- there is no privilege.
         --
         SELECT cachedblk * COUNT (*)
           INTO numblks
           FROM all_objects
          WHERE     owner = p_owner
                AND object_name = p_table_name
                AND object_type = 'TABLE PARTITION';
      ELSIF p_mode = 'GATHER'
      THEN
         --
         -- Save average segment size in CACHEDBLK based on NUMBLKS
         -- and current number of partitions.
         --
         SELECT numblks / COUNT (*), TRUNC (numblks / COUNT (*)) * COUNT (*)
           INTO cachedblk, numblks
           FROM all_objects
          WHERE     owner = p_owner
                AND object_name = p_table_name
                AND object_type = 'TABLE PARTITION';
      ELSE
         RAISE PROGRAM_ERROR;
      -- Only gets here if p_mode not set to PMOP or GATHER
      END IF;

      DBMS_STATS.set_table_stats (ownname     => p_owner
                                 ,tabname     => p_table_name
                                 ,numblks     => numblks
                                 ,cachedblk   => cachedblk
                                 ,force       => TRUE);
   END adjust_global_stats;

   PROCEDURE gather_table_stats (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE)
   IS
   BEGIN
      DBMS_STATS.unlock_table_stats (ownname   => p_owner
                                    ,tabname   => p_table_name);

      FOR r IN (SELECT *
                  FROM all_tables
                 WHERE owner = p_owner AND table_name = p_table_name)
      LOOP
         DBMS_STATS.gather_table_stats (
            ownname       => p_owner
           ,tabname       => p_table_name
           ,granularity   => CASE r.partitioned
                               WHEN 'YES' THEN 'GLOBAL'
                               ELSE 'ALL'
                            END
           ,method_opt    => 'FOR ALL COLUMNS SIZE 1');

         adjust_column_stats_v2 (p_owner        => p_owner
                                ,p_table_name   => p_table_name);

         IF r.partitioned = 'YES'
         THEN
            adjust_global_stats (p_owner        => p_owner
                                ,p_table_name   => p_table_name
                                ,p_mode         => 'GATHER');
         END IF;
      END LOOP;

      DBMS_STATS.lock_table_stats (ownname => p_owner, tabname => p_table_name);
   END gather_table_stats;

   PROCEDURE set_temp_table_stats (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE
     ,p_numrows       INTEGER DEFAULT 20000
     ,p_numblks       INTEGER DEFAULT 1000
     ,p_avgrlen       INTEGER DEFAULT 400)
   IS
      distcnt   NUMBER;
   BEGIN
      DBMS_STATS.unlock_table_stats (ownname   => p_owner
                                    ,tabname   => p_table_name);
      $IF DBMS_DB_VERSION.version >= 12
      $THEN
         DBMS_STATS.set_table_prefs (ownname   => p_owner
                                    ,tabname   => p_table_name
                                    ,pname     => 'GLOBAL_TEMP_TABLE_STATS'
                                    ,pvalue    => 'SHARED');
      $END
      DBMS_STATS.delete_table_stats (ownname   => p_owner
                                    ,tabname   => p_table_name);
      DBMS_STATS.set_table_stats (ownname         => p_owner
                                 ,tabname         => p_table_name
                                 ,numrows         => p_numrows
                                 ,numblks         => p_numblks
                                 ,avgrlen         => p_avgrlen
                                 ,no_invalidate   => FALSE);
      /*

      We must now set column statistics to limit the effect of predicates on cardinality
      calculations; by default cardinality is reduced by a factor of 100 for each predicate.

      We use a value of 2 for the number of distinct columns to reduce this factor to 2.  We
      do no not use 1 because predicates of the type "column_1 <> 'VALUE_1'" would reduce the
      cardinality to 1.

      */
      distcnt := 2;

      FOR r IN (SELECT *
                  FROM all_tab_columns
                 WHERE owner = p_owner AND table_name = p_table_name)
      LOOP
         DBMS_STATS.set_column_stats (ownname         => p_owner
                                     ,tabname         => r.table_name
                                     ,colname         => r.column_name
                                     ,distcnt         => distcnt
                                     ,density         => 1 / distcnt
                                     ,avgclen         => 5
                                     ,srec            => get_srec
                                     ,no_invalidate   => FALSE);
      END LOOP;

      DBMS_STATS.lock_table_stats (ownname => p_owner, tabname => p_table_name);
   END set_temp_table_stats;

   PROCEDURE import_table_stats (
      p_owner         all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_table_name    all_tab_col_statistics.table_name%TYPE
     ,p_statown       all_tab_col_statistics.owner%TYPE DEFAULT SYS_CONTEXT (
                                                                   'USERENV'
                                                                  ,'CURRENT_SCHEMA')
     ,p_stat_table    all_tab_col_statistics.table_name%TYPE)
   IS
   BEGIN
      DECLARE
         already_up_to_date   EXCEPTION;
         PRAGMA EXCEPTION_INIT (already_up_to_date, -20000);
      BEGIN
         DBMS_STATS.upgrade_stat_table (ownname   => 'DLS'
                                       ,stattab   => 'DLS_TSTATS');
      EXCEPTION
         WHEN already_up_to_date
         THEN
            NULL;
      END;

      DBMS_STATS.unlock_table_stats (ownname   => p_owner
                                    ,tabname   => p_table_name);
      DBMS_STATS.delete_table_stats (ownname         => p_owner
                                    ,tabname         => p_table_name
                                    ,no_invalidate   => FALSE);
      DBMS_STATS.import_table_stats (ownname         => p_owner
                                    ,tabname         => p_table_name
                                    ,statown         => p_statown
                                    ,stattab         => p_stat_table
                                    ,no_invalidate   => FALSE);

      -- For partitioned tables it may be that the number of (sub)partitions on
      -- the target systems do not match those on the source system.
      FOR r
         IN (SELECT *
               FROM all_tables
              WHERE     owner = p_owner
                    AND table_name = p_table_name
                    AND partitioned = 'YES')
      LOOP
         adjust_global_stats (p_owner, p_table_name, 'PMOP');
      END LOOP;

      DBMS_STATS.lock_table_stats (ownname => p_owner, tabname => p_table_name);
   END import_table_stats;
END tstats;
/