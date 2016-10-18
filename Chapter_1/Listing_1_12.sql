WITH myprofits
     AS (SELECT s.channel_id
               ,GREATEST (c.unit_cost, 0) * s.quantity_sold total_cost
           FROM sh.costs c, sh.sales s
          WHERE     c.prod_id = s.prod_id
                AND c.time_id = s.time_id
                AND c.channel_id = s.channel_id
                AND c.promo_id = s.promo_id)
  SELECT channel_id, ROUND (AVG (total_cost), 2) avg_cost
    FROM myprofits
GROUP BY channel_id;
