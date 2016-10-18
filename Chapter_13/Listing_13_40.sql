SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT prod_id
            ,p1.prod_name
            ,p1.prod_desc
            ,p1.prod_category
            ,p1.prod_list_price
        FROM sh.products p1
       WHERE     EXISTS
                    (SELECT 1
                       FROM sh.products p2
                      WHERE     p1.prod_category = p2.prod_category
                            AND p1.prod_id <> p2.prod_id)
             AND NOT EXISTS
                        (SELECT 1
                           FROM sh.products p3
                          WHERE     p1.prod_category = p3.prod_category
                                AND p1.prod_id <> p3.prod_id
                                AND p3.prod_list_price > p1.prod_list_price);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
        SELECT p1.prod_id
              ,p1.prod_name
              ,p1.prod_desc
              ,prod_category
              ,p1.prod_list_price
          FROM sh.products p1 JOIN sh.products p2 USING (prod_category)
         WHERE p1.prod_id <> p2.prod_id
      GROUP BY p1.prod_id
              ,p1.prod_name
              ,p1.prod_desc
              ,prod_category
              ,p1.prod_list_price
        HAVING SUM (
                  CASE
                     WHEN p2.prod_list_price > p1.prod_list_price THEN 1
                     ELSE 0
                  END) = 0;

SELECT * FROM TABLE (DBMS_XPLAN.display);