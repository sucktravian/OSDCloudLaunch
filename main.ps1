param(
    [string]$TaskFilePath = "C:\IDM\Task.json"
)

Write-Host "Import module Setting"
Import-Module "C:\OSDCloud\Scripts\SettingModule\Setting.psm1"

# Check connection
Test-InternetConnection -Site google.com -Wait 2 -Mode Active

# Set the current script to run after reboot
Set-RbRsScript -settask $true -ScriptName "C:\OSDCloud\Scripts\main.ps1"

# Ensure required modules are installed
Install-PackageProvider -Name NuGet -Force
Install-Module -Name PowerShellGet -SkipPublisherCheck -Force
Install-Module OSD -Force
Import-Module -Name OSD

# Set Power Configuration to High Performance
Invoke-Exe powercfg.exe -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Suspend power-saving features
Suspend-PowerSaving
Get-PowerSavingStatus

# Run tasks from JSON
Invoke-TasksFromJson -JsonPath $TaskFilePath

Write-Host "All tasks have been completed!" -ForegroundColor Green
