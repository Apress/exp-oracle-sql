SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH cust_q
           AS (  SELECT cust_id
                       ,promo_id
                       ,SUM (amount_sold) cas
                       ,MAX (SUM (amount_sold)) OVER (PARTITION BY promo_id)
                           max_cust
                   FROM sh.sales
               GROUP BY cust_id, promo_id)
          ,prod_q
           AS (  SELECT prod_id
                       ,promo_id
                       ,SUM (amount_sold) pas
                       ,MAX (SUM (amount_sold)) OVER (PARTITION BY promo_id)
                           max_prod
                   FROM sh.sales
                  WHERE promo_id = 999
               GROUP BY prod_id, promo_id)
      SELECT promo_id
            ,prod_id
            ,pas
            ,cust_id
            ,cas
        FROM cust_q NATURAL JOIN prod_q
       WHERE cust_q.cas = cust_q.max_cust AND prod_q.pas = prod_q.max_prod;

SELECT * FROM TABLE (DBMS_XPLAN.display);