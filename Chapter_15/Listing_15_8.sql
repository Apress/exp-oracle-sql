CREATE TABLE sales_2
PARTITION BY RANGE (time_id)
   (PARTITION pdefault VALUES LESS THAN (maxvalue))
AS
   SELECT *
     FROM sh.sales
    WHERE time_id = DATE '2001-10-18';

CREATE TABLE customers_2
AS
   SELECT * FROM sh.customers;

CREATE TABLE products_2
AS
   SELECT * FROM sh.products;

ALTER TABLE products_2
   ADD CONSTRAINT products_2_pk PRIMARY KEY
 (prod_id) ENABLE VALIDATE;

ALTER TABLE customers_2
   ADD CONSTRAINT customers_2_pk PRIMARY KEY
 (cust_id) ENABLE VALIDATE;

BEGIN
   DBMS_STATS.gather_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'SALES_2');
   DBMS_STATS.gather_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'CUSTOMERS_2');
   DBMS_STATS.gather_table_stats (
      ownname   => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,tabname   => 'PRODUCTS_2');
END;
/

CREATE BITMAP INDEX sales_2_cust_ln_bjx
   ON sales_2 (c.cust_last_name)
   FROM customers_2 c, sales_2 s
   WHERE c.cust_id = s.cust_id
   LOCAL;

CREATE BITMAP INDEX sales_prod_category_bjx
   ON sales_2 (p.prod_category)
   FROM products_2 p, sales_2 s
   WHERE s.prod_id = p.prod_id
   LOCAL;

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT prod_name
            ,cust_first_name
            ,time_id
            ,amount_sold
        FROM customers_2 c, products_2 p, sales_2 s
       WHERE     s.cust_id = c.cust_id
             AND s.prod_id = p.prod_id
             AND c.cust_last_name = 'Everett'
             AND p.prod_category = 'Electronics';

SELECT * FROM TABLE (DBMS_XPLAN.display);