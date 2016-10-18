SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH cust_q
           AS (  SELECT cust_id, promo_id, SUM (amount_sold) cas
                   FROM sh.sales
               GROUP BY cust_id, promo_id)
          ,prod_q
           AS (  SELECT prod_id, promo_id, SUM (amount_sold) pas
                   FROM sh.sales
                  WHERE promo_id = 999
               GROUP BY prod_id, promo_id)
      SELECT promo_id
            ,prod_id
            ,pas
            ,cust_id
            ,cas
        FROM cust_q NATURAL JOIN prod_q;

SELECT * FROM TABLE (DBMS_XPLAN.display);