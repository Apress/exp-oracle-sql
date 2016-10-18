SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ parallel no_gby_pushdown */
              prod_id
              ,cust_id
              ,promo_id
              ,COUNT (*) cnt
          FROM sh.sales
         WHERE amount_sold > 100
      GROUP BY prod_id, cust_id, promo_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT /*+ parallel gby_pushdown */
              prod_id
              ,cust_id
              ,promo_id
              ,COUNT (*) cnt
          FROM sh.sales
         WHERE amount_sold > 100
      GROUP BY prod_id, cust_id, promo_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH pq
           AS (  SELECT prod_id
                       ,cust_id
                       ,promo_id
                       ,COUNT (*) cnt
                   FROM sh.sales
                  WHERE amount_sold > 100 AND time_id < DATE '2000-01-01'
               GROUP BY prod_id, cust_id, promo_id
               UNION ALL
                 SELECT prod_id
                       ,cust_id
                       ,promo_id
                       ,COUNT (*) cnt
                   FROM sh.sales
                  WHERE amount_sold > 100 AND time_id >= DATE '2000-01-01'
               GROUP BY prod_id, cust_id, promo_id)
        SELECT prod_id
              ,cust_id
              ,promo_id
              ,SUM (cnt) AS cnt
          FROM pq
      GROUP BY prod_id, cust_id, promo_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);