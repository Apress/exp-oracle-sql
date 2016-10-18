EXPLAIN PLAN
   FOR
        SELECT channel_id, AVG (sales_amount) mean
          FROM t1
         WHERE channel_id IS NOT NULL
      GROUP BY channel_id
      ORDER BY channel_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

CREATE INDEX t1_i1
   ON t1 (channel_id);

EXPLAIN PLAN
   FOR
        SELECT channel_id, AVG (sales_amount) mean
          FROM t1
         WHERE channel_id IS NOT NULL
      GROUP BY channel_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

DROP INDEX t1_i1;