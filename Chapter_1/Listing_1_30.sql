WITH sales_q
     AS (SELECT s.*, EXTRACT (YEAR FROM time_id) sale_year
           FROM sh.sales s)
  SELECT sale_year
        ,country_name
        ,NVL (SUM (amount_sold), 0) amount_sold
        ,AVG (NVL (SUM (amount_sold), 0)) OVER (PARTITION BY sale_year)
            avg_sold
    FROM sales_q s
         JOIN sh.customers c USING (cust_id) -- PARTITION BY (sale_year)
         RIGHT JOIN sh.countries co
            ON c.country_id = co.country_id AND cust_year_of_birth = 1976
   WHERE     (sale_year IN (1998, 1999) OR sale_year IS NULL)
         AND country_region = 'Europe'
GROUP BY sale_year, country_name
ORDER BY 1, 2;

WITH sales_q
     AS (SELECT s.*, EXTRACT (YEAR FROM time_id) sale_year
           FROM sh.sales s)
  SELECT sale_year
        ,country_name
        ,NVL (SUM (amount_sold), 0) amount_sold
        ,AVG (NVL (SUM (amount_sold), 0)) OVER (PARTITION BY sale_year)
            avg_sold
    FROM sales_q s
         JOIN sh.customers c USING (cust_id) PARTITION BY (sale_year)
         RIGHT JOIN sh.countries co
            ON c.country_id = co.country_id AND cust_year_of_birth = 1976
   WHERE     (sale_year IN (1998, 1999) OR sale_year IS NULL)
         AND country_region = 'Europe'
GROUP BY sale_year, country_name
ORDER BY 1, 2;