SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM oe.order_items i1, oe.order_items i2
       WHERE     i1.quantity = i2.quantity
             AND i1.order_id = 2392
             AND i1.line_item_id = 4
             AND i2.product_id = 2462;

SELECT * FROM TABLE (DBMS_XPLAN.display);