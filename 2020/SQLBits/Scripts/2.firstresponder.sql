USE DBA

-- Healthcheck
EXEC sp_blitz; -- Healthcheck (Remove the priority 1 errors and work your way up the list)


EXEC dbo.sp_BlitzFirst -- What is happening/hurting me RIGHT NOW


-- What have been my most expensive queries (Most useful in production, as dev environments can get refreshed regularly)
EXEC dbo.sp_BlitzCache
	@SortOrder = 'Reads', -- CPU, Reads, Writes, Duration, Executions, compiles, memory grant, spills for sort order 
	@top = 10 -- The higher the number, the more expensive the query will be

-- Analyzes the design and performance of your indexes.
EXEC dbo.sp_BlitzIndex @mode = 4
EXEC dbo.sp_BlitzIndex @DatabaseName = N'CrimeData', @SchemaName='dbo', @TableName='DPD__911_Calls_for_Service'; -- Change to you own table names
