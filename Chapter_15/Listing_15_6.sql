CREATE TABLE orders_part
(
   order_id           INTEGER NOT NULL
  ,order_date         DATE NOT NULL
  ,customer_name      VARCHAR2 (50)
  ,delivery_address   VARCHAR2 (100)
)
PARTITION BY LIST
   (order_date)
   SUBPARTITION BY HASH (order_id)
      SUBPARTITIONS 16
   (
      PARTITION p1 VALUES (DATE '2014-04-01')
     ,PARTITION p2 VALUES (DATE '2014-04-02'));

CREATE UNIQUE INDEX orders_part_pk
   ON orders_part (order_date, order_id)
   LOCAL;

ALTER TABLE orders_part
   ADD CONSTRAINT orders_part_pk PRIMARY KEY
  (order_date,order_id);

CREATE TABLE order_items_part
(
   order_id        INTEGER NOT NULL
  ,order_item_id   INTEGER NOT NULL
  ,order_date      DATE NOT NULL
  ,product_id      INTEGER
  ,quantity        INTEGER
  ,price           NUMBER
  ,CONSTRAINT order_items_part_fk FOREIGN KEY
      (order_date, order_id)
       REFERENCES orders_part (order_date, order_id)
)
PARTITION BY REFERENCE (order_items_part_fk);

CREATE UNIQUE INDEX order_items_part_pk
   ON order_items_part (order_date, order_id, order_item_id)
   COMPRESS 1
   LOCAL;

ALTER TABLE order_items_part
   ADD CONSTRAINT order_items_part_pk PRIMARY KEY
  (order_date,order_id,order_item_id);

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ leading(o i) use_hash(i) no_swap_join_inputs(i) */
             *
        FROM orders_part o JOIN order_items_part i USING (order_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ leading(o i) use_hash(i) no_swap_join_inputs(i) */
             *
        FROM orders_part o
             JOIN order_items_part i USING (order_date, order_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);