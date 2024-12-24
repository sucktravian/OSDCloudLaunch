Import-Module "C:\OSDCloud\Scripts\SettingModule\Setting.psm1"
# Remove installed powershell modules 
Uninstall-Module -Name OSD
Uninstall-Module -Name PSWindowsUpdate
# Delete Task
Set-RbRsScript -settask $false
# Open Device Manager
Start-Process -FilePath "devmgmt.msc" -PassThru | Wait-Process

# Open Windows Update settings
Start-Process -FilePath "explorer.exe" -ArgumentList "ms-settings:windowsupdate" -PassThru | Wait-Process

# File Explorer history deletion
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*", "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*", "$env:APPDATA\Microsoft\Windows\Recent\CustomDestinations\*", "C:\Program Files\WindowsPowerShell\Modules\PSWindowsUpdate" -Force -Recurse -ErrorAction SilentlyContinue
# Combine similar operations into a single command
# RUN history deletion
if (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU") {
    Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" -Force
}
# Explorer search bar history deletion
if (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths") {
    Remove-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" -Force
}
#Empty Recycle bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
Write-Output -InputObject 'Auto-Delete will start in 5 seconds from now!'

5..1 | ForEach-Object {
    If ($_ -gt 1) {
        "$_ seconds"
    }
    Else {
        "$_ seconds"
    } # End If.
    Start-Sleep -Seconds 1
} # End ForEach-Object.
Write-Output -InputObject 'Auto-Delete completed!'
# Here's the command to delete itself and clean some folder
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"cd c:\ & rmdir C:\OSDCloud /s /q`""
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"cd c:\ & rmdir C:\Windows\Setup\Scripts /s /q`""
exit
