EXPLAIN PLAN
   FOR
      SELECT MEDIAN (channel_id) med_channel_id
            ,MEDIAN (sales_amount) med_sales_amount
        FROM t1;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT t1.*
            ,MEDIAN (channel_id) OVER () med_channel_id
            ,MEDIAN (sales_amount) OVER () med_sales_amount
        FROM t1;

SELECT * FROM TABLE (DBMS_XPLAN.display);