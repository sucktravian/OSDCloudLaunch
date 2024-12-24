Function Set-RbRsScript {
    <#
.SYNOPSIS
    This function add a taskschedule that run a script a reboot when the $true bool is set
        if the bool is set to $false it will unregister the task
 
.NOTES
    Name: Set-RbRsScript
    Author: Federico
    Version: 1.0
    DateCreated: 2024/3/13
 
 
.EXAMPLE
    Set-RbRsScript -settask $true -ScriptName "C:\TRY\test2.ps1"
    Set-RbRsScript -settask $false

#>
    [CmdletBinding()]
    param(
        [Boolean]$settask,
        [string]$ScriptName
    )
    
    switch ($settask) {
        $true {
            # Define task action
            $ActionParam = @{
                Execute  = 'Powershell.exe'
                Argument = ("-ExecutionPolicy Bypass -File " + ($ScriptName))
            }
    
            # Define task trigger
            $TriggerParam = @{
                AtLogOn = $True
                User    = (([System.Security.Principal.WindowsIdentity]::GetCurrent().Name).Split('\')[-1])
            }
    
            # Define task settings
            $SettingsParam = @{
                AllowStartIfOnBatteries    = $true
                DontStopIfGoingOnBatteries = $true
            }
    
            # Construct task
            $Register = @{
                Action      = (New-ScheduledTaskAction @ActionParam)
                Trigger     = (New-ScheduledTaskTrigger @TriggerParam)
                Settings    = (New-ScheduledTaskSettingsSet @SettingsParam)
                User        = (([System.Security.Principal.WindowsIdentity]::GetCurrent().Name).Split('\')[-1])
                TaskName    = "PrepareScriptRebootTask"
                Description = "PrepareScriptRebootTask"
            }
            $taskExists = Get-ScheduledTask | Where-Object { $_.TaskName -like "PrepareScriptRebootTask" }

            if (!($taskExists)) {
                Register-ScheduledTask @Register -Force
            }
        }
        $false {
            Unregister-ScheduledTask -TaskName "PrepareScriptRebootTask" -Confirm:$false -ErrorAction SilentlyContinue
        }
        Default { Throw "Something went wrong, this isn't supposed to happen" }
    }
}
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCByVG5lOSOnnq9x
# w4KUWXzjQsC4pfN3012vjg5eWRRsDKCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
# rkKkEuFPvUzbMA0GCSqGSIb3DQEBBQUAMCIxIDAeBgNVBAMMF1Bvd2VyU2hlbGwg
# Q29kZSBTaWduaW5nMB4XDTI0MDMxMzA2MDgwOVoXDTI1MDMxMzA2MjgwOVowIjEg
# MB4GA1UEAwwXUG93ZXJTaGVsbCBDb2RlIFNpZ25pbmcwggEiMA0GCSqGSIb3DQEB
# AQUAA4IBDwAwggEKAoIBAQDK9HjyD++N7ZVh0oblY0fOI2aNQgZqkr6ZLbUeeBfD
# 159To0wwPiacnt9U86yUavN50htAkuJTPg5882I5M2fmbQZkF2P3BJ7fUHO8KozC
# Rf+gIdZlFmPUP92uakINe7aWbqsCerE3Dq0KkqIZdzJzjHu5ID1PRx4OLSwaEooz
# oYcoR4B4eyHX6MhrwlwH/Hgv+azVFjKAlQ8tO8jlXzB72pA1OuqOODxxc7L32dNo
# bBpFRcDAP86pbveAuU2sG29BEDVb9Ceq63fkk3Py+9NZNvXEUggUOsbrPbhruY49
# AzJowrmKDXczwpWS2vhs/14TvGDartc7UfLzLUKm9mWtAgMBAAGjRjBEMA4GA1Ud
# DwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAdBgNVHQ4EFgQUSPziEeYO
# Glo1BXc/mi7pUDuZz2cwDQYJKoZIhvcNAQEFBQADggEBAF4qsnzhQVM+T8Vwsm6l
# mLW8pNNIB4rB/4P4GxWuZ6NjLGrEp84LTD2qgp43T3J3zyu6/w8LYCvUp5YC/1KQ
# Jn+ffv3uPqX5IJwTNe+cfROHzQ1BUimWvVP+BawhQ4rOBqSxV8AjSn+OG5x3kD9z
# FKdtWO2Q6DiaHni9KXbsur+C7MLLRGNIakkHeYvFZNZ4l0dmWdzgd4Cyrxsvd4+6
# IU3pWFtNHfmZG0s58w1o2TrXG+94vm5PZkNohjmUbhBO0frUvZjuwANcfUJgN1dK
# 8YOajoqf0iXV9SrAE3Nixa0lSbPj3Fydo1mX6JEs8GozPrnT07WAA6LhKneCYkYY
# 8tMxggHoMIIB5AIBATA2MCIxIDAeBgNVBAMMF1Bvd2VyU2hlbGwgQ29kZSBTaWdu
# aW5nAhBO/339yhdnrkKkEuFPvUzbMA0GCWCGSAFlAwQCAQUAoIGEMBgGCisGAQQB
# gjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIHG0iont
# Fr3D7hv4xDRmyg3lPu86lz1D0R8IKWOgxAKeMA0GCSqGSIb3DQEBAQUABIIBACf6
# xjbc+ngDgYJaTts7NeVUB3dK/QH810iBfSiqxCKxjC+e0xHby3sfcPlqFD3n5Oqx
# ufG1vF3HJEih46t8sqP/v+Q0vYM/yHGZ6GunJ2COOkk6Fiq8elAyIHNkeTqg2iWF
# Wcydup557vPRX4Zoigj18nea65T70y1/9cqv9jqz6Ag1lI44x6EHxUqDoDCjB4vV
# 0/Ku5jK82uJ1gEXHUcHddNJMwCZB+I2BxFesHB49gQteLYcXnFyv+rL+wW7QbhVz
# yy0c7we2fNURZnU2N+Li7LQ7MV3GK5T0TlZ9a2AVQ/5eXc9SJvvhlD0DK7H+ccbS
# 03xD8hIHHyJBc/g3FI8=
# SIG # End signature block
