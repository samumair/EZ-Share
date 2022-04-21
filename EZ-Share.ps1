#variables for share, will be modified later by GUI
$folderpath="C:\Users\Samuel\Desktop" #must be a fully qualified path
$user=('Samuel')

$run=$True

if ($run -eq $True)
{
    Write-Output "create share"
    New-SmbShare -Name EZ-Share -Path $folderpath -Temporary -EncryptData $True -ReadAccess $user
}

if ($run -notlike $True)
{
    Write-Output "delete share"
    Remove-SmbShare -Name EZ-Share -Force
}

Get-SmbShare 