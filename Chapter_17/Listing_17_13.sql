SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (SELECT c.*
                     ,SUM (amount_sold)
                         OVER (PARTITION BY cust_state_province)
                         total_province_sales
                     ,ROW_NUMBER ()
                      OVER (PARTITION BY cust_state_province
                            ORDER BY amount_sold DESC, c.cust_id DESC)
                         rn
                 FROM sh.sales s JOIN sh.customers c ON s.cust_id = c.cust_id)
      SELECT *
        FROM q1
       WHERE rn = 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT MIN (c.ROWID)
                           KEEP (DENSE_RANK LAST ORDER BY amount_sold, cust_id)
                           cust_rowid
                       ,SUM (amount_sold) total_province_sales
                   FROM sh.sales s JOIN sh.customers c USING (cust_id)
               GROUP BY cust_state_province)
      SELECT c.*, q1.total_province_sales
        FROM q1 JOIN sh.customers c ON q1.cust_rowid = c.ROWID;

SELECT * FROM TABLE (DBMS_XPLAN.display);