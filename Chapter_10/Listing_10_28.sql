SET LINES 200 PAGES 0

CREATE CLUSTER cluster_hash
(
  ck                              INTEGER
)
HASHKEYS 3
HASH IS ck;

CREATE TABLE tch1
(
   ck   INTEGER
  ,c1   INTEGER
)
CLUSTER cluster_hash ( ck );

CREATE CLUSTER cluster_btree
(
  ck                              INTEGER,
  c1                              INTEGER
);

CREATE INDEX cluster_btree_ix
   ON CLUSTER cluster_btree;

CREATE TABLE tc2
(
   ck   INTEGER
  ,c1   INTEGER
)
CLUSTER cluster_btree ( ck, c1 );

CREATE TABLE tc3
(
   ck   INTEGER
  ,c1   INTEGER
)
CLUSTER cluster_btree ( ck, c1 );

EXPLAIN PLAN
   FOR
      SELECT /*+ hash(tch1) index(tc2) cluster(tc3) */
             *
        FROM tch1, tc2, tc3
       WHERE     tch1.ck = 1
             AND tch1.ck = tc2.ck
             AND tch1.c1 = tc2.c1
             AND tc2.ck = tc3.ck
             AND tc2.c1 = tc3.c1;

SELECT * FROM TABLE (DBMS_XPLAN.display);