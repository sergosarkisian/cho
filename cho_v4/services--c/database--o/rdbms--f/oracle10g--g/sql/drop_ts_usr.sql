ALTER SYSTEM SET UNDO_RETENTION = 10;
DROP TABLESPACE #TBLSPC# INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;
DROP USER #USR# CASCADE; 
