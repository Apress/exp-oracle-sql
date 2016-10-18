SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM oe.orders JOIN oe.order_items i USING (order_id)
       WHERE order_id = 2400;

SELECT * FROM TABLE (DBMS_XPLAN.display);

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ index(i order_items_pk) */
             *
        FROM oe.orders JOIN oe.order_items i USING (order_id)
       WHERE order_id = 2400;

SELECT * FROM TABLE (DBMS_XPLAN.display);