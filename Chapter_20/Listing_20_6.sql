CREATE TABLE statement_part
(
   transaction_date_time
  ,transaction_date
  ,posting_date
  ,description
  ,transaction_amount
  ,product_category
  ,customer_category
)
PARTITION BY RANGE
   (transaction_date)
   (
      PARTITION p1 VALUES LESS THAN (DATE '2013-01-05')
     ,PARTITION p2 VALUES LESS THAN (DATE '2013-01-11')
     ,PARTITION p3 VALUES LESS THAN (maxvalue))
PCTFREE 99
PCTUSED 1
AS
       SELECT   TIMESTAMP '2013-01-01 12:00:00.00 -05:00'
              + NUMTODSINTERVAL (TRUNC ( (ROWNUM - 1) / 50), 'DAY')
             ,DATE '2013-01-01' + TRUNC ( (ROWNUM - 1) / 50)
             ,DATE '2013-01-01' + TRUNC ( (ROWNUM - 1) / 50) + MOD (ROWNUM, 3)
             ,DECODE (MOD (ROWNUM, 4)
                     ,0, 'Flight'
                     ,1, 'Meal'
                     ,2, 'Taxi'
                     ,'Deliveries')
             ,DECODE (MOD (ROWNUM, 4)
                     ,0, 200 + (30 * ROWNUM)
                     ,1, 20 + ROWNUM
                     ,2, 5 + MOD (ROWNUM, 30)
                     ,8)
             ,TRUNC ( (ROWNUM - 1) / 50) + 1
             ,MOD ( (ROWNUM - 1), 50) + 1
         FROM DUAL
   CONNECT BY LEVEL <= 500;

CREATE INDEX statement_part_ix1
   ON statement_part (transaction_date)
   LOCAL
   PCTFREE 99;

BEGIN
   DBMS_STATS.delete_table_stats (
      ownname           => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname           => 'STATEMENT_PART'
     ,cascade_parts     => TRUE
     ,cascade_indexes   => TRUE
     ,cascade_columns   => TRUE);

   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,partname      => 'P1'
     ,granularity   => 'PARTITION'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1');

   DBMS_STATS.copy_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,srcpartname   => 'P1'
     ,dstpartname   => 'P2');

   DBMS_STATS.copy_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT_PART'
     ,srcpartname   => 'P1'
     ,dstpartname   => 'P3');
END;
/

SET LINES 80 PAGES 900
COLUMN PARTITION_NAME FORMAT a20

--
-- We can see that the NUM_ROWS statistic has been copied
-- from P1 to other partitions and aggregated to global stats.
--

SELECT partition_name, num_rows
  FROM all_tab_statistics
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT_PART';

--
-- The column statistics have also been copied
--
SELECT partition_name, num_distinct
  FROM all_part_col_statistics
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT_PART'
       AND column_name = 'DESCRIPTION'
UNION ALL
SELECT 'TABLE' partition_name, num_distinct
  FROM all_tab_col_statistics
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT_PART'
       AND column_name = 'DESCRIPTION';

SET LINES 200 PAGES 0

--
-- We can now get reasonable cardinality estimates from
-- queries against partition P2
--

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM statement_part PARTITION (p2)
       WHERE description = 'Flight';

SELECT * FROM TABLE (DBMS_XPLAN.display);