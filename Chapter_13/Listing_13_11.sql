SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+  no_partial_join(iv) */
               product_id, MAX (it.quantity)
          FROM oe.order_items it JOIN oe.inventories iv USING (product_id)
      GROUP BY product_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT /*+    partial_join(iv) */
              product_id, MAX (it.quantity)
          FROM oe.order_items it JOIN oe.inventories iv USING (product_id)
      GROUP BY product_id;


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT product_id, MAX (quantity)
          FROM oe.order_items it
         WHERE EXISTS
                  (SELECT 1
                     FROM oe.inventories iv
                    WHERE it.product_id = iv.product_id)
      GROUP BY it.product_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);