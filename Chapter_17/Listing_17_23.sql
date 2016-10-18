SET LINES 200 PAGES 0

BEGIN
   FOR c IN (  SELECT /*+ parallel(s 4) */
                      *
                 FROM sh.sales s
             ORDER BY time_id)
   LOOP
      NULL;
   END LOOP;
END;
/

SELECT * FROM TABLE (DBMS_XPLAN.display_cursor (sql_id => '8j4mvjv5nmjw1'));

  SELECT dfo_number dfo
        ,tq_id
        ,server_type
        ,process
        ,num_rows
        ,ROUND (
              ratio_to_report (num_rows)
                 OVER (PARTITION BY dfo_number, tq_id, server_type)
            * 100)
            AS "%"
    FROM v$pq_tqstat
ORDER BY dfo_number, tq_id, server_type DESC;