Write-Host  -ForegroundColor Cyan "Starting Custom OSDCloud ..."
Start-Sleep -Seconds 5
pause
#Make sure I have the latest OSD Content
Write-Host  -ForegroundColor Cyan "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Cyan "Importing OSD PowerShell Module"
Import-Module OSD -Force

$Global:MyOSDCloud = [ordered]@{
    OSImageIndex = '6'
}

Write-Output $Global:MyOSDCloud

#Start OSDCloud ZTI change os when neeeded
Write-Host  -ForegroundColor Cyan "Start OSDCloud custom parameters"
Start-OSDCloud -OSName 'Windows 11 23H2 x64' -OSEdition Pro -OSLanguage ja-jp -OSActivation Retail -SkipAutopilot -ZTI

Write-Host  -ForegroundColor Cyan "Downloading unattend.xml from repository"

# Raw url
$unattendURL = "https://raw.githubusercontent.com/sucktravian/OSDCloudLaunch/main/unattend.xml"

# Path to the Sysprep folder
$unattendPath = "X:\Windows\System32\Sysprep\unattend.xml"

# Download the unattend.xml file from repository
Invoke-WebRequest -Uri $unattendURL -OutFile $unattendPath

# Verify if the download was successful
if (Test-Path $unattendPath) {
    Write-Host  -ForegroundColor Green "Unattend.xml downloaded successfully to $unattendPath"
} else {
    Write-Host  -ForegroundColor Red "Failed to download unattend.xml"
}

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
pause
wpeutil reboot
