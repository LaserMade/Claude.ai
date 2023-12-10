$installedapps = get-AppxPackage
$ids = $null
foreach ($app in $installedapps)
{
try
{
$ids = (Get-AppxPackageManifest $app -erroraction Stop).package.applications.application.id
}
catch
{
Write-Output "No Id's found for $($app.name)"
}
foreach ($id in $ids)
{
$line = $app.Name + "	" + $app.packagefamilyname + "!" + $id
echo $line
$line >> 'C:\Users\bacona\AppData\Local\Temp\_QAP_temp_670517384\CollectWindowsAppsList.tsv'
}
}
# write-host "Press any key to continue..."
# [void][System.Console]::ReadKey($true)
