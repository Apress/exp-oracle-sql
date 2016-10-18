SET SERVEROUTPUT OFF

SELECT 'Count of sales: ' || COUNT (*) cnt
  FROM sh.sales s JOIN sh.customers c USING (cust_id)
 WHERE cust_last_name = 'Ruddy';