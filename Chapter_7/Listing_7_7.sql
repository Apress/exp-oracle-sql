EXPLAIN PLAN
   FOR
      SELECT t1.*, COUNT (sales_amount) OVER (PARTITION BY channel_id) CNT
        FROM t1;

SELECT * FROM TABLE (DBMS_XPLAN.display);