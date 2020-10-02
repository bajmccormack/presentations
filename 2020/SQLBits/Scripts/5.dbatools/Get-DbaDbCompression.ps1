Get-DbaDbCompression -SqlInstance "localhost" -Database WideWorldImporters | 
Select-Object Database, Schema, TableName, IndexName, IndexType, Partition, DataCompression | Out-GridView 