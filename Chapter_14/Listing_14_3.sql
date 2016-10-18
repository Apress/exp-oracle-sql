CREATE TABLE t2
AS
   SELECT d1
         ,TO_NUMBER (TO_CHAR (d1, 'yyyymmdd')) n1
         ,TO_CHAR (d1, 'yyyymmdd') c1
     FROM (SELECT TO_DATE ('31-Dec-1999') + ROWNUM d1
             FROM all_objects
            WHERE ROWNUM <= 1827);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM t2
       WHERE d1 BETWEEN TO_DATE ('30-Dec-2002', 'dd-mon-yyyy')
                    AND TO_DATE ('05-Jan-2003', 'dd-mon-yyyy');

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +ROWS'));

EXPLAIN PLAN
   FOR
      SELECT *
        FROM t2
       WHERE n1 BETWEEN 20021230 AND 20030105;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +ROWS'));