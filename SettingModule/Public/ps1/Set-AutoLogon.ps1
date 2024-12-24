Function Set-AutoLogon {

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [string]$DefaultUsername,

        [Parameter(Mandatory = $True)]
        [string]$DefaultPassword,

        [Parameter(Mandatory = $False)]
        [AllowEmptyString()]
        [string]$AutoLogonCount,

        [Parameter(Mandatory = $False)]
        [AllowEmptyString()]
        [string]$Script
    )

    # Registry path declaration
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    $RegROPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"

    try {
        # Setting registry values
        Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -Type String  
        Set-ItemProperty $RegPath "DefaultUsername" -Value $DefaultUsername -Type String  
        Set-ItemProperty $RegPath "DefaultPassword" -Value $DefaultPassword -Type String

        if ($AutoLogonCount) {
            Set-ItemProperty $RegPath "AutoLogonCount" -Value $AutoLogonCount -Type DWord
        }
        else {
            Set-ItemProperty $RegPath "AutoLogonCount" -Value "1" -Type DWord
        }

        if ($Script) {
            Set-ItemProperty $RegROPath "(Default)" -Value $Script -Type String
        }
        else {
            Set-ItemProperty $RegROPath "(Default)" -Value "" -Type String
        }
    }
    catch {
        Throw "An error occurred: $_"
    }
    <#
    .Synopsis
    Enable auto logon on a server and execute a script after reboot.

    .Description
    This function enables auto logon on a server and allows for the execution of a specific script after the server reboots. It sets the necessary registry values to enable auto logon and execute the script.

    .Parameter DefaultUsername
    The username that the system would use to login.

    .Parameter DefaultPassword
    The password for the DefaultUser provided.

    .Parameter AutoLogonCount
    Sets the number of times the system would reboot without asking for credentials. The default value is 1.

    .Parameter Script
    The full path of the script to be executed after server reboot.

    .Example
    Set-AutoLogon -DefaultUsername "win\admin" -DefaultPassword "password123"

    .Example
    Set-AutoLogon -DefaultUsername "win\admin" -DefaultPassword "password123" -AutoLogonCount 3

    .Example
    Set-AutoLogon -DefaultUsername "win\admin" -DefaultPassword "password123" -Script "c:\test.bat"
    #>
}
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDoA53fbSD45gvC
# b22AguDNCqko6ajcT0NaziroKFGIbaCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIALOn00m
# KHIZx5kkH+N40ULZiwn2FAIv9gBgRkIqpFniMA0GCSqGSIb3DQEBAQUABIIBAA6w
# yII2tZxq9MVVznhE2pCRbdBhs9bqoP+b31ztKg36iib0sdiLE8iPEudfs9EiObZu
# Q33u5VS4VrW1mtdOVTH0Do2jri2RxxpzH7Y2uZ6DG1Ig8Sr5w1YEWx12FrmJu7Y3
# VDpq97BFx7KH3eWPscaCMJMXhQrjwXcNVgYhPPDbHj/p1fQG8lJHLwxy8YviiVCc
# 3A3oTcZMybaemfIFidsCyjSy87J+RxJpTeGYIhvd12D/pCdDYg1zixjl7hOZNGeB
# sennwekKuvNTJ3m7ddiKvO2euMYhRG4mQWZ5u8knfWNzu1/EXve+6lXX2eWNS3+B
# +zbyF4u+szmFhiV0864=
# SIG # End signature block
