[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

#Window
$objForm = New-Object System.Windows.Forms.Form
$objForm.Size = New-Object System.Drawing.Size(800,500)
$objForm.Font = New-Object System.Drawing.Font("Calibri",11,[System.Drawing.FontStyle]::Italic)
$objForm.Text = "EZ-Share"
$objForm.BackColor = "white"
$CenterScreen = [System.Windows.Forms.FormStartPosition]::CenterScreen;
$objForm.StartPosition = $CenterScreen;

#Text
$objLabel_File = New-Object System.Windows.Forms.Label
$objLabel_File.Location = New-Object System.Drawing.Size(28,10)
$objLabel_File.Size = New-Object System.Drawing.Size (500,33)
$objLabel_File.Font = New-Object System.Drawing.Font ("Calibri,20")
$objLabel_File.Text = "Bitte wählen Sie einen Ordner aus"
$objForm.Controls.Add($objLabel_File)

$objLabel_File = New-Object System.Windows.Forms.Label
$objLabel_File.Location = New-Object System.Drawing.Size(28,200)
$objLabel_File.Size = New-Object System.Drawing.Size (110,30)
$objLabel_File.Text = "Username:"
$objForm.Controls.Add($objLabel_File)

$objLabel_File = New-Object System.Windows.Forms.Label
$objLabel_File.Location = New-Object System.Drawing.Size(28,250)
$objLabel_File.Size = New-Object System.Drawing.Size (110,30)
$objLabel_File.Text = "Password:"
$objForm.Controls.Add($objLabel_File)

# Text Boxes
$objTextBox_File = New-Object System.Windows.Forms.TextBox
$objTextBox_File.Location = New-Object System.Drawing.Size (30,45)
$objTextBox_File.Size = New-Object System.Drawing.Size (600, 400)
$objForm.Controls.Add($objTextBox_File)

$objTextBox_UN = New-Object System.Windows.Forms.Textbox
$objTextBox_UN.Location = New-Object System.Drawing.Size (150,200)
$objTextBox_UN.Size = New-Object System.Drawing.Size (400, 300)
$objForm.Controls.Add($objTextBox_UN)

$objTextBox_PW = New-Object System.Windows.Forms.Textbox
$objTextBox_PW.Location = New-Object System.Drawing.Size (150,250)
$objTextBox_PW.Size = New-Object System.Drawing.Size (400, 300)
$objForm.Controls.Add($objTextBox_PW)

#Buttons
$Button_Start = New-Object System.Windows.Forms.Button
$Button_Start.Location = New-Object System.Drawing.Size (300,350)
$Button_Start.Size = New-Object System.Drawing.Size (80,40)
$Button_Start.Text = "Start"
$Button_Start.Name = "Start Button"
$objForm.Controls.Add($Button_Start)

$Button_Stopp = New-Object System.Windows.Forms.Button
$Button_Stopp.Location = New-Object System.Drawing.Size (400,350)
$Button_Stopp.Size = New-Object System.Drawing.Size (80,40)
$Button_Stopp.Text = "Stopp"
$Button_Stopp.Name = "Stopp Button"
$objForm.Controls.Add($Button_Stopp)

#Checkbox
$Checkbox_R = New-Object System.Windows.Forms.Checkbox 
$Checkbox_R.Location = New-Object System.Drawing.Size(100,80) 
$Checkbox_R.Size = New-Object System.Drawing.Size(100,20)
$Checkbox_R.Text = "Read"
#$Checkbox_R.TabIndex = 4
$objForm.Controls.Add($Checkbox_R)

$Checkbox_RW = New-Object System.Windows.Forms.Checkbox 
$Checkbox_RW.Location = New-Object System.Drawing.Size(300,80) 
$Checkbox_RW.Size = New-Object System.Drawing.Size(300,20)
$Checkbox_RW.Text = "Read/Write"
#$Checkbox_RW.TabIndex = 4
$objForm.Controls.Add($Checkbox_RW)

#Button Folder + Folder Browser + Folder Pick 
$Button_FolderPick = New-Object System.Windows.Forms.Button
$Button_FolderPick.Location = New-Object System.Drawing.Size (660,35)
$Button_FolderPick.Size = New-Object System.Drawing.Size (90,40)
$Button_FolderPick.Text = "Browse"
$Button_FolderPick.Name = "Folder Pick"
$objForm.Controls.Add($Button_FolderPick)
$Button_FolderPick.Add_Click({
Function Get-Folder($initialDirectory) {
    [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    $FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowserDialog.RootFolder = 'MyComputer'
    if ($initialDirectory) { $FolderBrowserDialog.SelectedPath = $initialDirectory }
    [void] $FolderBrowserDialog.ShowDialog()
    return $FolderBrowserDialog.SelectedPath
}
($FolderPermissions = Get-Folder C:\Users | get-acl | select -exp access | ft)

})

[void] $objForm.ShowDialog()