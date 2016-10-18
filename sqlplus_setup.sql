SET ECHO ON PAGES 900 LINES 132
COLUMN PLAN_TABLE_OUTPUT FORMAT a200
-- Set the current schema as you wish
ALTER SESSION SET CURRENT_SCHEMA=book;
-- Ensure that procedures and functions can access objects
GRANT DBA,SELECT ANY TABLE TO book;