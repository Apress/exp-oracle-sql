CREATE GLOBAL TEMPORARY TABLE electronics_analysis_gtt
(
   cust_id       NUMBER NOT NULL
  ,promo_id      NUMBER NOT NULL
  ,time_id       DATE
  ,amount_sold   NUMBER
) ON COMMIT DELETE ROWS;

CREATE OR REPLACE PROCEDURE get_electronics_stats_v2 (p_sales_month DATE)
IS
   v_sales_month        CONSTANT DATE := TRUNC (p_sales_month, 'MM'); -- Sanity check
   v_next_sales_month   CONSTANT DATE := ADD_MONTHS (v_sales_month, 1);
BEGIN
   --
   -- create semi-aggregated data for later use
   --

   DELETE FROM electronics_analysis_gtt; -- just in case

   INSERT INTO electronics_analysis_gtt (cust_id
                                        ,promo_id
                                        ,time_id
                                        ,amount_sold)
        SELECT cust_id
              ,promo_id
              ,MAX (time_id) time_id
              ,SUM (amount_sold) amount_sold
          FROM sh.sales JOIN sh.products p USING (prod_id)
         WHERE     time_id >= v_sales_month
               AND time_id < v_next_sales_month
               AND prod_category = 'Electronics'
      GROUP BY cust_id, promo_id;

   --
   -- Identify key electronics customers from this month
   -- that spent more than 1000 on Electronics
   --
   MERGE INTO key_electronics_customers c
        USING (  SELECT cust_id, SUM (amount_sold) amount_sold
                   FROM electronics_analysis_gtt
               GROUP BY cust_id
                 HAVING SUM (amount_sold) > 1000) t
           ON (c.cust_id = t.cust_id)
   WHEN MATCHED
   THEN
      UPDATE SET
         c.latest_sale_month = v_sales_month
        ,c.total_electronics_sold = t.amount_sold
   WHEN NOT MATCHED
   THEN
      INSERT     (cust_id, latest_sale_month, total_electronics_sold)
          VALUES (t.cust_id, v_sales_month, t.amount_sold);

   --
   -- Remove customers with little activity recently
   --
   DELETE FROM key_electronics_customers
         WHERE latest_sale_month < ADD_MONTHS (v_sales_month, -3);

   --
   -- Now generate statistics for promotions for sales in Electronics
   --
   MERGE INTO electronics_promotion_summary p
        USING (  SELECT promo_id, SUM (amount_sold) amount_sold
                   FROM electronics_analysis_gtt
               GROUP BY promo_id) t
           ON (p.promo_id = t.promo_id AND p.sales_month = v_sales_month)
   WHEN MATCHED
   THEN
      UPDATE SET p.total_electronics_sold = t.amount_sold
   WHEN NOT MATCHED
   THEN
      INSERT     (sales_month, promo_id, total_electronics_sold)
          VALUES (v_sales_month, t.promo_id, t.amount_sold);
END get_electronics_stats_v2;
/