CREATE TABLE statement
(
   transaction_date_time   TIMESTAMP WITH TIME ZONE
  ,transaction_date        DATE
  ,posting_date            DATE
  ,posting_delay           AS (posting_date - transaction_date)
  ,description             VARCHAR2 (30)
  ,transaction_amount      NUMBER
  ,amount_category         AS (CASE WHEN transaction_amount < 10 THEN 'LOW' WHEN transaction_amount < 100 THEN 'MEDIUM' ELSE 'HIGH' END)
  ,product_category        NUMBER
  ,customer_category       NUMBER
)
PCTFREE 80
PCTUSED 10;

INSERT INTO statement (transaction_date_time
                      ,transaction_date
                      ,posting_date
                      ,description
                      ,transaction_amount
                      ,product_category
                      ,customer_category)
       SELECT   TIMESTAMP '2013-01-01 12:00:00.00 -05:00'
              + NUMTODSINTERVAL (TRUNC ( (ROWNUM - 1) / 50), 'DAY')
             ,DATE '2013-01-01' + TRUNC ( (ROWNUM - 1) / 50)
             ,DATE '2013-01-01' + TRUNC ( (ROWNUM - 1) / 50) + MOD (ROWNUM, 3)
                 posting_date
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

CREATE INDEX statement_i_tran_dt
   ON statement (transaction_date_time);

CREATE INDEX statement_i_pc
   ON statement (product_category);

CREATE INDEX statement_i_cc
   ON statement (customer_category);

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname       => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname       => 'STATEMENT'
     ,partname      => NULL
     ,granularity   => 'ALL'
     ,method_opt    => 'FOR ALL COLUMNS SIZE 1'
     ,cascade       => FALSE);
END;
/


BEGIN
   DBMS_STATS.create_stat_table (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,stattab   => 'CH9_STATS');

   DBMS_STATS.export_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT'
     ,statown   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,stattab   => 'CH9_STATS');
END;
/

-- Move to target system

BEGIN
   DBMS_STATS.delete_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT');

   DBMS_STATS.import_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'STATEMENT'
     ,statown   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,stattab   => 'CH9_STATS');
END;
/