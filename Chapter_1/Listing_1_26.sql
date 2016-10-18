SELECT *
  FROM t1
       LEFT JOIN t2
          ON t1.c1 = t2.c2
       JOIN t3
          ON t2.c2 = t3.c3
       CROSS JOIN t4;