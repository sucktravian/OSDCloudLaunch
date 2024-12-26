function Invoke-SysprepWithUnattend {
    param (
        [string]$UnattendPath = "C:\OSDCloud\Scripts\Unattend.xml",
        [string]$SysprepArgs = "/generalize /reboot /oobe",
        [switch]$Verbose
    )
    Write-Warning "Looking for unattend.xml"

    if (-not (Test-Path -Path $UnattendPath)) {
        Write-Host "unattend.xml cannot be found" -ForegroundColor Red -ErrorAction Stop  
    }

    # Define sysprep executable and arguments
    $sysprep = "$env:WINDIR\System32\Sysprep\sysprep.exe"
    $fullArgs = "$SysprepArgs /unattend:$UnattendPath"
    $retryCount = 0
    $maxRetries = 3

    do {
        try {
            Write-Host "Starting Sysprep (attempt $($retryCount + 1))..." -ForegroundColor Cyan

            # Start the process and capture the exit code
            $process = Start-Process -FilePath $sysprep -ArgumentList $fullArgs -Wait -PassThru

            # Check the exit code of Sysprep
            if ($process.ExitCode -eq 0) {
                Write-Host "Sysprep completed successfully!" -ForegroundColor Green
                break
            } else {
                Write-Host "Sysprep failed with exit code $($process.ExitCode). Diagnosing the issue..." -ForegroundColor Red
                throw "Sysprep failed"
            }
        }
        catch {
            # Handle Sysprep failure
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

            $retryCount++
            if ($retryCount -ge $maxRetries) {
                Write-Host "Exceeded maximum retries. Sysprep cannot continue." -ForegroundColor Red
                break
            }
            Write-Host "Retrying Sysprep..." -ForegroundColor Cyan
        }
    } while ($true)
}
Invoke-SysprepWithUnattend