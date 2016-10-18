  SELECT c1, c2, c3
    FROM t2
         LEFT JOIN t3
            ON t2.c2 = t3.c3
         RIGHT JOIN t1
            ON t1.c1 = t3.c3
ORDER BY c1;