Write-Host  -ForegroundColor Cyan "Starting Custom OSDCloud ..."
Start-Sleep -Seconds 5
pause
#Make sure I have the latest OSD Content
Write-Host  -ForegroundColor Cyan "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Cyan "Importing OSD PowerShell Module"
Import-Module OSD -Force


#Start OSDCloud ZTI change os when neeeded
Write-Host  -ForegroundColor Cyan "Start OSDCloud custom parameters"
Start-OSDCloud -OSName 'Windows 11 23H2 x64' -OSEdition Pro -OSLanguage ja-jp -OSActivation Retail -SkipAutopilot -ZTI

Write-Host  -ForegroundColor Cyan "Starting OSDCloud PostAction ..."
Write-Warning "I'm not sure of what to put here yet"

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
pause
wpeutil reboot
