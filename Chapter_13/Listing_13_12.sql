SET LINES 200 PAGES 0 SERVEROUT OFF

BEGIN
   FOR r IN (  SELECT /*+ TAGPJ gather_plan_statistics */
                     cust_id, MAX (s.amount_sold)
                 FROM sh.customers c JOIN sh.sales s USING (cust_id)
                WHERE s.amount_sold > 1782 AND s.prod_id = 18
             GROUP BY cust_id)
   LOOP
      NULL;
   END LOOP;
END;
/

SELECT p.*
  FROM v$sql s
      ,TABLE (
          DBMS_XPLAN.display_cursor (s.sql_id
                                    ,s.child_number
                                    ,'BASIC IOSTATS LAST')) p
 WHERE sql_text LIKE 'SELECT /*+ TAGPJ%';