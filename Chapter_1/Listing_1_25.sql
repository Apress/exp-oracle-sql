  SELECT c1
        ,c2
        ,c3
        ,c4
    FROM t1
        ,t2
        ,t3
        ,t4
   WHERE t3.c3 = t2.c2(+) AND t2.c2 = t1.c1(+) AND t3.c3 = t4.c4(+)
ORDER BY c3;