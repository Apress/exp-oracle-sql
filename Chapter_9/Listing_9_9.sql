SET LINES 200 PAGES 900

COLUMN table_name FORMAT a15
COLUMN column_name FORMAT a25
COLUMN endpoint_number FORMAT 999999999
COLUMN endpoint_value FORMAT 999999999
COLUMN endpoint_actual_value FORMAT a25

SELECT table_name
      ,column_name
      ,endpoint_number
      ,endpoint_value
      ,endpoint_actual_value
  FROM all_tab_histograms
 WHERE     owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
       AND table_name = 'STATEMENT'
       AND column_name = 'TRANSACTION_AMOUNT';