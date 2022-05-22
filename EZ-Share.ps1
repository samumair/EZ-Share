#-------------------------------------------------------------------------------------------
#Libraries
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-WindowStyle Hidden -File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
 Exit
}


#-------------------------------------------------------------------------------------------
#Window
$objForm = New-Object System.Windows.Forms.Form
$objForm.Size = New-Object System.Drawing.Size(800, 500)
$objForm.Font = New-Object System.Drawing.Font("Calibri",11,[System.Drawing.FontStyle]::Bold)
$objForm.Text = "EZ-Share"
$objForm.BackColor = "white"

$CenterScreen = [System.Windows.Forms.FormStartPosition]::CenterScreen;
$objForm.StartPosition = $CenterScreen;

#-------------------------------------------------------------------------------------------
#Text IP
$Label_IP = New-Object System.Windows.Forms.Label
$Label_IP.Location = New-Object System.Drawing.Size (250,375)
$Label_IP.Size = New-Object System.Drawing.Size (280,30)
$ipv4 = (Get-netipconfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"} |Get-NetIPAddress| Select -ExpandProperty IPv4Address)
$Label_IP.Text = "IP:\\$ipv4\EZ-Share"
$objForm.Controls.Add($Label_IP)

#-------------------------------------------------------------------------------------------
#Copy Button IP
$Button_Copy = New-Object System.Windows.Forms.Button
$Button_Copy.Location = New-Object System.Drawing.Size (530,373)
$Button_Copy.Size = New-Object System.Drawing.Size (70,35)
$Button_Copy.Text = "Copy"
$Button_Copy.Name = "Copy Pick"
$objForm.Controls.Add($Button_Copy)
$Button_Copy.Add_Click({Copy_Click})

#-------------------------------------------------------------------------------------------
#Text Username
$Label_UN = New-Object System.Windows.Forms.Label
$Label_UN.Location = New-Object System.Drawing.Size (28,200)
$Label_UN.Size = New-Object System.Drawing.Size (115,30)
$Label_UN.Text = "Username:"
$objForm.Controls.Add($Label_UN)

#-------------------------------------------------------------------------------------------
# Text Box + Input Username
$TextBox_UN = New-Object System.Windows.Forms.TextBox
$TextBox_UN.Location = New-Object System.Drawing.Size (150,200)
$TextBox_UN.Size = New-Object System.Drawing.Size (400, 30)
$TextBox_UN.Multiline = $true
$TextBox_UN.Font = New-Object System.Drawing.Font ("Calibri", 14,[System.Drawing.FontStyle]::Regular)
$objForm.Controls.Add($TextBox_UN)

$Username = $TextBox_UN.Text

#-------------------------------------------------------------------------------------------
#Text Password
$Label_PW = New-Object System.Windows.Forms.Label
$Label_PW.Location = New-Object System.Drawing.Size(28,250)
$Label_PW.Size = New-Object System.Drawing.Size (110,30)
$Label_PW.Text = "Password:"
$objForm.Controls.Add($Label_PW)

#-------------------------------------------------------------------------------------------
# Text Box + Input Password
$TextBox_PW = New-Object System.Windows.Forms.TextBox
$TextBox_PW.Location = New-Object System.Drawing.Size (150,250)
$TextBox_PW.Size = New-Object System.Drawing.Size (400, 30)
$TextBox_PW.Multiline = $true
$TextBox_PW.Font = New-Object System.Drawing.Font ("Calibri", 14,[System.Drawing.FontStyle]::Regular)
$objForm.Controls.Add($TextBox_PW)

$Password = $TextBox_PW.Text

#-------------------------------------------------------------------------------------------
#Button Erstellen
$Button_Erstellen = New-Object System.Windows.Forms.Button
$Button_Erstellen.Location = New-Object System.Drawing.Size (320,300)
$Button_Erstellen.Size = New-Object System.Drawing.Size (100,40)
$Button_Erstellen.Text = "Erstellen"
$Button_Erstellen.Name = "Erstellen Button"
$objForm.Controls.Add($Button_Erstellen)
$Button_Erstellen.Add_Click({Button_Erstellen_Click})

#-------------------------------------------------------------------------------------------
#Radio Button Read + Read/Write 

$groupBox = New-Object System.Windows.Forms.GroupBox 
$groupBox.Location = New-Object System.Drawing.Size(200,80) 
$groupBox.size = New-Object System.Drawing.Size(300,40) 
$objForm.Controls.Add($groupBox)

$RadioButton_R = New-Object System.Windows.Forms.RadioButton 
$RadioButton_R.Location = new-object System.Drawing.Point(15,15) 
$RadioButton_R.size = New-Object System.Drawing.Size(80,20) 
$RadioButton_R.Checked = $true 
$RadioButton_R.Text = "Read" 
$groupBox.Controls.Add($RadioButton_R) 

$RadioButton_RW = New-Object System.Windows.Forms.RadioButton 
$RadioButton_RW.Location = new-object System.Drawing.Point(150,15) 
$RadioButton_RW.size = New-Object System.Drawing.Size(145,20) 
$RadioButton_RW.Checked = $false 
$RadioButton_RW.Text = "Read/Write" 
$groupBox.Controls.Add($RadioButton_RW) 

#-------------------------------------------------------------------------------------------
# Text Box Folder
$TextBox_File = New-Object System.Windows.Forms.TextBox
$TextBox_File.Location = New-Object System.Drawing.Size (30,45)
$TextBox_File.Size = New-Object System.Drawing.Size (600, 30)
$TextBox_File.Multiline = $true
$TextBox_File.Font = New-Object System.Drawing.Font ("Calibri", 14,[System.Drawing.FontStyle]::Regular)

$objForm.Controls.Add($TextBox_File)

#-------------------------------------------------------------------------------------------
#Text File
$Label_File = New-Object System.Windows.Forms.Label
$Label_File.Location = New-Object System.Drawing.Size(28,10)
$Label_File.Size = New-Object System.Drawing.Size (500,33)
$Label_File.Text = "Bitte wählen Sie einen Ordner aus:"
$objForm.Controls.Add($Label_File)

#-------------------------------------------------------------------------------------------
#Button Folder + Folder Browser + Folder Pick
$Button_FolderPick = New-Object System.Windows.Forms.Button
$Button_FolderPick.Location = New-Object System.Drawing.Size (660,43)
$Button_FolderPick.Size = New-Object System.Drawing.Size (90,35)
$Button_FolderPick.Text = "..."
$Button_FolderPick.Name = "Folder Pick"
$objForm.Controls.Add($Button_FolderPick)
$Button_FolderPick.Add_Click({Select-FolderDialog})


#-------------------------------------------------------------------------------------------
#Function Folder select
function Select-FolderDialog  
{
    param([String]$Description="Folder Pick", 
    [String]$RootFolder="Desktop")   
   
    $objForm2 = New-Object System.Windows.Forms.FolderBrowserDialog
    $objForm2.Rootfolder = $RootFolder
    $objForm2.Description = $Description
    $Show = $objForm2.ShowDialog()
    if ($Show -eq 'OK')
    {
        $TextBox_File.Text = $objForm2.SelectedPath
    }
}

#-------------------------------------------------------------------------------------------
#Function Button "Erstellen"
Function Button_Erstellen_Click() {
    $folderpath = $TextBox_File.Text
    $Username = $TextBox_UN.Text
    $Password = ConvertTo-SecureString $TextBox_PW.Text -AsPlainText -Force

    New-LocalUser -Name $Username -Description "EZ-Share Benutzeraccount" -Password $Password

    if ($RadioButton_R.Checked -eq $true)
    {
        Write-Host "Read" -ForegroundColor Yellow
        New-SmbShare -Name EZ-Share -Path $folderpath -Temporary -EncryptData $True -ReadAccess $Username
    }
    else
    {
        Write-Host "Read/Write" -ForegroundColor Yellow
        New-SmbShare -Name EZ-Share -Path $folderpath -Temporary -EncryptData $True -FullAccess $Username
    }

    $folder=get-acl $folderpath
    $addaccess = New-Object System.Security.AccessControl.FileSystemAccessRule("$env:COMPUTERNAME\$Username","FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $folder.SetAccessRule($addaccess)
    $folder | Set-Acl $folderpath

#-------------------------------------------------------------------------------------------
#Button "Löschen" + remove Button "Erstellen"  
    $objform.Controls.Remove($Button_Erstellen)
    $Button_Löschen = New-Object System.Windows.Forms.Button
    $Button_Löschen.Location = New-Object System.Drawing.Size (320,300)
    $Button_Löschen.Size = New-Object System.Drawing.Size (100,40)
    $Button_Löschen.Text = "Löschen"
    $Button_Löschen.Name = "Löschen Button"  
    $objForm.Controls.Add($Button_Löschen)
    $Button_Löschen.Add_Click({Button_Löschen_Click})
}

#-------------------------------------------------------------------------------------------
#Function Button "Löschen"
Function Button_Löschen_Click() {
    $folderpath = $TextBox_File.Text
    $Username = $TextBox_UN.Text
    

    $folder=get-acl $folderpath
    $addaccess = New-Object System.Security.AccessControl.FileSystemAccessRule("$env:COMPUTERNAME\$Username","FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $folder.RemoveAccessRule($addaccess)
    $folder | Set-Acl $folderpath

    Remove-SmbShare -Name EZ-Share -Force
    Remove-LocalUser -Name $Username

}

Function Copy_Click() {
    $ipv4 = (Get-netipconfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"} |Get-NetIPAddress| Select -ExpandProperty IPv4Address)
    Set-Clipboard -Value "\\$ipv4\EZ-Share"
}
$rs = $objForm.ShowDialog()