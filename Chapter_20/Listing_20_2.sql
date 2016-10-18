CREATE TABLE payments
(
   payment_id        INTEGER
  ,employee_id       INTEGER
  ,special_flag      CHAR (1)
  ,paygrade          INTEGER
  ,payment_date      DATE
  ,job_description   VARCHAR2 (50)
)
PCTFREE 0;

INSERT INTO payments (payment_id
                     ,employee_id
                     ,special_flag
                     ,paygrade
                     ,payment_date
                     ,job_description)
   WITH standard_payment_dates
        AS (    SELECT ADD_MONTHS (DATE '2014-01-20', ROWNUM - 1)
                          standard_paydate
                      ,LAST_DAY (ADD_MONTHS (DATE '2014-01-20', ROWNUM - 1))
                          last_day_month
                  FROM DUAL
            CONNECT BY LEVEL <= 12)
       ,employees
        AS (    SELECT ROWNUM employee_id, TRUNC (LOG (2.6, ROWNUM)) + 1 paygrade
                  FROM DUAL
            CONNECT BY LEVEL <= 10000)
       ,q1
        AS (SELECT ROWNUM payment_id
                  ,employee_id
                  ,DECODE (MOD (ROWNUM, 100), 0, 'Y', NULL) special_flag
                  ,paygrade
                  --
                  -- The calculation in the next few lines to determine what day of the week
                  -- the 20th of the month falls on does not use the TO_CHAR function
                  -- as the results of this function depend on NLS settings!
                  --
                  ,CASE
                      WHEN MOD (ROWNUM, 100) = 0
                      THEN
                         standard_paydate + MOD (ROWNUM, 7)
                      WHEN     paygrade = 1
                           AND MOD (last_day_month - DATE '1001-01-06', 7) =
                                  5
                      THEN
                         last_day_month - 1
                      WHEN     paygrade = 1
                           AND MOD (last_day_month - DATE '1001-01-06', 7) =
                                  6
                      THEN
                         last_day_month - 2
                      WHEN paygrade = 1
                      THEN
                         last_day_month
                      WHEN MOD (standard_paydate - DATE '1001-01-06', 7) = 5
                      THEN
                         standard_paydate - 1
                      WHEN MOD (standard_paydate - DATE '1001-01-06', 7) = 6
                      THEN
                         standard_paydate - 2
                      ELSE
                         standard_paydate
                   END
                      paydate
                  ,DECODE (
                      paygrade
                     ,1, 'SENIOR EXECUTIVE'
                     ,2, 'JUNIOR EXECUTIVE'
                     ,3, 'SENIOR DEPARTMENT HEAD'
                     ,4, 'JUNIOR DEPARTMENT HEAD'
                     ,5, 'SENIOR MANAGER'
                     ,6, DECODE (MOD (ROWNUM, 3)
                                ,0, 'JUNIOR MANAGER'
                                ,1, 'SENIOR TECHNICIAN'
                                ,'SENIOR SUPERVISOR')
                     ,7, DECODE (MOD (ROWNUM, 2)
                                ,0, 'SENIOR TECHNICIAN'
                                ,'SENIOR SUPERVISOR')
                     ,8, DECODE (MOD (ROWNUM, 2)
                                ,0, 'JUNIOR TECHNICIAN'
                                ,'JUNIOR SUPERVISOR')
                     ,9, 'ANCILLORY STAFF'
                     ,10, DECODE (MOD (ROWNUM, 2)
                                 ,0, 'INTERN'
                                 ,'CASUAL WORKER'))
                      job_description
              FROM standard_payment_dates, employees)
     SELECT *
       FROM q1
   ORDER BY paydate;

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname      => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname      => 'PAYMENTS'
     ,method_opt   => 'FOR ALL COLUMNS SIZE 1');
END;
/

CREATE UNIQUE INDEX payments_pk
   ON payments (payment_id);

ALTER TABLE payments
   ADD  CONSTRAINT payments_pk PRIMARY KEY (payment_id);

CREATE INDEX payments_ix1
   ON payments (paygrade, job_description);

SET PAGES 0 LINES 200

EXPLAIN PLAN
   FOR
      SELECT *
        FROM payments
       WHERE special_flag = 'Y';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXEC tstats.adjust_column_stats_v1(p_table_name=>'PAYMENTS');

EXPLAIN PLAN
   FOR
      SELECT *
        FROM payments
       WHERE special_flag = 'Y';

SELECT * FROM TABLE (DBMS_XPLAN.display);