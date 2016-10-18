CREATE TABLE global_part_index_test
(
   c1   INTEGER
  ,c2   VARCHAR2 (50)
  ,c3   VARCHAR2 (50)
);

CREATE UNIQUE INDEX gpi_ix
   ON global_part_index_test (c1)
   GLOBAL PARTITION BY HASH (c1)
      PARTITIONS 32;

ALTER TABLE global_part_index_test ADD CONSTRAINT global_part_index_test_pk PRIMARY KEY (c1);

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
      SELECT *
        FROM global_part_index_test
       WHERE c1 BETWEEN 123456 AND 123458;

SELECT * FROM TABLE (DBMS_XPLAN.display);