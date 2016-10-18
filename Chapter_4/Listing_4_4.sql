SELECT DEPTH
        ,LPAD (' ', DEPTH) || operation operation
        ,options
        ,object_name
        ,time "EST TIME (Secs)"
        ,last_elapsed_time / 1000000 "ACTUAL TIME (Secs)"
        ,CARDINALITY "EST ROWS"
        ,last_output_rows "Actual Rows"
    FROM v$sql_plan_statistics_all
   WHERE sql_id = '2pftkryughyxm'
ORDER BY id;