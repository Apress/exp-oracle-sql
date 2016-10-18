copy %~dp0\example_schemas_stats.dmp c:\temp
echo create or replace directory expert_oracle_sql as 'c:\temp'; > c:\temp\expert_oracle_sql_temp.sql
echo drop user book cascade;  >> c:\temp\expert_oracle_sql_temp.sql
echo create user book identified by book; >> c:\temp\expert_oracle_sql_temp.sql
echo grant dba,select any table to book; >> c:\temp\expert_oracle_sql_temp.sql
echo alter system set db_file_multiblock_read_count=128 scope=both; >> c:\temp\expert_oracle_sql_temp.sql
echo exec dbms_stats.delete_system_stats; >> c:\temp\expert_oracle_sql_temp.sql
echo drop user scott cascade; >> c:\temp\expert_oracle_sql_temp.sql
echo @?\rdbms\admin\scott >> c:\temp\expert_oracle_sql_temp.sql
echo exit >> c:\temp\expert_oracle_sql_temp.sql
sqlplus -s / as sysdba < c:\temp\expert_oracle_sql_temp.sql
impdp book/book dumpfile=example_schemas_stats.dmp directory=expert_oracle_sql nologfile=yes
echo drop directory expert_oracle_sql; > c:\temp\expert_oracle_sql_temp.sql
echo exit >> c:\temp\expert_oracle_sql_temp.sql
sqlplus -s / as sysdba < c:\temp\expert_oracle_sql_temp.sql
del c:\temp\expert_oracle_sql_temp.sql c:\temp\example_schemas_stats.dmp