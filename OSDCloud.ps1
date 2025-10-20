
Write-Host  -ForegroundColor Cyan "Starting Custom OSDCloud ..."
Start-Sleep -Seconds 5

Write-Host  -ForegroundColor Cyan "Updating OSD PowerShell Module"
Install-Module OSD -Force -SkipPublisherCheck

Write-Host  -ForegroundColor Cyan "Importing OSD PowerShell Module"
Import-Module OSD -Force

$Global:MyOSDCloud = [ordered]@{
    OSImageIndex = '6'
}

Write-Output $Global:MyOSDCloud

Write-Host  -ForegroundColor Cyan "Start OSDCloud custom parameters"
Start-OSDCloud -OSName 'Windows 11 24H2 x64' -SkipAutopilot -Firmware -ZTI -OSEdition Pro -OSLanguage ja-jp -OSActivation Retail


#=======================================================================
#   Create Unattend.xml
#=======================================================================
$UnattendXml = @'
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
  <settings pass="generalize">
    <component name="Microsoft-Windows-PnpSysprep" processorArchitecture="amd64"
      publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <DoNotCleanUpNonPresentDevices>true</DoNotCleanUpNonPresentDevices>
      <PersistAllDeviceInstalls>true</PersistAllDeviceInstalls>
    </component>
  </settings>

  <settings pass="specialize">
    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64"
      publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <RegisteredOrganization></RegisteredOrganization>
      <RegisteredOwner></RegisteredOwner>
      <CopyProfile>true</CopyProfile>
      <TimeZone>Tokyo Standard Time</TimeZone>
    </component>
  </settings>

  <settings pass="oobeSystem">
    <!-- Japanese input and locale setup -->
    <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64"
      publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <InputLocale>0411:00000411</InputLocale>
      <KeyboardLayout>00000411</KeyboardLayout>
      <SystemLocale>ja-JP</SystemLocale>
      <UILanguage>ja-JP</UILanguage>
      <UserLocale>ja-JP</UserLocale>
    </component>

    <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64"
      publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"
      xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

      <OOBE>
        <HideEULAPage>true</HideEULAPage>
        <ProtectYourPC>3</ProtectYourPC>
        <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
        <SkipMachineOOBE>true</SkipMachineOOBE>
        <SkipUserOOBE>true</SkipUserOOBE>
      </OOBE>

      <AutoLogon>
        <Enabled>true</Enabled>
        <LogonCount>1</LogonCount>
        <Username>Administrator</Username>
      </AutoLogon>

      <UserAccounts>
        <LocalAccounts>
          <LocalAccount wcm:action="add">
            <Name>Administrator</Name>
            <Group>Administrators</Group>
          </LocalAccount>
        </LocalAccounts>
      </UserAccounts>

      <FirstLogonCommands>
        <!-- Prevent BitLocker/Device Encryption -->
        <SynchronousCommand wcm:action="add">
          <Order>1</Order>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>reg add "HKLM\SOFTWARE\Policies\Microsoft\FVE" /v EnableBDE /t REG_DWORD /d 0 /f</CommandLine>
          <Description>Disable BitLocker via Policy</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>2</Order>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>reg add "HKLM\SYSTEM\CurrentControlSet\Control\BitLocker" /v PreventDeviceEncryption /t REG_DWORD /d 1 /f</CommandLine>
          <Description>Prevent Device Encryption</Description>
        </SynchronousCommand>

        <!-- Extra safety: turn off BitLocker if somehow active -->
        <SynchronousCommand wcm:action="add">
          <Order>3</Order>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>cmd /c manage-bde -off C:</CommandLine>
          <Description>Ensure BitLocker Disabled</Description>
        </SynchronousCommand>

        <!-- Resize partition -->
        <SynchronousCommand wcm:action="add">
          <Order>4</Order>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>powershell -Command "Resize-Partition -DriveLetter C -Size 100GB"</CommandLine>
          <Description>Resize C partition</Description>
        </SynchronousCommand>

        <!-- Cleanup -->
        <SynchronousCommand wcm:action="add">
          <Order>5</Order>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>cmd /c del /Q /F c:\windows\system32\sysprep\Panther\setuperr.log</CommandLine>
          <Description>Delete setuperr.log</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>6</Order>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>cmd /c del /Q /F c:\windows\panther\unattend.xml</CommandLine>
          <Description>Delete Unattend.xml</Description>
        </SynchronousCommand>
        <SynchronousCommand wcm:action="add">
          <Order>7</Order>
          <RequiresUserInput>false</RequiresUserInput>
          <CommandLine>cmd /c del /Q /F c:\windows\system32\sysprep\Panther\unattend.xml</CommandLine>
          <Description>Delete Unattend.xml duplicate</Description>
        </SynchronousCommand>
      </FirstLogonCommands>

    </component>
  </settings>

  <cpi:offlineImage
    cpi:source="wim:c:/users/cloning03/desktop/20230519%E5%BF%9C%E7%AD%94%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB/sources/install.wim#Windows 11 Pro"
    xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>
'@

if (-NOT (Test-Path 'C:\Windows\Panther')) {
    New-Item -Path 'C:\Windows\Panther' -ItemType Directory -Force -ErrorAction Stop | Out-Null
}

$Panther = 'C:\Windows\Panther'
$UnattendPath = "$Panther\Unattend.xml"
$UnattendXml | Out-File -FilePath $UnattendPath -Encoding utf8 -Width 2000 -Force


#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting!"
Start-Sleep -Seconds 10
wpeutil reboot

