SET LINES 2000 PAGES 0

CREATE TABLE t3
(
   c1
  ,c2
  ,c3
)
PCTFREE 99
PCTUSED 1
AS
       SELECT ROWNUM, DATE '2012-04-01' + MOD (ROWNUM, 2), RPAD ('X', 2000) c3
         FROM DUAL
   CONNECT BY LEVEL <= 1000;

CREATE INDEX t3_i1
   ON t3 (c2);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM t3
       WHERE t3.c2 = TO_DATE ( :b1, 'DD-MON-YYYY');

SELECT * FROM TABLE (DBMS_XPLAN.display);

VARIABLE b1 VARCHAR2(11)
EXEC :b1 := '01-APR-2012';

BEGIN
   FOR r IN (SELECT *
               FROM t3
              WHERE t3.c2 = TO_DATE ( :b1, 'DD-MON-YYYY'))
   LOOP
      NULL;
   END LOOP;
END;
/

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (sql_id => 'dgcvn46zatdqr'));