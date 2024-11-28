Import-Module OSD -Force
Invoke-Expression (Invoke-RestMethod functions.osdcloud.com)


# Check if BitLocker is enabled on C: drive and wait until it's disabled
$mountPoint = "C:"
$bitlockerStatus = Get-BitLockerVolume -MountPoint $mountPoint
# Wait until BitLocker is disabled
while ($bitlockerStatus.ProtectionStatus -ne 'Off') {
    Write-Host "BitLocker is still enabled. Waiting..."
    Start-Sleep -Seconds 5  # Wait for 5 seconds before checking again
    $bitlockerStatus = Get-BitLockerVolume -MountPoint $mountPoint
}
Write-Host "BitLocker is disabled. Proceeding..."
# Get the current size of C: drive
$disk = Get-Partition -DriveLetter C
$size = $disk | Select-Object -ExpandProperty Size
$currentSizeGB = [math]::round($size / 1GB, 2)

Write-Host "Current size of C: drive is $currentSizeGB GB."

# Check if there is enough free space on C: drive
if ($currentSizeGB -le 100) {
    Write-Host "The C: drive is already 100 GB or smaller. No shrink operation needed."
}
else {
    # Shrink the C: drive to 100 GB
    $newSizeBytes = 100GB
    Write-Host "Shrinking the C: drive to 100 GB..."
    
    # Resize the partition to 100 GB (100 * 1024^3 bytes)
    Resize-Partition -DriveLetter C -Size $newSizeBytes

    Write-Host "C: drive has been successfully shrunk to 100 GB."
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
