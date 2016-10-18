ALTER SESSION FORCE PARALLEL QUERY PARALLEL 3;

EXPLAIN PLAN FOR SELECT transaction_date,channel_id,cust_id,sales_amount,mov_median,mov_med_avg
  FROM t1
MODEL
   PARTITION BY (cust_id)
   DIMENSION BY (ROW_NUMBER () OVER (PARTITION BY cust_id ORDER BY transaction_date) rn)
   MEASURES (transaction_date, channel_id, sales_amount, 0 mov_median, 0 mov_med_avg)
   RULES
      (
      mov_median [ANY] =
            MEDIAN (sales_amount)[rn BETWEEN CV()-2 AND CV ()],
      mov_med_avg [ANY] = ROUND(AVG(mov_median) OVER (ORDER BY rn ROWS 2 PRECEDING))
)
ORDER BY cust_id,transaction_date,mov_median;

SELECT * FROM TABLE (DBMS_XPLAN.display);

SELECT transaction_date,channel_id,cust_id,sales_amount,mov_median,mov_med_avg
  FROM t1
MODEL
   PARTITION BY (cust_id)
   DIMENSION BY (ROW_NUMBER () OVER (PARTITION BY cust_id ORDER BY transaction_date) rn)
   MEASURES (transaction_date, channel_id, sales_amount, 0 mov_median, 0 mov_med_avg)
   RULES
      (
      mov_median [ANY] =
            MEDIAN (sales_amount)[rn BETWEEN CV()-2 AND CV ()],
      mov_med_avg [ANY] = ROUND(AVG(mov_median) OVER (ORDER BY rn ROWS 2 PRECEDING))
)
ORDER BY cust_id,transaction_date,mov_median;

ALTER SESSION ENABLE PARALLEL QUERY;