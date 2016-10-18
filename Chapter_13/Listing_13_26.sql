SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH agg_q
           AS (  SELECT /*+ no_push_pred */
                       s.cust_id
                       ,prod_id
                       ,p.prod_name
                       ,SUM (s.amount_sold) total_amt_sold
                   FROM sh.sales s JOIN sh.products p USING (prod_id)
               GROUP BY s.cust_id, prod_id, p.prod_name)
      SELECT cust_id
            ,agg_q.prod_id
            ,agg_q.prod_name
            ,c.cust_first_name
            ,c.cust_last_name
            ,c.cust_email
            ,agg_q.total_amt_sold
        FROM agg_q RIGHT JOIN sh.customers c USING (cust_id)
       WHERE cust_first_name = 'Abner' AND cust_last_name = 'Everett';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH agg_q
           AS (  SELECT /*+   push_pred */
                       s.cust_id
                       ,prod_id
                       ,p.prod_name
                       ,SUM (s.amount_sold) total_amt_sold
                   FROM sh.sales s JOIN sh.products p USING (prod_id)
               GROUP BY s.cust_id, prod_id, p.prod_name)
      SELECT cust_id
            ,agg_q.prod_id
            ,agg_q.prod_name
            ,c.cust_first_name
            ,c.cust_last_name
            ,c.cust_email
            ,agg_q.total_amt_sold
        FROM agg_q RIGHT JOIN sh.customers c USING (cust_id)
       WHERE cust_first_name = 'Abner' AND cust_last_name = 'Everett';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT c.cust_id
            ,agg_q.prod_id
            ,agg_q.prod_name
            ,c.cust_first_name
            ,c.cust_last_name
            ,c.cust_email
            ,agg_q.total_amt_sold
        FROM sh.customers c
             OUTER APPLY
             (  SELECT prod_id, p.prod_name, SUM (s.amount_sold) total_amt_sold
                  FROM sh.sales s JOIN sh.products p USING (prod_id)
                 WHERE s.cust_id = c.cust_id
              GROUP BY prod_id, p.prod_name) agg_q
       WHERE cust_first_name = 'Abner' AND cust_last_name = 'Everett';

SELECT * FROM TABLE (DBMS_XPLAN.display);