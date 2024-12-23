if (!(Get-Module PSWindowsUpdate -ListAvailable)) {
    try {
        Install-Module PSWindowsUpdate -Force
        Import-Module PSWindowsUpdate -Force
    }
    catch {
        Write-Warning 'Unable to install PSWindowsUpdate Windows Updates'
    }
}
<#
if (Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore) {
    Write-Host -ForegroundColor DarkCyan 'Add-WUServiceManager -MicrosoftUpdate -Confirm:$false'
    Add-WUServiceManager -MicrosoftUpdate -Confirm:$false
    Write-Host -ForegroundColor DarkCyan 'Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot'
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot -NotTitle 'Preview' -NotKBArticleID 'KB890830', 'KB5005463', 'KB4481252'
}
#>
Import-Module OSD -Force
Invoke-Expression (Invoke-RestMethod functions.osdcloud.com)
# Update Drivers
UpdateDrivers
UpdateWindows