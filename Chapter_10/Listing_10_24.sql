SET LINES 200 PAGES 0

CREATE TABLE xml_test (c1 XMLTYPE);

EXPLAIN PLAN
   FOR
      SELECT x.*
        FROM xml_test t
            ,XMLTABLE (
                '//a'
                PASSING t.c1
                COLUMNS "a" CHAR (10) PATH '@path1'
                       ,"b" CHAR (50) PATH '@path2') x;

SELECT * FROM TABLE (DBMS_XPLAN.display);