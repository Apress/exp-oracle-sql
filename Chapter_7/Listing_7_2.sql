EXPLAIN PLAN
   FOR
        SELECT channel_id, MEDIAN (sales_amount) med, COUNT (*) cnt
          FROM t1
      GROUP BY channel_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

SELECT VALUE
  FROM v$mystat NATURAL JOIN v$statname
 WHERE name = 'sorts (rows)';

  SELECT channel_id, MEDIAN (sales_amount) med, COUNT (*) cnt
    FROM t1
GROUP BY channel_id;

SELECT VALUE
  FROM v$mystat NATURAL JOIN v$statname
 WHERE name = 'sorts (rows)';