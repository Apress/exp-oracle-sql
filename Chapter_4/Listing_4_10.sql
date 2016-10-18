CREATE TABLE business_dates
(
   location        VARCHAR2 (20)
  ,business_date   DATE
);

INSERT INTO business_dates (location, business_date)
     VALUES ('Americas', DATE '2013-06-03');

INSERT INTO business_dates (location, business_date)
     VALUES ('Europe', DATE '2013-06-04');

INSERT INTO business_dates (location, business_date)
     VALUES ('Asia', DATE '2013-06-04');

CREATE OR REPLACE FUNCTION get_business_date (p_location VARCHAR2)
   RETURN DATE
   DETERMINISTIC
   RESULT_CACHE
IS
   v_date   DATE;
   dummy    PLS_INTEGER;
BEGIN
   DBMS_LOCK.sleep (5);

   SELECT business_date
     INTO v_date
     FROM business_dates
    WHERE location = p_location;

   RETURN v_date;
END get_business_date;
/

CREATE TABLE transactions
AS
       SELECT ROWNUM rn
             ,DECODE (MOD (ROWNUM - 1, 3),  0, 'Americas',  1, 'Europe',  'Asia')
                 location
             ,DECODE (MOD (ROWNUM - 1, 2)
                     ,0, DATE '2013-06-03'
                     ,DATE '2013-06-04')
                 transaction_date
         FROM DUAL
   CONNECT BY LEVEL <= 20;

SET TIMING ON

SELECT *
  FROM transactions
 WHERE transaction_date = get_business_date (location);

SET TIMING OFF