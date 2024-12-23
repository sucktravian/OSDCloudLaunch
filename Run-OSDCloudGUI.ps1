#================================================
#   [PreOS] Update Module
#================================================
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force -SkipPublisherCheck

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force 

Start-OSDCloudGUIDEV

pause
# Check if BitLocker is enabled on C: drive and disable it if necessary
$mountPoint = "C:"
$bitlockerStatus = Get-BitLockerVolume -MountPoint $mountPoint

# Check if BitLocker needs to be disabled
if ($bitlockerStatus.ProtectionStatus -ne 'Off') {
    Write-Host "BitLocker is enabled. Disabling BitLocker on $mountPoint..."
    Disable-BitLocker -MountPoint $mountPoint

    # Wait until the volume is fully decrypted
    do {
        Start-Sleep -Seconds 5  # Wait for 5 seconds before checking again
        $bitlockerStatus = Get-BitLockerVolume -MountPoint $mountPoint
        Write-Host "Current VolumeStatus: $($bitlockerStatus.VolumeStatus). Waiting for 'FullyDecrypted'..."
    } while ($bitlockerStatus.VolumeStatus -ne 'FullyDecrypted')

    Write-Host "BitLocker has been successfully disabled and the volume is fully decrypted on $mountPoint."
} else {
    # If already disabled, check the VolumeStatus
    if ($bitlockerStatus.VolumeStatus -eq 'FullyDecrypted') {
        Write-Host "BitLocker is already disabled, and the volume is fully decrypted on $mountPoint. Proceeding..."
    } else {
        Write-Host "BitLocker is disabled, but the volume is not fully decrypted. Please check the status manually."
    }
}

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

#$unattendPath = "C:\OSDCloud\Temp\unattend.xml"
$unattendPath = "D:\unattend.xml"
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
}

