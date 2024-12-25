# Import the Setting Module
Import-Module "C:\OSDCloud\Scripts\SettingModule\Setting.psm1"

# Remove Task
Set-RbRsScript -settask $false

# Add Task for running script after sysprep
Set-RbRsScript -settask $true -ScriptName "C:\OSDCloud\Scripts\Checker.ps1"

