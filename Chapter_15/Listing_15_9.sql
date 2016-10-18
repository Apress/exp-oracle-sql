CREATE TABLE order_items_compress
(
   order_id        INTEGER NOT NULL
  ,order_item_id   INTEGER NOT NULL
  ,order_date      DATE NOT NULL
  ,product_id      INTEGER
  ,quantity        INTEGER
  ,price           NUMBER
  ,CONSTRAINT order_items_compress_fk FOREIGN KEY
      (order_date, order_id)
       REFERENCES orders_part (order_date, order_id)
)
COMPRESS FOR OLTP
PCTFREE 0;