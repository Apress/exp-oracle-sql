SET LINES 200 PAGES 0 SERVEROUT OFF

SELECT /*+ gather_plan_statistics leading(p) */
       COUNT (*)
  FROM oe.order_items i JOIN oe.product_descriptions p USING (product_id)
 WHERE i.order_id = 2367 AND p.language_id = 'US';

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'BASIC ROWS IOSTATS LAST'));
