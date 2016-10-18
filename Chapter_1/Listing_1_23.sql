  SELECT c1
        ,c2
        ,c3
        ,c4
    FROM (t3 LEFT JOIN t4 ON t3.c3 = t4.c4)
         LEFT JOIN (t2 LEFT JOIN t1 ON t1.c1 = t2.c2) ON t2.c2 = t3.c3
ORDER BY c3;