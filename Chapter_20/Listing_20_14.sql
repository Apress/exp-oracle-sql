EXEC tstats.set_temp_table_stats(p_table_name=>'PAYMENTS_TEMP');

EXPLAIN PLAN
   FOR
      SELECT *
        FROM payments_temp JOIN payments USING (payment_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM payments_temp t JOIN payments p USING (payment_id)
       WHERE t.paygrade = 10 AND t.job_description = 'INTERN';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM payments_temp t JOIN payments p USING (payment_id)
       WHERE t.paygrade != 10 AND t.payment_date > SYSDATE - 31;

SELECT * FROM TABLE (DBMS_XPLAN.display);