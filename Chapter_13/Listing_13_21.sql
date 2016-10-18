SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH agg_q
           AS (  SELECT /*+ no_merge */
                       s.cust_id
                       ,s.prod_id
                       ,SUM (s.amount_sold) total_amt_sold
                   FROM sh.sales s
               GROUP BY s.cust_id, s.prod_id)
      SELECT cust_id
            ,c.cust_first_name
            ,c.cust_last_name
            ,c.cust_email
            ,p.prod_name
            ,agg_q.total_amt_sold
        FROM agg_q
             JOIN sh.customers c USING (cust_id)
             JOIN sh.countries co USING (country_id)
             JOIN sh.products p USING (prod_id)
       WHERE     co.country_name = 'Japan'
             AND prod_category = 'Photo'
             AND total_amt_sold > 20000;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH agg_q
           AS (  SELECT /*+   merge */
                       s.cust_id
                       ,s.prod_id
                       ,SUM (s.amount_sold) total_amt_sold
                   FROM sh.sales s
               GROUP BY s.cust_id, s.prod_id)
      SELECT cust_id
            ,c.cust_first_name
            ,c.cust_last_name
            ,c.cust_email
            ,p.prod_name
            ,agg_q.total_amt_sold
        FROM agg_q
             JOIN sh.customers c USING (cust_id)
             JOIN sh.countries co USING (country_id)
             JOIN sh.products p USING (prod_id)
       WHERE     co.country_name = 'Japan'
             AND prod_category = 'Photo'
             AND total_amt_sold > 20000;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_name
              ,SUM (s.amount_sold) AS total_amt_sold
          FROM sh.sales s
               JOIN sh.customers c USING (cust_id)
               JOIN sh.countries co USING (country_id)
               JOIN sh.products p USING (prod_id)
         WHERE co.country_name = 'Japan' AND prod_category = 'Photo'
      GROUP BY cust_id
              ,c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_name
        HAVING SUM (s.amount_sold) > 20000;

SELECT * FROM TABLE (DBMS_XPLAN.display);