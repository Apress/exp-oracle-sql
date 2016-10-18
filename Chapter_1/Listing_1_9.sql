DECLARE
   TYPE char_table_type IS TABLE OF t1.n1%TYPE;

   n1_array   char_table_type;
   n2_array   char_table_type;
BEGIN
   DELETE FROM t1
     RETURNING n1, n2
          BULK COLLECT INTO n1_array, n2_array;

   FORALL i IN 1 .. n1_array.COUNT
      MERGE INTO t2
           USING DUAL
              ON (t2.n1 = n1_array (i))
      WHEN MATCHED
      THEN
         UPDATE SET t2.n2 = n2_array (i)
      WHEN NOT MATCHED
      THEN
         INSERT     (n1, n2)
             VALUES (n1_array (i), n2_array (i));
END;
/