EXPLAIN PLAN
   FOR
      SELECT outer.*
            , (SELECT COUNT (*)
                 FROM t1 inner
                WHERE inner.channel_id = outer.channel_id)
                cnt
        FROM t1 outer;

SELECT * FROM TABLE (DBMS_XPLAN.display);