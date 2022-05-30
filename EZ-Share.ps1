#remove this line, if you read the readme
#-------------------------------------------------------------------------------------------
#Libraries
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null

<#if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-windowstyle hidden -File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
 Exit
}#>


#-------------------------------------------------------------------------------------------
#Window
$objform = New-Object System.Windows.Forms.Form
$objform.Size = New-Object System.Drawing.Size(800, 500)
$objform.Font = New-Object System.Drawing.Font("Calibri",11,[System.Drawing.FontStyle]::Bold)
$objform.Text = "EZ-Share"
$objform.BackColor = "white"

$center_screen = [System.Windows.Forms.FormStartPosition]::CenterScreen;
$objform.StartPosition = $center_screen;

#-------------------------------------------------------------------------------------------
#Text username
$label_un = New-Object System.Windows.Forms.Label
$label_un.Location = New-Object System.Drawing.Size (28,200)
$label_un.Size = New-Object System.Drawing.Size (115,30)
$label_un.Text = "Benutzername:"
$objform.Controls.Add($label_un)

#-------------------------------------------------------------------------------------------
# Text box + input username
$textbox_un = New-Object System.Windows.Forms.TextBox
$textbox_un.Location = New-Object System.Drawing.Size (150,200)
$textbox_un.Size = New-Object System.Drawing.Size (400, 30)
$textbox_un.Multiline = $true
$textbox_un.Font = New-Object System.Drawing.Font ("Calibri", 14,[System.Drawing.FontStyle]::Regular)
$objform.Controls.Add($textbox_un)

$username = $textbox_un.Text

#-------------------------------------------------------------------------------------------
#Text password
$label_pw = New-Object System.Windows.Forms.Label
$label_pw.Location = New-Object System.Drawing.Size(28,250)
$label_pw.Size = New-Object System.Drawing.Size (110,30)
$label_pw.Text = "Passwort:"
$objform.Controls.Add($label_pw)

#-------------------------------------------------------------------------------------------
# Text box + input password
$textbox_pw = New-Object System.Windows.Forms.TextBox
$textbox_pw.Location = New-Object System.Drawing.Size (150,250)
$textbox_pw.Size = New-Object System.Drawing.Size (400, 30)
$textbox_pw.Multiline = $true
$textbox_pw.Font = New-Object System.Drawing.Font ("Calibri", 14,[System.Drawing.FontStyle]::Regular)
$objform.Controls.Add($textbox_pw)

$password = $textbox_pw.Text

#-------------------------------------------------------------------------------------------
#Create button
$button_create = New-Object System.Windows.Forms.Button
$button_create.Location = New-Object System.Drawing.Size (320,300)
$button_create.Size = New-Object System.Drawing.Size (100,40)
$button_create.Text = "Erstellen"
$button_create.Name = "Erstellen Button"
$objform.Controls.Add($button_create)
$button_create.Add_Click({Button_Erstellen_Click})

#-------------------------------------------------------------------------------------------
#Radio button read + read/write 

$groupBox = New-Object System.Windows.Forms.GroupBox 
$groupBox.Location = New-Object System.Drawing.Size(200,80) 
$groupBox.size = New-Object System.Drawing.Size(300,40) 
$objform.Controls.Add($groupBox)

$radiobutton_r = New-Object System.Windows.Forms.RadioButton 
$radiobutton_r.Location = new-object System.Drawing.Point(15,15) 
$radiobutton_r.size = New-Object System.Drawing.Size(80,20) 
$radiobutton_r.Checked = $true 
$radiobutton_r.Text = "Lesen" 
$groupBox.Controls.Add($radiobutton_r) 

$radiobutton_rW = New-Object System.Windows.Forms.RadioButton 
$radiobutton_rW.Location = new-object System.Drawing.Point(150,15) 
$radiobutton_rW.size = New-Object System.Drawing.Size(145,20) 
$radiobutton_rW.Checked = $false 
$radiobutton_rW.Text = "Lesen/Schreiben" 
$groupBox.Controls.Add($radiobutton_rW) 

#-------------------------------------------------------------------------------------------
# Text box folder
$textbox_file = New-Object System.Windows.Forms.TextBox
$textbox_file.Location = New-Object System.Drawing.Size (30,45)
$textbox_file.Size = New-Object System.Drawing.Size (600, 30)
$textbox_file.Multiline = $true
$textbox_file.Font = New-Object System.Drawing.Font ("Calibri", 14,[System.Drawing.FontStyle]::Regular)

$objform.Controls.Add($textbox_file)

#-------------------------------------------------------------------------------------------
#Text file
$label_file = New-Object System.Windows.Forms.Label
$label_file.Location = New-Object System.Drawing.Size(28,10)
$label_file.Size = New-Object System.Drawing.Size (500,33)
$label_file.Text = "Bitte wählen Sie einen Ordner aus:"
$objform.Controls.Add($label_file)

#-------------------------------------------------------------------------------------------
#Button folder + folder browser + folder pick
$button_folder_pick = New-Object System.Windows.Forms.Button
$button_folder_pick.Location = New-Object System.Drawing.Size (660,43)
$button_folder_pick.Size = New-Object System.Drawing.Size (90,35)
$button_folder_pick.Text = "..."
$button_folder_pick.Name = "Folder Pick"
$objform.Controls.Add($button_folder_pick)
$button_folder_pick.Add_Click({Select-FolderDialog})

