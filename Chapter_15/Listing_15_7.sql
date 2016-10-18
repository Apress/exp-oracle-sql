SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ leading(o i) use_hash(i) no_swap_join_inputs(i)
           parallel(16) PQ_DISTRIBUTE(I NONE NONE)*/
             *
        FROM orders_part o
             JOIN order_items_part i USING (order_date, order_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);