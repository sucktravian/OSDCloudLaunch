#================================================
#   [PreOS] Update Module
#================================================
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

Write-Host  -ForegroundColor Cyan "Starting Custom OSDCloud ..."
Start-Sleep -Seconds 5

Write-Host  -ForegroundColor Cyan "Updating OSD PowerShell Module"
Install-Module OSD -Force -SkipPublisherCheck

Write-Host  -ForegroundColor Cyan "Importing OSD PowerShell Module"
Import-Module OSD -Force

$Global:MyOSDCloud = [ordered]@{
    OSImageIndex = '6'
}

Write-Output $Global:MyOSDCloud

#=======================================================================
#   [OS] Params and Start-OSDCloud
#=======================================================================
$Params = @{
    OSVersion = "Windows 11"
    OSBuild = "23H2"
    OSEdition = "Pro"
    OSLanguage = "ja-jp"
    OSLicense = "Retail"
    ZTI = $true
    Firmware = $false
}
Start-OSDCloud @Params

#================================================
#  [PostOS] OOBEDeploy Configuration
#================================================


#================================================
#  [PostOS] OOBE CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Downloading and creating script for OOBE phase"

Write-Host  -ForegroundColor Cyan "Downloading unattend.xml from repository"
# Raw url
$unattendURL = "https://raw.githubusercontent.com/sucktravian/OSDCloudLaunch/main/unattend.xml"
# Path to the Sysprep folder
$unattendPath = "C:\OSDCloud\Temp\unattend.xml"

# Attempt to download the unattend.xml file
try {
    Invoke-WebRequest -Uri $unattendURL -OutFile $unattendPath
    Write-Host  -ForegroundColor Green "Unattend.xml downloaded successfully to $unattendPath"
} catch {
    Write-Host  -ForegroundColor Red "Failed to download unattend.xml from $unattendURL. Error: $_"
    exit
}

# Verify if the file was copied to the Sysprep folder
if (Test-Path $unattendPath) {
    Write-Host  -ForegroundColor Green "Unattend.xml is present in the Sysprep folder."
} else {
    Write-Host  -ForegroundColor Red "Unattend.xml was not found in the Sysprep folder."
}


$OOBECMD = @'
@echo off
# Execute OOBE Tasks
start /wait powershell.exe -NoL -ExecutionPolicy Bypass -F C:\Windows\Setup\Scripts\RunSysprep.ps1
start /wait powershell.exe -NoL -ExecutionPolicy Bypass
exit 
'@
$OOBECMD | Out-File -FilePath 'C:\Windows\Setup\scripts\oobe.cmd' -Encoding ascii -Force

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
