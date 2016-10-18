EXPLAIN PLAN
   FOR
        SELECT cust_id
              ,COUNT (*) tran_count
              ,SUM (sales_amount) total_sales
              ,100 * SUM (sales_amount) / SUM (SUM (sales_amount)) OVER ()
                  pct_revenue1
              ,100 * ratio_to_report (SUM (sales_amount)) OVER () pct_revenue2
          FROM t1
      GROUP BY cust_id;


SELECT * FROM TABLE (DBMS_XPLAN.display);

  SELECT cust_id
        ,COUNT (*) tran_count
        ,SUM (sales_amount) total_sales
        ,100 * SUM (sales_amount) / SUM (SUM (sales_amount)) OVER ()
            pct_revenue1
        ,100 * ratio_to_report (SUM (sales_amount)) OVER () pct_revenue2
    FROM t1
GROUP BY cust_id;