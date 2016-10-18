DROP INDEX t2_i1;

BEGIN
   FOR r IN (SELECT *
               FROM t1, t2
              WHERE t1.c1 = t2.c2)
   LOOP
      NULL;
   END LOOP;
END;
/

DEFINE sql_id=cwktrs03rd8c7
@@run_tuning_advisor