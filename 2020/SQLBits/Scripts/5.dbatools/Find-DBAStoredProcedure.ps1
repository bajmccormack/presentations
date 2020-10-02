# Find all procs with serializable transactrion isolation level
Find-DbaStoredProcedure -SqlInstance 'localhost' -Pattern 'SERIALIZABLE' | Select-Object * | Out-Gridview
