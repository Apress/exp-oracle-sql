CREATE TABLE t1
AS
       SELECT DATE '2013-12-31' + ROWNUM transaction_date
             ,MOD (ROWNUM, 4) + 1 channel_id
             ,MOD (ROWNUM, 5) + 1 cust_id
             ,DECODE (ROWNUM
                     ,1, 4
                     ,ROWNUM * ROWNUM + DECODE (MOD (ROWNUM, 7), 3, 3000, 0))
                 sales_amount
         FROM DUAL
   CONNECT BY LEVEL <= 100;

-- No Aggregation in next query

SELECT * FROM t1;

--Exactly one row returned in next query

SELECT COUNT (*) cnt FROM t1;

-- 0 or more rows returned in next query

  SELECT channel_id
    FROM t1
GROUP BY channel_id;

-- At most one row returned in next query

SELECT 1 non_empty_flag
  FROM t1
HAVING COUNT (*) > 0;

-- 0 or more rows returned in next query

  SELECT channel_id, COUNT (*) cnt
    FROM t1
GROUP BY channel_id
  HAVING COUNT (*) < 2;