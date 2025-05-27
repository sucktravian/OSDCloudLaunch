
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

Write-Host  -ForegroundColor Cyan "Start OSDCloud custom parameters"
Start-OSDCloudGUI
