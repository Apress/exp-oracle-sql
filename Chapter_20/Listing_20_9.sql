ALTER TABLE statement_part
   SPLIT PARTITION p3
      AT (DATE '2013-01-12')
      INTO (PARTITION p3, PARTITION p4);

ALTER TABLE statement_part
   SPLIT PARTITION p4
      AT (DATE '2013-01-13')
      INTO (PARTITION p4, PARTITION p5);

ALTER TABLE statement_part
   SPLIT PARTITION p5
      AT (DATE '2013-01-14')
      INTO (PARTITION p5, PARTITION p6);

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM statement_part t
       WHERE transaction_date = DATE '2013-01-06';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM statement_part t
       WHERE transaction_date = DATE '2013-01-13';

SELECT * FROM TABLE (DBMS_XPLAN.display);