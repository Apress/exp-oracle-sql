DECLARE
   CURSOR c1
   IS
      WITH q1
           AS (SELECT /*+ no_merge */
                      ROWID rid
                 FROM t1
                WHERE time_id = DATE '2001-12-28' AND cust_id > 1)
          ,q2
           AS (SELECT /*+ no_merge */
                      ROWID rid
                 FROM t1
                WHERE time_id = DATE '2001-12-28' AND prod_id > 1)
          ,q3
           AS (SELECT /*+ leading(q1 q2) use_nl(t1) */
                     rid, ROW_NUMBER () OVER (ORDER BY rid) rn
                 FROM q1 NATURAL JOIN q2)
        SELECT TRUNC ( (rn - 1) / 100) + 1 chunk
              ,MIN (rid) min_rowid
              ,MAX (rid) max_rowid
              ,COUNT (*) chunk_size
          FROM q3
      GROUP BY TRUNC ( (rn - 1) / 100);

   CURSOR c2 (
      min_rowid    ROWID
     ,max_rowid    ROWID)
   IS
      SELECT /*+ rowid(t1) */
             *
        FROM t1
       WHERE     ROWID BETWEEN min_rowid AND max_rowid
             AND time_id = DATE '2001-12-28'
             AND prod_id > 1
             AND cust_id > 1;
BEGIN
   FOR r1 IN c1
   LOOP
      FOR r2 IN c2 (r1.min_rowid, r1.max_rowid)
      LOOP
         NULL;
      END LOOP;
   END LOOP;
END;
/

SET LINES 200 PAGES 0

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (sql_id => 'fwts62m37r049'));

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (sql_id => '9bxwbzz223x16'));