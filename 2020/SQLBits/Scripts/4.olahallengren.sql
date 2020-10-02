USE DBA

-- Fully documented at https://ola.hallengren.com/
-- Create the agent jobs with the solution, and customise/schedule as appropriate


-- Rebuild and reorganize indexes for all user DBs except Crimedata.
-- Reorganize indexes if between 5% and 30% fragmention and > 1000 pages
-- Rebuild indexes online if option is available and fragementation > 30% and > 1000 pages, else reorganize
-- Only defrag indexes more than 100
-- Log to command log table
-- Update statistics
-- Only use one processor
-- Don't start any new commands after 60 minutes
EXECUTE [dbo].[IndexOptimize]
@Databases = 'USER_DATABASES, -CrimeData',
@FragmentationLow = NULL,
@FragmentationMedium = 'INDEX_REORGANIZE',
@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REORGANIZE',
@FragmentationLevel1 = 5,
@FragmentationLevel2 = 30,
@MinNumberOfPages = 1000,
@UpdateStatistics = 'ALL',
@OnlyModifiedStatistics = 'Y',
@TimeLimit = 60,
@MaxDOP = 1, 
@LogToTable = 'Y'


-- CommandLog queries
SELECT * 
FROM DBA.dbo.CommandLog
ORDER BY ID DESC

SELECT * 
FROM DBA.dbo.CommandLog
WHERE ErrorNumber > 0
OR EndTime IS NULL
ORDER BY ID DESC


-- Backup to disk, using compression
EXECUTE dbo.DatabaseBackup
@Databases = 'Redgate',
@Directory = 'E:\Backup',
@BackupType = 'FULL',
@Compress = 'Y',
@Verify = 'Y',
@LogtoTable = 'Y'


-- Backup all user databases except Redgate to Azure Blob Storage, using compression
EXECUTE dbo.DatabaseBackup
@Databases = 'USER_DATABASES, -Redgate',
@URL = 'https://zerobudgetdba.blob.core.windows.net/databasebackups',
@BackupType = 'FULL',
@Compress = 'Y',
@Verify = 'Y'


/*
	You can keep CommandLog up to date by regularly deleting old data.
	A SQL Agent job is provided for this purpose
*/