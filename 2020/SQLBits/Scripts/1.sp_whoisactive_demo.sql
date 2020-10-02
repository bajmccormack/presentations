USE DBA -- Or whichever DB you have created sp_whoisactive in.

EXEC sp_whoisactive 
	@find_block_leaders = 1, -- Will show lead blocker and how many spids it is blocking
	@get_plans = 1, -- Returns query plan
	@get_locks = 1, -- Returns lock information
	@get_full_inner_text = 1 -- Will show proc name if any


-- Create job for log to table
USE [msdb]
GO

BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'sp_whoisactive_log_to_table', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Log output of sp_whoisactive every x minutes', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Write output to table]    Script Date: 02/10/2020 16:49:30 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Write output to table', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'IF NOT EXISTS ( SELECT 1 FROM dba.sys.tables WHERE NAME = ''sp_whoisactive_log'')
BEGIN
CREATE TABLE dba.dbo.sp_whoisactive_log
(
id INT IDENTITY(1,1) PRIMARY KEY,
[dd hh:mm:ss:mss] VARCHAR(20) NULL,
session_id SMALLINT NOT NULL,
sql_text XML NULL,
login_name sysname NULL,
wait_info NVARCHAR(4000) NULL,
CPU VARCHAR(30) NULL,
tempdb_allocations VARCHAR(30) NULL,
tempdb_current VARCHAR(30) NULL,
blocking_session_id SMALLINT NULL,
blocked_session_count VARCHAR(30) NULL,
reads VARCHAR(30) NULL,
writes VARCHAR(30) NULL,
physical_reads VARCHAR(30) NULL,
query_plan XML NULL,
locks XML NULL,
used_memory VARCHAR(30) NULL,
[status] VARCHAR(30) NULL,
open_tran_count VARCHAR(30) NULL,
percent_complete VARCHAR(30) NULL,
[host_name] sysname NULL,
[database_name] sysname NULL,
[program_name] sysname NULL,
start_time datetime NULL,
login_time datetime NULL,
request_id SMALLINT NULL,
collection_time datetime NULL
)
CREATE INDEX idx_collection_time ON dba.dbo.sp_whoisactive_log (collection_time)
END

/* Load data into table.
If you want to change parameters, you will likely need to add columns to table
*/ 
EXEC sp_whoisactive @get_locks = 1, @find_block_leaders = 1, @get_plans = 1, @destination_table = ''sp_whoisactive_log''', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Delete old rows', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DELETE dba.dbo.sp_whoisactive_log
WHERE collection_time < DATEADD(MONTH,-3,GETDATE())', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every x minutes', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=10, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20200209, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

-- Read from table
SELECT * 
FROM dba.dbo.sp_whoisactive_log
WHERE collection_time > '2020-09-04 00:00:00.000'
ORDER BY id DESC

