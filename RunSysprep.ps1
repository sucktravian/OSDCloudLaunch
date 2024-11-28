Import-Module OSD -Force
Invoke-Expression (Invoke-RestMethod sandbox.osdcloud.com)
Invoke-Expression (Invoke-RestMethod functions.osdcloud.com)
# Check if bitlocker is active and disable it
$bitlockerStatus = Get-BitLockerVolume -MountPoint "C:"

if ($bitlockerStatus.ProtectionStatus -eq "On") {
    Write-Host "BitLocker is enabled on drive C:. Disabling BitLocker..." -ForegroundColor Yellow
    Disable-BitLocker -MountPoint "C:"
    Write-Host "Decryption process started. Monitor progress with Get-BitLockerVolume." -ForegroundColor Green
} else {
    Write-Host "BitLocker is already disabled on drive C:." -ForegroundColor Green
}
# Update Drivers
UpdateDrivers
UpdateWindows

Pause
$unattendPath = "C:\OSDCloud\Temp\unattend.xml"
Write-Warning "Searching for unattend.xml"
    if (-not(Test-Path -Path $unattendPath )) {
        Write-Host "unattend.xml not found" -ForegroundColor Red -ErrorAction Stop  
    }
    try {
        $sysprep = "C:\Windows\System32\Sysprep\sysprep.exe"
        $ar = "/generalize /reboot /oobe /unattend:$unattendPath"
        Start-Process -FilePath $sysprep -ArgumentList $ar -Wait
        Start-Sleep 2
    }
    catch {
        Write-Host "sysprep failed to run"
        $Error[0]
        Pause
    }
