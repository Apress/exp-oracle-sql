CREATE GLOBAL TEMPORARY TABLE temp1
AS
   SELECT *
     FROM t3
    WHERE 1 = 0;

CREATE OR REPLACE PROCEDURE listing_6_7 (load_mode VARCHAR2)
IS
BEGIN
   IF load_mode = 'INCREMENTAL'
   THEN
      INSERT INTO t3 (c1, c2)
         SELECT /*+ leading(temp1) use_nl(t3) */
               temp1.c3, t3.c2
           FROM temp1, t3
          WHERE temp1.c1 = t3.c1;
   ELSE -- FULL
      INSERT INTO t3 (c1, c2)
         SELECT /*+ leading(t3) use_hash(temp1) no_swap_join_inputs(temp1) */
               temp1.c3, t3.c2
           FROM temp1, t3
          WHERE temp1.c1 = t3.c1;
   END IF;
END listing_6_7;
/