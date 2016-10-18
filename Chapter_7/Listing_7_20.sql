EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT cust_id
                       ,COUNT (*) tran_count
                       ,SUM (sales_amount) total_sales
                   FROM t1
               GROUP BY cust_id)
      SELECT q1.*
            ,100 * total_sales / SUM (total_sales) OVER () pct_revenue1
            ,100 * ratio_to_report (total_sales) OVER () pct_revenue2
        FROM q1;


SELECT * FROM TABLE (DBMS_XPLAN.display);