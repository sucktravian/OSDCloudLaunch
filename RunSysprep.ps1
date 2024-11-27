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
