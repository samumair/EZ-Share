@echo off
echo.>> EZ-Share.ps1
FINDSTR /R /I /V "^$ Footer" EZ-Share.ps1 >> EZ-Share-temp.ps1
del EZ-Share.ps1
copy EZ-Share-temp.ps1 EZ-Share.ps1
del EZ-Share-temp.ps1
PowerShell -ExecutionPolicy Bypass ./EZ-Share.ps1

