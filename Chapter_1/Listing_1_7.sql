COLUMN sql_text FORMAT a30

SELECT sql_id, sql_text
  FROM v$sql
 WHERE sql_fulltext LIKE '%''LITERAL1''%';

SELECT sql_id, sql_text
  FROM dba_hist_sqltext
 WHERE sql_text LIKE '%''LITERAL1''%';