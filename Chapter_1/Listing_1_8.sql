CREATE TABLE t1
(
   n1   NUMBER
  ,n2   NUMBER
);

CREATE TABLE t2
(
   n1   NUMBER
  ,n2   NUMBER
);

INSERT INTO t1
   SELECT object_id, data_object_id
     FROM all_objects
    WHERE ROWNUM <= 30;