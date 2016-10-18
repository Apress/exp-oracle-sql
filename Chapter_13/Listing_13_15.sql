SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT /*+ no_transform_distinct_agg */
             COUNT (DISTINCT cust_id) FROM sh.sales;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+   transform_distinct_agg */
            COUNT (DISTINCT cust_id) FROM sh.sales;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_dag
           AS (  SELECT cust_id
                   FROM sh.sales
               GROUP BY cust_id)
      SELECT COUNT (cust_id)
        FROM vw_dag;

SELECT * FROM TABLE (DBMS_XPLAN.display);