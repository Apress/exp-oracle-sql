SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM TABLE (
                CAST (MULTISET (    SELECT 'CAMERA' product, 1 quantity, 1 price
                                      FROM DUAL
                                CONNECT BY LEVEL <= 3) AS order_item_table)) oi;

SELECT * FROM TABLE (DBMS_XPLAN.display);