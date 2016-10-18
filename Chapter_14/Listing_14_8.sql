EXPLAIN PLAN
   FOR
        SELECT sales_rep_id, SUM (order_total)
          FROM oe.orders
         WHERE order_status = 7
      GROUP BY sales_rep_id
      ORDER BY sales_rep_id;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC'));

EXPLAIN PLAN
   FOR
        SELECT sales_rep_id, SUM (order_total)
          FROM oe.orders
         WHERE order_status = 7 AND sales_rep_id IS NOT NULL
      GROUP BY sales_rep_id
      ORDER BY sales_rep_id;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC'));