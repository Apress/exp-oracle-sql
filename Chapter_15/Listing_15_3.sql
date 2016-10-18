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

CREATE TABLE statement_part_ch15
PARTITION BY RANGE
   (transaction_date)
   (
      PARTITION p1 VALUES LESS THAN (DATE '2013-01-05')
     ,PARTITION p2 VALUES LESS THAN (DATE '2013-01-11')
     ,PARTITION p3 VALUES LESS THAN (DATE '2013-01-12')
     ,PARTITION p4 VALUES LESS THAN (maxvalue))
AS
   SELECT transaction_date_time
         ,transaction_date
         ,posting_date
         ,description
         ,transaction_amount
         ,product_category
         ,customer_category
     FROM statement;


CREATE BITMAP INDEX statement_part_pc_bix
   ON statement_part_ch15 (product_category)
   LOCAL;

CREATE BITMAP INDEX statement_part_cc_bix
   ON statement_part_ch15 (customer_category)
   LOCAL;

ALTER TABLE statement_part_ch15 MODIFY PARTITION FOR (DATE '2013-01-11') UNUSABLE LOCAL INDEXES;

INSERT INTO statement_part_ch15 (transaction_date_time
                                ,transaction_date
                                ,posting_date
                                ,description
                                ,transaction_amount
                                ,product_category
                                ,customer_category)
   SELECT DATE '2013-01-11'
         ,DATE '2013-01-11'
         ,DATE '2013-01-11'
         ,description
         ,transaction_amount
         ,product_category
         ,customer_category
     FROM statement;

ALTER TABLE statement_part_ch15 MODIFY PARTITION FOR (DATE '2013-01-11')
            REBUILD UNUSABLE LOCAL INDEXES;