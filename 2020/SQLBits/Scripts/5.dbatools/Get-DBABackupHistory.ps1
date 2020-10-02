Get-DbaBackupHistory -SqlInstance 'localhost' -Database "WideWorldImporters" | Select-Object * | out-gridview

Get-DbaBackupHistory -SqlInstance 'localhost'  -Since '00:00:00 02/01/2020' | Where-Object { $_.Type -eq "Full" } | Select-Object * | out-gridview

Get-DbaBackupHistory -SqlInstance 'localhost' -Last | Where-Object { $_.Type -eq "Full" } | Select-Object * | out-gridview


# Restore a database to a point in time
$RestoreTime = Get-Date('22:16:25 09/02/2020')
Get-DbaBackupHistory -SqlInstance 'localhost' -Database "WideWorldImporters" | Restore-DbaDatabase -SqlInstance "localhost" -DatabaseName "WideWorldImporters" `
-UseDestinationDefaultDirectories -RestoreTime $RestoreTime  #-OutputScriptOnly #to run restore

