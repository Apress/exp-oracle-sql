SET LINES 200 PAGES 900

COLUMN index_name FORMAT a20
COLUMN distinct_keys FORMAT 999999999
COLUMN clustering_factor FORMAT 999999999

  SELECT index_name, distinct_keys, clustering_factor
    FROM all_ind_statistics i
   WHERE     i.table_name = 'STATEMENT'
         AND i.owner = SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
         AND i.index_name IN ('STATEMENT_I_PC', 'STATEMENT_I_CC')
ORDER BY index_name DESC;

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement t
       WHERE product_category = 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM statement t
       WHERE customer_category = 1;


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ index(t (customer_category)) */
             *
        FROM statement t
       WHERE customer_category = 1;

SELECT * FROM TABLE (DBMS_XPLAN.display);