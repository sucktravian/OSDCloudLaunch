if (!(Get-Module PSWindowsUpdate -ListAvailable)) {
    try {
        Install-Module PSWindowsUpdate -Force
        Import-Module PSWindowsUpdate -Force
    }
    catch {
        Write-Warning 'Unable to install PSWindowsUpdate Windows Updates'
    }
}
Import-Module OSD -Force
Invoke-Expression (Invoke-RestMethod functions.osdcloud.com)
UpdateDrivers
