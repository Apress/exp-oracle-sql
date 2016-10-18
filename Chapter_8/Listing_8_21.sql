BEGIN
   FOR i IN 1 .. 4
   LOOP
      DBMS_STATS.gather_table_stats (
         ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
        ,tabname   => 'T' || i);
   END LOOP;
END;
/

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT c1, COUNT (*) cnt1
                   FROM t1
               GROUP BY c1)
          ,q2
           AS (  SELECT c2, COUNT (*) cnt2
                   FROM t2
               GROUP BY c2)
      SELECT /*+ monitor optimizer_features_enable('11.2.0.3') parallel */
            c1, c2, cnt1
        FROM q1, q2
       WHERE cnt1 = cnt2;

SELECT * FROM TABLE (DBMS_XPLAN.display (format => 'BASIC +PARALLEL'));