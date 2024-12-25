function Update-DriverWithPSWindowsUpdate {
    $pnpe = Get-CimInstance Win32_PNPEntity
    if ($pnpe.ConfigManagerErrorCode -gt 0) {
        if (!(Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore)) {
            try {
                Install-Module PSWindowsUpdate -Force
                Import-Module PSWindowsUpdate -Force
            }
            catch {
                Write-Warning 'Unable to install PSWindowsUpdate Driver Updates'
                return
            }
        }
        if (Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore) {
            Write-Host "Installing driver updates..."
            Install-WindowsUpdate -UpdateType Driver -AcceptAll -IgnoreReboot
        }
    }
    else {
        Write-Host "Drivers are already up to date."
    }
}
