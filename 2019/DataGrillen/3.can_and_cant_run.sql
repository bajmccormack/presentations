-- Works
SELECT 
	@@VERSION,
	@@SERVERNAME as servername,
	GETDATE() as datetimenow


EXEC sp_configure

dbcc tracestatus


--TempDB
SELECT NAME, * from tempdb.sys.sysfiles;

-- You can ALTER DATABASE to increase file sizes if needed.

CREATE DATABASE MyNewDB 

-- Doesn't work
DBCC CHECKDB('rdsadmin')

EXEC sp_configure 'optimize for ad hoc workloads', 1

DROP DATABASE MyNewDB  
-- Instead, try EXECUTE msdb.dbo.rds_drop_database  N'MyNewDB'

ALTER DATABASE AdventureWorks2012 Modify Name = AdventureWorksArchive2 ;

-- Instead try EXEC rdsadmin.dbo.rds_modify_db_name N'AdventureWorks2012', N'AdventureWorksArchive2'

