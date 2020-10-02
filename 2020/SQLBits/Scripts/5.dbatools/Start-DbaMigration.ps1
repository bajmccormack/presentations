$dcred = (Get-Credential)

$params = @{
    Source = "localhost"
    Destination = "policecloudsql.uksouth.cloudapp.azure.com"
    DestinationSqlCredential = $dcred
    SharedPath = "https://zerobudgetdba.blob.core.windows.net/databasebackups"
    BackupRestore = $true
    Force = $true
    }
   
Start-DbaMigration @params -Verbose 

















Copy-DbaDatabase -Source localhost -Destination  -Database "AnalysisDB" -BackupRestore -SharedPath "\\zerobudgetdba.file.core.windows.net\cloudmigration\Migration" -DestinationSqlCredential $dcred

Copy-DbaDatabase -Source localhost -Destination "policecloudsql.uksouth.cloudapp.azure.com" -DestinationSqlCredential $dcred `
-Database AnalysisDB -BackupRestore -SharedPath https://zerobudgetdba.blob.core.windows.net/databasebackups

Start-DbaMigration -Source localhost -Destination "policecloudsql.uksouth.cloudapp.azure.com" -BackupRestore -SharedPath "\\zerobudgetdba.file.core.windows.net\cloudmigration\Migration"`
-SourceSqlCredential $scred -DestinationSqlCredential $dcred