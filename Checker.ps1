Import-Module "C:\OSDCloud\Scripts\SettingModule\Setting.psm1"
Set-RbRsScript -settask $false
devmgmt.msc
Pause
explorer ms-settings:windowsupdate
Pause
Write-Host "Explorer履歴,ゴミ箱削除行います"
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

Write-Output -InputObject '後5秒スクリプトが自己破壊されます'

5..1 | ForEach-Object {
    If ($_ -gt 1) {
        "$_ 秒"
    }
    Else {
        "$_ 秒"
    } # End If.
    Start-Sleep -Seconds 1
} # End ForEach-Object.
Write-Output -InputObject '自己破壊完了'
# Here's the command to delete itself and clean some folder
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"cd c:\ & rmdir C:\Custom /s /q`""
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"cd c:\ & rmdir C:\Temp /s /q`""
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"cd c:\ & rmdir C:\Windows\Setup\Scripts /s /q`""
exit
