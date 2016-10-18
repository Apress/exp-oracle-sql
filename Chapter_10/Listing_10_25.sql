SET LINES 200 PAGES 0

CREATE TYPE order_item AS OBJECT
(
   product_name VARCHAR2 (50)
  ,quantity INTEGER
  ,price NUMBER (8, 2)
);
/

CREATE TYPE order_item_table AS TABLE OF order_item;
/

CREATE TABLE orders
(
   order_id      NUMBER PRIMARY KEY
  ,customer_id   INTEGER
  ,order_items   order_item_table
)
NESTED TABLE order_items
   STORE AS order_items_nt;

EXPLAIN PLAN
   FOR
      SELECT o.order_id
            ,o.customer_id
            ,oi.product_name
            ,oi.quantity
            ,oi.price
        FROM orders o, TABLE (o.order_items) oi;

SELECT * FROM TABLE (DBMS_XPLAN.display);