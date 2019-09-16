SELECT @@VERSION
-- Restore database doesn't work - We need to use RDS stored procedures
-- Option Group - Allow SQLSERVER_BACKUP_RESTORE option


-- Does it like this?
exec msdb.dbo.rds_restore_database
@restore_db_name='WideWorldImporters',
@s3_arn_to_restore_from='arn:aws:s3:::bucket_name/WideWorldImporters-Full.bak'


exec msdb.dbo.rds_task_status
-- Why not?
-- Due to filestream data not supported in RDS


-- Does it like this
exec msdb.dbo.rds_restore_database
@restore_db_name='AdventureWorks2012',
@s3_arn_to_restore_from='arn:aws:s3:::bucket_name/AdventureWorks2012.bak'


exec msdb.dbo.rds_task_status
-- Yes

-- Restoring a striped backup
-- To restore from a multiple file backup, provide the prefix the files have in common, 
-- then suffix that with an asterisk (*). 

exec msdb.dbo.rds_restore_database
@restore_db_name='database_name',
@s3_arn_to_restore_from='arn:aws:s3:::bucket_name/bakup_file_*' 


-- Doesn't give us anything useful for backup/restore
SELECT percent_complete pc,* 
FROM sys.dm_exec_requests
order by pc desc

-- So just run this
exec msdb.dbo.rds_task_status