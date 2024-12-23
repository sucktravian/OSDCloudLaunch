Import-Module "C:\IDM\SettingModule\Setting.psm1"

if ((Get-CimInstance Win32_PNPEntity).ConfigManagerErrorCode -gt 0 ) {
    # Install or update drivers/software base on Manufacturer
    $manufacturer = (Get-CimInstance win32_computersystem).Manufacturer
    switch -Wildcard ($manufacturer) {
        "*Dell*" {
            function Update-DellDrivers {
                $primaryUrl = "https://dl.dell.com/FOLDER11914128M/1/Dell-Command-Update-Windows-Universal-Application_9M35M_WIN_5.4.0_A00.EXE"
                $fallbackFilePath = "C:\Custom\DellCommandUpdateURL.txt"
                $installerPath = "$env:TEMP\DELL_COMMAND_UPDATE.exe"
                $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
        
                function Get-DellLink {
                    param (
                        [string]$url
                    )
                    try {
                        Write-Host "Downloading from $url..."
                        Invoke-WebRequest -Uri $url -OutFile $installerPath -UserAgent $userAgent
                        return $true
                    }
                    catch {
                        Write-Host "Failed to download from $url. Error: $_"
                        return $false
                    }
                }
    
                if (-not (Get-DellLink -url $primaryUrl)) {
                    if (Test-Path $fallbackFilePath) {
                        $fallbackUrl = Get-Content $fallbackFilePath
                        if (Get-DellLink -url $fallbackUrl) {
                            Write-Host "Fallback URL used successfully."
                        }
                        else {
                            Write-Host "Failed to download from fallback URL. Exiting."
                            return
                        }
                    }
                    else {
                        Write-Host "Fallback URL file not found. Exiting."
                        return
                    }
                }
                Write-Host "Installing Dell Command Update..."
                Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
                Write-Host "Running Dell Command Update to check and install updates..."
                $dellCommandUpdatePath = "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe"
                if (Test-Path $dellCommandUpdatePath) {
                    Start-Process -FilePath $dellCommandUpdatePath -ArgumentList "/applyupdates" -Wait
                }
                else {
                    Write-Host "Dell Command Update executable not found. Ensure it's installed correctly."
                }
                # Clean up installer file
                if (Test-Path $installerPath) {
                    Write-Host "Deleting installer file..."
                    Remove-Item -Path $installerPath -Force
                }
            }
            Update-DellDrivers
            break
        }
        "*HP*" { 
            function Get-HpDrivers {
                param (
                    [string]$url,
                    [string]$outputPath
                )
                $userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
                try {
                    Write-Host "Downloading from $url..."
                    Invoke-WebRequest -Uri $url -OutFile $outputPath -UserAgent $userAgent
                    return $true
                }
                catch {
                    Write-Host "Failed to download from $url. Error: $_"
                    return $false
                }
            }   
            function Get-HPImageAssistant {
                param (
                    [string]$primaryUrl = "https://hpia.hpcloud.hp.com/downloads/hpia/hp-hpia-5.3.0.exe",
                    [string]$fallbackFilePath = "C:\Custom\HPImageAssistant.txt"
                )
                $installerPath = "$env:TEMP\HPImageAssistant.exe"
                if (-not (Get-HpDrivers -url $primaryUrl -outputPath $installerPath)) {
                    if (Test-Path $fallbackFilePath) {
                        $fallbackUrl = Get-Content $fallbackFilePath
                        if (Get-HpDrivers -url $fallbackUrl -outputPath $installerPath) {
                            Write-Host "Fallback URL used successfully."
                        }
                        else {
                            Write-Host "Failed to download from fallback URL. Exiting."
                            return $null
                        }
                    }
                    else {
                        Write-Host "Fallback URL file not found. Exiting."
                        return $null
                    }
                }
                return $installerPath
            }
            function Get-HPProgrammableKey {
                param (
                    [string]$primaryUrl = "https://ftp.hp.com/pub/softpaq/sp149501-150000/sp149853.exe",
                    [string]$fallbackFilePath = "C:\Custom\HPProgrammableKey.txt"
                )

                $installerPath = "$env:TEMP\HPProgrammableKey.exe"

                if (-not (Get-HpDrivers -url $primaryUrl -outputPath $installerPath)) {
                    if (Test-Path $fallbackFilePath) {
                        $fallbackUrl = Get-Content $fallbackFilePath
                        if (Get-HpDrivers -url $fallbackUrl -outputPath $installerPath) {
                            Write-Host "Fallback URL used successfully."
                        }
                        else {
                            Write-Host "Failed to download from fallback URL. Exiting."
                            return $null
                        }
                    }
                    else {
                        Write-Host "Fallback URL file not found. Exiting."
                        return $null
                    }
                }

                return $installerPath
            }

            # Function to install HP Image Assistant and related drivers
            function Install-HPImageAssistantAndDrivers {
                $hpImageAssistantExePath = "C:\Custom\HPIA\HPImageAssistant.exe"
                # Check if HP Image Assistant is already installed
                if (-not (Test-Path $hpImageAssistantExePath)) {
                    Write-Host "HP Image Assistant not found. Downloading and installing..."
                    $hpImageAssistantInstallerPath = Get-HPImageAssistant
                    if (-not $hpImageAssistantInstallerPath) { 
                        Write-Host "Failed to get HP Image Assistant installer. Exiting."
                        return 
                    }
                    Write-Host "Installing HP Image Assistant..."
                    Start-Process -FilePath $hpImageAssistantInstallerPath -ArgumentList "/s /e /f C:\Custom\HPIA" -Wait
                }
                else {
                    Write-Host "HP Image Assistant is already installed. Skipping download and installation."
                }
                # Check if HP Image Assistant was installed successfully
                Write-Host "Running HP Image Assistant to check and install updates..."
                Start-Process -FilePath $hpImageAssistantExePath -ArgumentList "/Operation:Analyze /Category:All /Selection:All /Action:Install /AutoCleanup /Silent /Noninteractive /debug " -Wait
                if ((Get-AppxPackage).name -notlike "*HPProgrammableKey*" -and (Get-ComputerInfo).CsSystemType -eq "Mobile") {
                    Write-Host "HP Programmable Key is not installed. Ready to install now!"
                    $hpProgrammableKeyInstallerPath = Get-HPProgrammableKey
                    if (-not $hpProgrammableKeyInstallerPath) { 
                        Write-Host "Failed to get HP Programmable Key installer. Exiting."
                        return 
                    }
                    Start-Process -FilePath $hpProgrammableKeyInstallerPath -ArgumentList "/s" -Wait
                }
                # Get the path to the temp folder
                $tempFolder = [System.IO.Path]::GetTempPath()
                # Remove all files and subfolders in the temp folder
                Get-ChildItem -Path $tempFolder -Recurse -Force | ForEach-Object {
                    try {
                        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
                    }
                    catch {
                        Write-Host "Could not delete $($_.FullName): $_" # debug
                    }
                }
                Write-Host "Temp folder cleaned successfully."
            }
            Install-HPImageAssistantAndDrivers
            break
        }
        "*Panasonic*" {
            <#
            -This part download necessary drivers from the manufacturer (Panasonic) webpage (https://askpc.panasonic.co.jp/dl/install/driver_packages/)
            -After downloading the .zip file, it will be extracted and run.  
            #>
            function Get-OSVersion {
                enum BuildNumber{
                    Win11_23H2 = 22631
                    Win11_22H2 = 22621
                    Win10_22H2 = 19045
                    Win10_21H2 = 19044          
                }
                Get-CimInstance -Class win32_operatingsystem | Select-Object @{N = 'BuildNumber'; E = { [BuildNumber]$_.BuildNumber } } | Select-Object -ExpandProperty BuildNumber
            }
            # Set var name
            $PCmodel = (Get-CimInstance -Class:Win32_ComputerSystem).Model
            $OSversion = Get-OSVersion
            if (!(Test-Path -Path "C:\Temp")) { New-Item -ItemType Directory -Path "C:\" -Name "Temp" }

            # Find the target model
            switch -wildcard ($PCmodel) {
                "*FV4*" {
                    switch ($OSversion) {
                        { "Win11_23H2" -or "Win11_22H2" } {
                            $url = "https://na.panasonic.com/computer/software/FV4_Win11_23H2_22H2_V1_OCB.zip"
                            break
                        }
                        "Win10_22H2" {
                            $url = "https://na.panasonic.com/computer/software/Win10_22H2/FV4_Win10_22H2_V2_OCB.zip"
                            break
                        }
                    }
                }
                { "*QR4*" -or "SR4" } {
                    switch ($OSversion) {
                        { "Win11_23H2" -or "Win11_22H2" } {
                            $url = "https://na.panasonic.com/computer/software/QR4_SR4_Win11_23H2_22H2_V1_OCB.zip"
                            break
                        }
                        "Win10_22H2" {
                            $url = "https://na.panasonic.com/computer/software/Win10_22H2/QR4_SR4_Win10_22H2_V2_OCB.zip"
                            break
                        }
                    }
                }
                "*SR3*" {
                    switch ($OSversion) {
                        { "Win11_23H2" -or "Win11_22H2" } {
                            $url = "https://na.panasonic.com/computer/software/SR3_Win11_23H2_22H2_V1_OCB.zip"
                            break
                        }
                        "Win10_22H2" {
                            $url = "https://na.panasonic.com/computer/software/Win10_22H2/SR3_Win10_22H2_V2_OCB.zip"
                            break
                        }
                        "Win10_21H2" {
                            $url = "https://na.panasonic.com/computer/software/SR3_Win10_22H2_21H2_V1_OCB.zip"
                            break
                        }
                    }
                }
                default {
                    Write-Host "Model doesnt exist or could not be found!" -ForegroundColor Red -ErrorAction Stop
                }
            }

            # Download the .zip file containg the target drivers
            Start-BitsTransfer -Source $url -Destination "C:\Temp\"

            # Unzip it
            Expand-Archive -Path "C:\Temp\*.zip" -DestinationPath "C:\Temp\Unzip\"

            # After Unzip run .exe file

            Start-Process -FilePath "C:\Temp\Unzip\*.exe" -Wait

        }
        default {
            # Use module PSWindowsUpdate
            Write-Warning "Manufacturer is not recognized.`n         PSUpdate will be used to download and install missing drivers."
            if (!(Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore)) {
                try {
                    Install-Module PSWindowsUpdate -Force
                    Import-Module PSWindowsUpdate -Force
                }
                catch {
                    Write-Warning 'Unable to install PSWindowsUpdate Driver Updates'
                }
            }
            if (Get-Module PSWindowsUpdate -ListAvailable -ErrorAction Ignore) {
                Install-WindowsUpdate -UpdateType Driver -AcceptAll -IgnoreReboot
            }
            break
        }
    }
}
else { Write-Host "All drivers installed" }