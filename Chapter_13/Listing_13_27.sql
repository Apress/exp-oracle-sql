SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT o.order_id
            ,o.order_date
            ,o.order_mode
            ,o.customer_id
            ,o.order_status
            ,o.order_total
            ,o.sales_rep_id
            ,o.promotion_id
            ,agg_q.max_quantity
        FROM oe.orders o
             CROSS APPLY (SELECT /*+ no_decorrelate */
                                 MAX (oi.quantity) max_quantity
                            FROM oe.order_items oi
                           WHERE oi.order_id = o.order_id) agg_q
       WHERE o.order_id IN (2458, 2397);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT o.order_id
            ,o.order_date
            ,o.order_mode
            ,o.customer_id
            ,o.order_status
            ,o.order_total
            ,o.sales_rep_id
            ,o.promotion_id
            ,agg_q.max_quantity
        FROM oe.orders o
             CROSS APPLY (SELECT /*+   decorrelate */
                                 MAX (oi.quantity) max_quantity
                            FROM oe.order_items oi
                           WHERE oi.order_id = o.order_id) agg_q
       WHERE o.order_id IN (2458, 2397);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT o.order_id order_id
              ,o.order_date order_date
              ,o.order_mode order_mode
              ,o.customer_id customer_id
              ,o.order_status order_status
              ,o.order_total order_total
              ,o.sales_rep_id sales_rep_id
              ,o.promotion_id promotion_id
              ,MAX (oi.quantity) max_quantity
          FROM oe.orders o
               LEFT JOIN oe.order_items oi
                  ON     oi.order_id = o.order_id
                     AND (oi.order_id = 2397 OR oi.order_id = 2458)
         WHERE (o.order_id = 2397 OR o.order_id = 2458)
      GROUP BY o.order_id
              ,o.ROWID
              ,o.promotion_id
              ,o.sales_rep_id
              ,o.order_total
              ,o.order_status
              ,o.customer_id
              ,o.order_mode
              ,o.order_date
              ,o.order_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);