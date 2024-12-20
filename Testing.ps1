
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

