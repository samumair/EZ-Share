[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
#-------------------------------------------------------------------------------------------
#Window-frame
$objForm = New-Object System.Windows.Forms.Form
$objForm.Size = New-Object System.Drawing.Size(800, 500)
$objForm.Font = New-Object System.Drawing.Font("Calibri",11,[System.Drawing.FontStyle]::Bold)
$objForm.Text = "EZ-Share"
$objForm.BackColor = "white"

$CenterScreen = [System.Windows.Forms.FormStartPosition]::CenterScreen;
$objForm.StartPosition = $CenterScreen;
#-------------------------------------------------------------------------------------------
#Text File
$Label_File = New-Object System.Windows.Forms.Label
$Label_File.Location = New-Object System.Drawing.Size(28,10)
$Label_File.Size = New-Object System.Drawing.Size (500,33)
$Label_File.Text = "Bitte wählen Sie einen Ordner aus:"
$objForm.Controls.Add($Label_File)
#-------------------------------------------------------------------------------------------
# Text Box Folder
$TextBox_File = New-Object System.Windows.Forms.TextBox
$TextBox_File.Location = New-Object System.Drawing.Size (30,45)
$TextBox_File.Size = New-Object System.Drawing.Size (600, 400)
$TextBox_File.Height = 70
$objForm.Controls.Add($TextBox_File)
#-------------------------------------------------------------------------------------------
#Text File
$Label_File = New-Object System.Windows.Forms.Label
$Label_File.Location = New-Object System.Drawing.Size(28,10)
$Label_File.Size = New-Object System.Drawing.Size (500,33)
$Label_File.Text = "Bitte wählen Sie einen Ordner aus:"
$objForm.Controls.Add($Label_File)
#Text File
$Label_File = New-Object System.Windows.Forms.Label
$Label_File.Location = New-Object System.Drawing.Size(28,10)
$Label_File.Size = New-Object System.Drawing.Size (500,33)
$Label_File.Text = "Bitte wählen Sie einen Ordner aus:"
$objForm.Controls.Add($Label_File)
#-------------------------------------------------------------------------------------------
#Button Folder + Folder Browser + Folder Pick
$Button_FolderPick = New-Object System.Windows.Forms.Button
$Button_FolderPick.Location = New-Object System.Drawing.Size (660,35)
$Button_FolderPick.Size = New-Object System.Drawing.Size (90,40)
$Button_FolderPick.Text = "..."
$Button_FolderPick.Name = "Folder Pick"

$objForm.Controls.Add($Button_FolderPick)
$Button_FolderPick.Add_Click({
Function Get-Folder($initialDirectory) {
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.RootFolder = 'C:\Users\$env:USERNAME\Desktop'
    if ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }
    [void] $FolderBrowserDialog.ShowDialog()
    return $FolderBrowserDialog.SelectedPath
}
($FolderPermissions = Get-Folder C:\Users\$env:USERNAME | get-acl | select -exp access | ft)

})
#-------------------------------------------------------------------------------------------
#---------------------------------Backend---------------------------------------------------
#-------------------------------------------------------------------------------------------
#variables for share, will be modified later by GUI
$folderpath="C:\Users\" #must be a fully qualified path
$user=('EZ-Share')
$password=ConvertTo-SecureString "123456"-AsPlainText -Force
$run=$True

New-LocalUser -Name $user -Description "EZ-Share Benutzeraccount" -Password $password

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

#Get-SmbShare 
[void] $objForm.ShowDialog()
