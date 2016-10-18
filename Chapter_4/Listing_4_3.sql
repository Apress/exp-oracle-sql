SET PAGES 0 LINES 200 SERVEROUT OFF

SELECT /*+ gather_plan_statistics */
       'Count of sales: ' || COUNT (*) cnt
  FROM sh.sales s JOIN sh.customers c USING (cust_id)
 WHERE cust_last_name = 'Ruddy';

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (format => 'ALLSTATS LAST'));