#step1 :copy sql database 

#Connect-AzAccount
#Connect-AzAccount
#set-AzContext -Subscription "Azure subscription 1"


$directoryTenantId="xxxxxxx"
$applicationId="xxxxxx"
$secretValue="xxxxx"
$secretId="xxxxx"

$resourceGroupName = "rg_one"
$ServerName = "homebnrserver"
$DatabaseName = "homebnrbase"
$CopyDatabaseName = "copyhomebnrbase"
$StorageKeytype= "StorageAccessKey"
$StorageKey = "xxxxxxxxx"
$BacpacUri = "https://bnrstoragehome.blob.core.windows.net/backupauto/backup.bacpac"

$adminUserName="xxxxx"

#$adminPassword="xxxxx" 
#$passwordCryp=ConvertTo-SecureString -String "xxxx"
$SecureStringPwdd = ConvertTo-SecureString "xxxxxx" -AsPlainText -Force

$spAppId="xxxx"
$tenantId="xxxxxdcd5"

$SecureStringPwd = ConvertTo-SecureString "xxxxxxxh9Gha10bp7" -AsPlainText -Force

$pscredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $spAppId, $SecureStringPwd

Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId


<# #step 1 copy database
 [Console]::Write("Step 1 : copy whole database `n")

New-AzSqlDatabaseCopy -ResourceGroupName $resourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName `
    -CopyResourceGroupName $resourceGroupName -CopyServerName $ServerName -CopyDatabaseName $CopyDatabaseName 

[Console]::Write("Step 1 : Finished `n")  #>


# #Step 2 : export bacpac file to immutable storage

$exportRequest = New-AzSqlDatabaseExport -ResourceGroupName $resourceGroupName -ServerName $ServerName `
  -DatabaseName $CopyDatabaseName -StorageKeytype $StorageKeytype -StorageKey $StorageKey -StorageUri $BacpacUri `
  -AdministratorLogin $adminUserName -AdministratorLoginPassword $SecureStringPwdd
#check status

  $exportStatus = Get-AzSqlDatabaseImportExportStatus -OperationStatusLink $exportRequest.OperationStatusLink
  [Console]::Write("Exporting")
  while ($exportStatus.Status -eq "InProgress")
  {
      Start-Sleep -s 10
      $exportStatus = Get-AzSqlDatabaseImportExportStatus -OperationStatusLink $exportRequest.OperationStatusLink
      [Console]::Write(".")
  }
  [Console]::WriteLine("")
  $exportStatus
  [Console]::Write("Finished //Step 2 :  export bacpac file to immutable storage")
