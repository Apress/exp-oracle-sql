ALTER SYSTEM FLUSH SHARED_POOL;

SET LINES 200 PAGES 0 SERVEROUT OFF
VARIABLE b1 NUMBER;
EXEC :b1 := 15;

SELECT product_name
  FROM oe.order_items o, oe.product_information p
 WHERE unit_price = :b1 AND o.quantity > 1 AND p.product_id = o.product_id;

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'TYPICAL +ADAPTIVE'));

  EXEC :b1 := 1000;

SELECT product_name
  FROM oe.order_items o, oe.product_information p
 WHERE unit_price = :b1 AND o.quantity > 1 AND p.product_id = o.product_id;

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'TYPICAL'));

  EXEC :b1 := 15;

SELECT product_name
  FROM oe.order_items o, oe.product_information p
 WHERE unit_price = :b1 AND o.quantity > 1 AND p.product_id = o.product_id;

SELECT *
  FROM TABLE (DBMS_XPLAN.display_cursor (format => 'TYPICAL'));
