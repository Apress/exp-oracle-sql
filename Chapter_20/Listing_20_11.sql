--
-- First drop the empty partitions
--
ALTER TABLE statement_part DROP PARTITION p3;
ALTER TABLE statement_part DROP PARTITION p4;
ALTER TABLE statement_part DROP PARTITION p5;
ALTER TABLE statement_part DROP PARTITION p6;
--
-- Now gather statistics on full partitions
--

BEGIN
   tstats.gather_table_stats (
      p_owner        => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,p_table_name   => 'STATEMENT_PART');
END;
/

--
-- Check plans and cost before partition maintenance
--

SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
      SELECT COUNT (*)
        FROM statement_part t
       WHERE transaction_date = DATE '2013-01-06';

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
      SELECT /*+ full(t) */
             COUNT (*)
        FROM statement_part t
       WHERE transaction_date = DATE '2013-01-06';

SELECT * FROM TABLE (DBMS_XPLAN.display);

--
-- Now recreate the empty partitions

ALTER TABLE statement_part
   ADD PARTITION p3 VALUES LESS THAN (DATE '2013-01-12');


ALTER TABLE statement_part
   ADD PARTITION p4 VALUES LESS THAN (DATE '2013-01-13');

ALTER TABLE statement_part
   ADD PARTITION p5 VALUES LESS THAN (DATE '2013-01-14');

ALTER TABLE statement_part
   ADD PARTITION p6 VALUES LESS THAN (maxvalue);

--
-- Finally call TSTATS hook to adjust NUM_BLOCKS statistic
--

BEGIN
   tstats.adjust_global_stats (
      p_owner        => SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA')
     ,p_table_name   => 'STATEMENT_PART');
END;
/

--
-- Now re-check plans and costs
--

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

EXPLAIN PLAN
   FOR
      SELECT /*+ full(t) */
             COUNT (*)
        FROM statement_part t
       WHERE transaction_date = DATE '2013-01-06';

SELECT * FROM TABLE (DBMS_XPLAN.display);