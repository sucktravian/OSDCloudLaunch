chcp 65001
Write-Host  -ForegroundColor Cyan "Starting Custom OSDCloud ..."
Start-Sleep -Seconds 5
pause
#Make sure I have the latest OSD Content
# Start-OSDCloud -OSName 'Windows 11 23H2 x64' -SkipAutopilot $true -Firmware $false -ZTI $true -OSEdition Pro -OSLanguage ja-jp -OSActivation Retail
Write-Host  -ForegroundColor Cyan "Updating OSD PowerShell Module"
Install-Module OSD -Force -SkipPublisherCheck

Write-Host  -ForegroundColor Cyan "Importing OSD PowerShell Module"
Import-Module OSD -Force

$Global:MyOSDCloud = [ordered]@{
    OSImageIndex = '6'
}

Write-Output $Global:MyOSDCloud

Write-Host  -ForegroundColor Cyan "Start OSDCloud custom parameters"
Start-OSDCloud -OSName 'Windows 11 23H2 x64' -SkipAutopilot -Firmware -ZTI -OSEdition Pro -OSLanguage ja-jp -OSActivation Retail
$OOBEDeployJson = @'
{
    "AddNetFX3":  {
                      "IsPresent":  true
                  },
    "Autopilot":  {
                      "IsPresent":  false
                  },
    "RemoveAppx":  [
                    "Microsoft.Microsoft3DViewer",
                    "Microsoft.BingSearch",
                    "Clipchamp.Clipchamp",
                    "Microsoft.Windows.DevHome",
                    "MicrosoftCorporationII.MicrosoftFamily",
                    "Microsoft.MixedReality.Portal",
                    "Microsoft.Office.OneNote",
                    "Microsoft.OutlookForWindows",
                    "MicrosoftTeams",
                    "MSTeams",
                    
                    "MicrosoftCorporationII.QuickAssist",
                    "Microsoft.SkypeApp",
                    "Microsoft.BingWeather",
                    "Microsoft.BingNews",
                    "Microsoft.GamingApp",
                    "Microsoft.GetHelp",
                    "Microsoft.Getstarted",
                    "Microsoft.Messaging",
                    "Microsoft.MicrosoftOfficeHub",
                    "Microsoft.MicrosoftSolitaireCollection",
                    "Microsoft.People",
                    "Microsoft.PowerAutomateDesktop",
                    "Microsoft.StorePurchaseApp",
                    "Microsoft.Todos",
                    "Microsoft.Wallet",
                    "Microsoft.XboxApp",
                    "microsoft.windowscommunicationsapps",
                    "Microsoft.WindowsFeedbackHub",
                    "Microsoft.WindowsMaps",
                    "Microsoft.WindowsSoundRecorder",
                    "Microsoft.Xbox.TCUI",
                    "Microsoft.XboxGameOverlay",
                    "Microsoft.XboxGamingOverlay",
                    "Microsoft.XboxIdentityProvider",
                    "Microsoft.XboxSpeechToTextOverlay",
                    "Microsoft.YourPhone",
                    "Microsoft.ZuneMusic",
                    "Microsoft.ZuneVideo"
                   ],
    "UpdateDrivers":  {
                          "IsPresent":  true
                      },
    "UpdateWindows":  {
                          "IsPresent":  true
                      }
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$OOBEDeployJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json" -Encoding ascii -Force

Write-Host  -ForegroundColor Cyan "Downloading unattend.xml from repository"
# Raw url
$unattendURL = "https://raw.githubusercontent.com/sucktravian/OSDCloudLaunch/main/unattend.xml"
# Path to the Sysprep folder
$unattendPath = "C:\Windows\System32\Sysprep\unattend.xml"

# Check if the Sysprep folder exists
if (Test-Path "C:\Windows\System32\Sysprep") {
    Write-Host  -ForegroundColor Green "Sysprep folder found at X:\Windows\System32\Sysprep"
} else {
    Write-Host  -ForegroundColor Red "Sysprep folder not found. Please check if the path is correct."
    exit
}
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

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
