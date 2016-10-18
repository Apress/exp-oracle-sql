SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM (  SELECT /*+ no_eliminate_oby */
                       o1.*
                  FROM oe.order_items o1
                 WHERE product_id = (SELECT MAX (o2.product_id)
                                       FROM oe.order_items o2
                                      WHERE o2.order_id = o1.order_id)
              ORDER BY order_id) v;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM (  SELECT /*+   eliminate_oby */
                       o1.*
                  FROM oe.order_items o1
                 WHERE product_id = (SELECT MAX (o2.product_id)
                                       FROM oe.order_items o2
                                      WHERE o2.order_id = o1.order_id)
              ORDER BY order_id) v;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM (SELECT o1.*
                FROM oe.order_items o1
               WHERE product_id = (SELECT MAX (o2.product_id)
                                     FROM oe.order_items o2
                                    WHERE o2.order_id = o1.order_id)) v;

SELECT * FROM TABLE (DBMS_XPLAN.display);