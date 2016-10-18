DROP TABLE t1;
DROP TABLE t2;
ALTER SESSION SET statistics_level=typical;
ALTER SESSION SET optimizer_features_enable='12.1.0.1';