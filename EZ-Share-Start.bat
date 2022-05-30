@echo off
echo. >> EZ-Share.ps1
echo #END >> EZ-Share.ps1
findstr /v "#END" EZ-Share.ps1 > EZ-Share-temp.ps1
del EZ-Share.ps1
copy EZ-Share-temp.ps1 EZ-Share.ps1
del EZ-Share-temp.ps1
PowerShell -ExecutionPolicy Bypass ./EZ-Share.ps1


