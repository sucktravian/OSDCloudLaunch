function Update-WindowsWithPSWindowsUpdate {
    # Ensure PSWindowsUpdate module is available
    if (!(Get-Module PSWindowsUpdate -ListAvailable)) {
        try {
            Write-Host "Installing and importing PSWindowsUpdate module..."
            Install-Module PSWindowsUpdate -Force
            Import-Module PSWindowsUpdate -Force
        }
        catch {
            Write-Warning 'Unable to install PSWindowsUpdate for Windows Updates'
            return
        }
    }

    # Check if PSWindowsUpdate module is successfully loaded
    if (Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore) {
        Write-Host -ForegroundColor DarkCyan "Adding Microsoft Update service..."
        Add-WUServiceManager -MicrosoftUpdate -Confirm:$false

        Write-Host -ForegroundColor DarkCyan "Installing updates from Microsoft Update..."
        Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot `
            -NotTitle 'Preview' `
            -NotKBArticleID 'KB890830', 'KB5005463', 'KB4481252'
    }
    else {
        Write-Warning "PSWindowsUpdate module is not available. Ensure it is correctly installed."
    }
}
