  SELECT c1
        ,c2
        ,c3
        ,c4
    FROM t3
         LEFT JOIN t2 ON t3.c3 = t2.c2
         LEFT JOIN t1 ON t2.c2 = t1.c1
         LEFT JOIN t4 ON t3.c3 = t4.c4
ORDER BY c3;
