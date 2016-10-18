SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT c.cust_first_name, c.cust_last_name, s1.amount_sold
        FROM sh.customers c, sh.sales s1
       WHERE     s1.amount_sold = (SELECT /*+ no_unnest */
                                          MAX (amount_sold)
                                     FROM sh.sales s2
                                    WHERE s1.cust_id = s2.cust_id)
             AND c.cust_id = s1.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT c.cust_first_name, c.cust_last_name, s1.amount_sold
        FROM sh.customers c, sh.sales s1
       WHERE     s1.amount_sold = (SELECT /*+     unnest */
                                          MAX (amount_sold)
                                     FROM sh.sales s2
                                    WHERE s1.cust_id = s2.cust_id)
             AND c.cust_id = s1.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_sq_1
           AS (  SELECT cust_id AS sq_cust_id
                       ,MAX (amount_sold) max_amount_sold
                   FROM sh.sales s2
               GROUP BY cust_id)
      SELECT c.cust_first_name, c.cust_last_name, s1.amount_sold
        FROM sh.sales s1, sh.customers c, vw_sq_1
       WHERE     s1.amount_sold = vw_sq_1.max_amount_sold
             AND s1.cust_id = vw_sq_1.sq_cust_id
             AND s1.cust_id = c.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);