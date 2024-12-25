param(
    [string]$TaskFilePath = "C:\IDM\Task.json"
)

Write-Host "Import module Setting"
Import-Module "C:\OSDCloud\Scripts\SettingModule\Setting.psm1"

# Check connection
Test-InternetConnection -Site google.com -Wait 2 -Mode Active

# Set the current script to run after reboot
Set-RbRsScript -settask $true -ScriptName "C:\OSDCloud\Scripts\main.ps1"

if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -Force
}

# Install PowerShellGet module if not already installed
if (-not (Get-InstalledModule -Name PowerShellGet -ErrorAction SilentlyContinue)) {
    Install-Module -Name PowerShellGet -SkipPublisherCheck -Force
}

# Install OSD module if not already installed
if (-not (Get-InstalledModule -Name OSD -ErrorAction SilentlyContinue)) {
    Install-Module -Name OSD -Force
}
Import-Module -Name OSD

# Set Power Configuration to High Performance
Invoke-Exe powercfg.exe -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# Suspend power-saving features
Suspend-PowerSaving

# Run tasks from JSON
Invoke-TasksFromJson -JsonPath $TaskFilePath

