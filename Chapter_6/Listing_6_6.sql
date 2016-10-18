CREATE OR REPLACE PROCEDURE listing_6_6 (p_cust_last_name VARCHAR2)
IS
   cnt   NUMBER;
BEGIN
   IF p_cust_last_name = 'AJAX'
   THEN
      SELECT COUNT (*)
        INTO cnt
        FROM sh.sales s JOIN sh.customers c USING (cust_id)
       WHERE c.cust_last_name = 'AJAX'; -- One plan for AJAX
   ELSE
      SELECT COUNT (*)
        INTO cnt
        FROM sh.sales s JOIN sh.customers c USING (cust_id)
       WHERE c.cust_last_name = p_cust_last_name; -- Another for everybody else
   END IF;
END listing_6_6;
/