connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/create_db/postDBCreation.log
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup mount;
archive log start;
alter database archivelog;
alter database open;
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
create or replace directory export as '/media/storage/as/oracle/data/export/';
create or replace directory import as '/media/storage/as/oracle/data/import/';
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
spool /media/storage/as/oracle/logs/create_db/postDBCreation.log
exit;
