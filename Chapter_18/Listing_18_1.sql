CREATE TABLE t1
AS
   SELECT 1 c1, 1 c2 FROM DUAL;

CREATE UNIQUE INDEX t1_i1
   ON t1 (c1);

CREATE UNIQUE INDEX t1_i2
   ON t1 (c2);

INSERT /*+ change_dupkey_error_index(t1 (c1)) */
      INTO  t1
   SELECT 2, 1 FROM DUAL;


INSERT /*+ change_dupkey_error_index(t1 (c1)) */
      INTO  t1
   SELECT 1, 2 FROM DUAL;

INSERT /*+ ignore_row_on_dupkey_index(t1 (c1)) */
      INTO  t1
       SELECT ROWNUM + 1, 1
         FROM DUAL
   CONNECT BY LEVEL <= 3;

INSERT /*+ ignore_row_on_dupkey_index(t1 (c1)) */
      INTO  t1
       SELECT ROWNUM, ROWNUM + 1
         FROM DUAL
   CONNECT BY LEVEL <= 3;

ALTER SESSION SET query_rewrite_integrity=enforced;

  SELECT /*+ rewrite_or_error */
        t.calendar_month_desc, SUM (s.amount_sold) AS dollars
    FROM sh.sales s, sh.times t
   WHERE s.time_id = t.time_id
GROUP BY t.calendar_month_desc;