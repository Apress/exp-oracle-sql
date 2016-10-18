SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT prod_id
                   FROM sh.sales
               GROUP BY prod_id
               ORDER BY SUM (amount_sold) DESC)
        SELECT c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_name
          FROM sh.sales s
               JOIN sh.customers c USING (cust_id)
               JOIN sh.products p USING (prod_id)
         WHERE prod_id = (SELECT /*+ no_push_subq */
                                 prod_id
                            FROM q1
                           WHERE ROWNUM = 1)
      GROUP BY c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_name
        HAVING SUM (s.amount_sold) > 20000;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH q1
           AS (  SELECT prod_id
                   FROM sh.sales
               GROUP BY prod_id
               ORDER BY SUM (amount_sold) DESC)
        SELECT c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_name
          FROM sh.sales s
               JOIN sh.customers c USING (cust_id)
               JOIN sh.products p USING (prod_id)
         WHERE prod_id = (SELECT /*+   push_subq */
                                 prod_id
                            FROM q1
                           WHERE ROWNUM = 1)
      GROUP BY c.cust_first_name
              ,c.cust_last_name
              ,c.cust_email
              ,p.prod_name
        HAVING SUM (s.amount_sold) > 20000;

SELECT * FROM TABLE (DBMS_XPLAN.display);