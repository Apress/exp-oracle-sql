SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT c.cust_first_name, c.cust_last_name, s1.amount_sold
        FROM sh.customers c, sh.sales s1
       WHERE     amount_sold = (SELECT /*+ no_unnest */
                                       MAX (amount_sold)
                                  FROM sh.sales s2
                                 WHERE c.cust_id = s2.cust_id)
             AND c.cust_id = s1.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT c.cust_first_name, c.cust_last_name, s1.amount_sold
        FROM sh.customers c, sh.sales s1
       WHERE     amount_sold = (SELECT /*+ unnest */
                                       MAX (amount_sold)
                                  FROM sh.sales s2
                                 WHERE c.cust_id = s2.cust_id)
             AND c.cust_id = s1.cust_id;

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      WITH vw_wif_1
           AS (SELECT c.cust_first_name
                     ,c.cust_last_name
                     ,s.amount_sold
                     ,MAX (amount_sold) OVER (PARTITION BY s.cust_id)
                         AS item_4
                 FROM sh.customers c, sh.sales s
                WHERE s.cust_id = c.cust_id)
      SELECT cust_first_name, cust_last_name, amount_sold
        FROM vw_wif_1
       WHERE CASE WHEN item_4 = amount_sold THEN ROWID END IS NOT NULL;

SELECT * FROM TABLE (DBMS_XPLAN.display);