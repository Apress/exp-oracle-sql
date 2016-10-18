SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.sales s1
       WHERE    EXISTS
                   (SELECT /*+ no_coalesce_sq */
                           *
                      FROM sh.sales s2
                     WHERE     s1.time_id = s2.time_id
                           AND s2.amount_sold > s1.amount_sold + 100)
             OR EXISTS
                   (SELECT /*+ no_coalesce_sq */
                           *
                      FROM sh.sales s3
                     WHERE     s1.time_id = s3.time_id
                           AND s3.amount_sold < s1.amount_sold - 100);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.sales s1
       WHERE    EXISTS
                   (SELECT /*+   coalsesce_sq */
                           *
                      FROM sh.sales s2
                     WHERE     s1.time_id = s2.time_id
                           AND s2.amount_sold > s1.amount_sold + 100)
             OR EXISTS
                   (SELECT /*+   coalsesce_sq */
                           *
                      FROM sh.sales s3
                     WHERE     s1.time_id = s3.time_id
                           AND s3.amount_sold < s1.amount_sold - 100);


SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT *
        FROM sh.sales s1
       WHERE EXISTS
                (SELECT *
                   FROM sh.sales s2
                  WHERE        s2.amount_sold > s1.amount_sold + 100
                           AND s2.time_id = s1.time_id
                        OR     s2.amount_sold < s1.amount_sold - 100
                           AND s2.time_id = s1.time_id);

SELECT * FROM TABLE (DBMS_XPLAN.display);