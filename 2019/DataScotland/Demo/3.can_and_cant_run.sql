-- Works
SELECT 
	@@VERSION,
	@@SERVERNAME as servername,
	GETDATE() as datetimenow

EXEC sp_configure

DBCC tracestatus
-- 3226 - Suppress successful backup messages
-- 7806 - Enable Dedicated Administrator connection in SQL Express edition
-- 8017 - Controls whether SQL Server creates schedulers for all logical processors

CREATE DATABASE MyNewDB 

USE dba
EXEC sp_whoisactive 
-- Doesn't come with RDS, you need to install


-- Doesn't work
EXEC sp_configure 'optimize for ad hoc workloads', 1

DROP DATABASE MyNewDB  
-- Instead, try 
EXECUTE msdb.dbo.rds_drop_database  N'MyNewDB'

ALTER DATABASE AdventureWorks2012 Modify Name = AdventureWorksArchive2 ;

-- Instead try 
EXEC rdsadmin.dbo.rds_modify_db_name N'AdventureWorks2012', N'AdventureWorksArchive2'

-- Error Logs
USE [rdsadmin]
GO
EXEC [dbo].[rds_read_error_log]

-- Works
EXEC sp_readerrorlog

-- Doesn't work
EXEC xp_readerrorlog
