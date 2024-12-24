
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
################################################################################
#                              SYSPREP                                         #
################################################################################


Write-Warning "Looking for unattend.xml"
if (-not(Test-Path -Path D:\OSDCloud\unattend\unattend.xml)) {
    Write-Host "unattend.xml cannot be found" -ForegroundColor Red -ErrorAction Stop  
}

# Define sysprep executable and arguments
$sysprep = "$env:WINDIR\System32\Sysprep\sysprep.exe"
$ar = "/generalize /reboot /oobe /unattend:D:\OSDCloud\unattend\unattend.xml"

do {
    try {
        Write-Host "Starting Sysprep..." -ForegroundColor Cyan
        Start-Process -FilePath $sysprep -ArgumentList $ar -Wait
        Start-Sleep 2
        Write-Host "Sysprep completed successfully!" -ForegroundColor Green
        break
    }
    catch {
        Write-Host "Sysprep failed. Diagnosing the issue..." -ForegroundColor Red
        $Error[0]
        
        # Path to the sysprep error log
        $setuperrPath = "$env:SystemDrive\Windows\Panther\setuperr.log"
        if (Test-Path $setuperrPath) {
            Write-Host "Checking setuperr.log for Appx package errors..." -ForegroundColor Yellow
            
            # Read the log and look for package-related errors
            $logContent = Get-Content -Path $setuperrPath
            $problemPackages = $logContent | Select-String -Pattern "-package"

            if ($problemPackages) {
                Write-Host "Found problematic Appx packages:" -ForegroundColor Cyan
                $problemPackages | ForEach-Object {
                    Write-Host $_.Line -ForegroundColor White

                    # Extract the package name from the error message
                    $packageName = ($_ -split ":")[-1].Trim()
                    if ($packageName) {
                        Write-Host "Attempting to remove package: $packageName" -ForegroundColor Yellow
                        
                        # Remove the package for all users
                        try {
                            Remove-AppxPackage -Package $packageName -AllUsers -ErrorAction Stop
                            Write-Host "Successfully removed package: $packageName" -ForegroundColor Green
                        }
                        catch {
                            Write-Warning "Failed to remove AppxPackage $packageName. Trying provisioning package removal..."
                            try {
                                Remove-AppxProvisionedPackage -Online -PackageName $packageName -ErrorAction Stop
                                Write-Host "Successfully removed provisioned package: $packageName" -ForegroundColor Green
                            }
                            catch {
                                Write-Error "Failed to remove provisioned package $packageName."
                            }
                        }
                    }
                }

                # Delete the setuperr.log file after processing
                try {
                    Remove-Item -Path $setuperrPath -Force -ErrorAction Stop
                    Write-Host "Deleted setuperr.log to prepare for the next Sysprep attempt." -ForegroundColor Green
                }
                catch {
                    Write-Error "Failed to delete setuperr.log. Ensure you have sufficient permissions."
                }
            }
            else {
                Write-Host "No Appx package errors found in setuperr.log." -ForegroundColor Green
            }
        }
        else {
            Write-Error "setuperr.log not found. Cannot diagnose Sysprep failure."
        }

        Write-Host "Retrying Sysprep..." -ForegroundColor Cyan
    }
} until ($false) # Continue until sysprep is successful


