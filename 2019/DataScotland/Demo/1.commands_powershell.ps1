# Install-Module -Name AWSPowerShell
Set-AWSCredentials -StoredCredentials myAWScredentials


# Get-Help is your friend, a good editor helps too :)
Get-Help New-RDSDBInstance -ShowWindow


# Describe Instance
Get-RDSDBInstance -region "eu-central-1"


# Describe Instance, easier to read and relevant columns
Get-RDSDBInstance -Region "eu-central-1" `
    | Select-Object DBInstanceIdentifier, DBInstanceStatus, Engine, EngineVersion, DBInstanceClass, DBInstanceArn `
    | Out-Gridview


# Create database instance - Much quicker than GUI
New-RDSDBInstance `
    -dbinstanceidentifier "datascotland-posh" `
    -region "eu-central-1" `
    -VpcSecurityGroupId "sg-00a1234g567c3d4ab" `
    -allocatedstorage 20 `
    -dbinstanceclass "db.t2.micro" `
    -engine "sqlserver-ex" `
    -masterusername "rds_name" `
    -masteruserpassword "secure_pw_here" `
    -availabilityzone "eu-central-1a" `
    -port 50000 `
    -engineversion "14.00.3049.1.v1"


# Start a stopped instance - Useful for starting non prod instances out of hours
Start-RDSDBInstance -dbinstanceidentifier "datascotland-stopped" -Region "eu-central-1"


# Stop a RDS instance - Useful for starting non prod instances out of hours
Stop-RDSDBInstance -dbinstanceidentifier "datascotland-stopped" -Region "eu-central-1"


# Create Snapshot
New-RDSDBSnapshot `
    -DBInstanceIdentifier "datascotland1" `
    -DBSnapshotIdentifier "datascotland1-keep-20190913" `
    -Region "eu-central-1"


# Describe Snapshot(s)
Get-RDSDBSnapshot -Region "eu-central-1" 
Get-RDSDBSnapshot `
    -Region "eu-central-1" `
    | Select-Object DBInstanceIdentifier,DBSnapshotIdentifier,SnapshotType,SnapshotCreateTime,Status `
    | Out-Gridview


# Remove Snapshot(s)
Remove-RDSDBSnapshot -DBSnapshotIdentifier "datagrillen1-final-snapshot" -Region "eu-central-1" -Force


# Restore database - Can use the same params are New-RDSDBInstance.
# If you don't it inherits the params from the original instance
Restore-RDSDBInstanceFromDBSnapshot `
    -DBInstanceIdentifier "datascotland-restore-from-datagrillen1" `
    -DBSnapshotIdentifier "datagrillen1-final-snapshot" `
    -Region "eu-central-1"


#Delete instance
Remove-RDSDBInstance `
    -DBInstanceIdentifier "datascotland2" `
    -Region "eu-central-1" `
    -SkipFinalSnapshot 1 `
    -Force


# Show Cloudwatch metrics in console if time allows


# Blog post
https://johnmccormack.it/2019/09/data-scotland-2019-presentation/


# Pre talk instance status
# datascotland1                             available
# datascotland2                             stopped
# datascotland-stopped                      stopped
# datascotland-posh                         not yet created
# datascotland-restore-from-datagrillen1    not yet created