#-------------------------------------------------------------------------------------------
#Text error path
$label_error_path = New-Object System.Windows.Forms.Label
$label_error_path.Location = New-Object System.Drawing.Size(300,370)
$label_error_path.Size = New-Object System.Drawing.Size (500,33)
$label_error_path.Text = "Kein Ordner ausgewählt!"

#-------------------------------------------------------------------------------------------
#Text error username
$label_error_username = New-Object System.Windows.Forms.Label
$label_error_username.Location = New-Object System.Drawing.Size(300,370)
$label_error_username.Size = New-Object System.Drawing.Size (500,33)
$label_error_username.Text = "Kein Username eingegeben!"

#-------------------------------------------------------------------------------------------
#Text error password
$label_error_password = New-Object System.Windows.Forms.Label
$label_error_password.Location = New-Object System.Drawing.Size(300,370)
$label_error_password.Size = New-Object System.Drawing.Size (500,33)
$label_error_password.Text = "Kein Passwort eingegeben!"

#-------------------------------------------------------------------------------------------
#Function folder select
function Select-FolderDialog  
{
    param([String]$description="Folder Pick", 
    [String]$root_folder="Desktop")   
   
    $objform2 = New-Object System.Windows.Forms.FolderBrowserDialog
    $objform2.Rootfolder = $root_folder
    $objform2.Description = $description
    $show = $objform2.ShowDialog()
    if ($show -eq 'OK')
    {
        $textbox_file.Text = $objform2.SelectedPath
    }
}

#-------------------------------------------------------------------------------------------
#Function button "Erstellen"
Function Button_Erstellen_Click() 
{
    $folderpath = $textbox_file.Text
    $username = $textbox_un.Text
    $password = ConvertTo-SecureString $textbox_pw.Text -AsPlainText -Force

    if ($folderpath -eq ""){
        $objform.Controls.Add($label_error_path) 
    }
    elseif($username -eq "")
    {
    $objform.Controls.Remove($label_error_path)
    $objform.Controls.Add($label_error_username)
    }
    elseif($textbox_pw.Text -eq "")
    {
    $objform.Controls.Remove($label_error_path)
    $objform.Controls.Remove($label_error_username)
    $objform.Controls.Add($label_error_password)   
    }
    else
    {
    $objform.Controls.Remove($label_error_path)
    $objform.Controls.Remove($label_error_username)
    $objform.Controls.Remove($label_error_password)
    
    $objform.Controls.Remove($button_create)
    
    New-LocalUser -Name $username -Description "EZ-Share Benutzeraccount" -Password $password

    if ($radiobutton_r.Checked -eq $true)
    {
        New-SmbShare -Name EZ-Share -Path $folderpath -Temporary -EncryptData $True -ReadAccess $username
    }
    else
    {
        New-SmbShare -Name EZ-Share -Path $folderpath -Temporary -EncryptData $True -FullAccess $username
    }

    $folder=get-acl $folderpath
    $addaccess = New-Object System.Security.AccessControl.FileSystemAccessRule("$env:COMPUTERNAME\$username","FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $folder.SetAccessRule($addaccess)
    $folder | Set-Acl $folderpath

#-------------------------------------------------------------------------------------------
#Text IP
    $center_screen = New-Object System.Windows.Forms.Label
    $center_screen.Location = New-Object System.Drawing.Size (250,375)
    $center_screen.Size = New-Object System.Drawing.Size (280,30)
    $ipv4 = (Get-netipconfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"} |Get-NetIPAddress| Select -ExpandProperty IPv4Address)
    $center_screen.Text = "IP:\\$ipv4\EZ-Share"
    $objform.Controls.Add($center_screen)

#-------------------------------------------------------------------------------------------
#Copy button IP
    $button_copy = New-Object System.Windows.Forms.Button
    $button_copy.Location = New-Object System.Drawing.Size (530,373)
    $button_copy.Size = New-Object System.Drawing.Size (70,35)
    $button_copy.Text = "Kopieren"
    $button_copy.Name = "Copy Pick"
    $objform.Controls.Add($button_copy)
    $button_copy.Add_Click({Copy_Click})

#-------------------------------------------------------------------------------------------
#Button "Löschen" + remove button "Erstellen"  
    $button_delete = New-Object System.Windows.Forms.Button
    $button_delete.Location = New-Object System.Drawing.Size (320,300)
    $button_delete.Size = New-Object System.Drawing.Size (100,40)
    $button_delete.Text = "Löschen"
    $button_delete.Name = "Löschen Button"  
    $objform.Controls.Add($button_delete)
    $button_delete.Add_Click({Button_Löschen_Click})
    }
}

#-------------------------------------------------------------------------------------------
#Function button "Löschen"
Function Button_Löschen_Click() {
    $folderpath = $textbox_file.Text
    $username = $textbox_un.Text

    $folder=get-acl $folderpath
    $addaccess = New-Object System.Security.AccessControl.FileSystemAccessRule("$env:COMPUTERNAME\$username","FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $folder.RemoveAccessRule($addaccess)
    $folder | Set-Acl $folderpath

    Remove-SmbShare -Name EZ-Share -Force
    Remove-LocalUser -Name $username
    $objform.Close()

}


Function Copy_Click() {
    $ipv4 = (Get-netipconfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -ne "Disconnected"} |Get-NetIPAddress| Select -ExpandProperty IPv4Address)
    Set-Clipboard -Value "\\$ipv4\EZ-Share"
}
$rs = $objform.ShowDialog()