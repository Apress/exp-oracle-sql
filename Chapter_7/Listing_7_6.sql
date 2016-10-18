 WITH q1
     AS (  SELECT *
             FROM t1
         ORDER BY transaction_date)
  SELECT ROWNUM rn
        , (SELECT COUNT (*)+1
             FROM q1 inner
            WHERE inner.sales_amount < outer.sales_amount)
            rank_sales,outer.*
    FROM q1 outer
ORDER BY sales_amount;

explain plan for WITH q1
     AS (  SELECT *
             FROM t1
         ORDER BY transaction_date)
  SELECT ROWNUM rn
        , (SELECT COUNT (*)+1
             FROM q1 inner
            WHERE inner.sales_amount < outer.sales_amount)
            rank_sales,outer.*
    FROM q1 outer
ORDER BY sales_amount;

SELECT * FROM TABLE (DBMS_XPLAN.display);