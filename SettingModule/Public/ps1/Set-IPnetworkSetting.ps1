function Set-IPnetworkSetting {
    param(
        [Parameter(Mandatory=$true)]
        [string]$IPAddress,
        [Parameter(Mandatory=$true)]
        [string]$SubnetMask,
        [Parameter(Mandatory=$true)]
        [string]$DefaultGateway
    )

    # Regular expression pattern for IP address
    $pattern = '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

    # Check if the IP address, subnet mask, and default gateway are valid
    if ($IPAddress -match $pattern -and $SubnetMask -match $pattern -and $DefaultGateway -match $pattern) {
        # Get the name of the network adapter
        $interface = (Get-NetAdapter | Where-Object {$_.Status -eq 'Up'}).Name

        # Set the IP address, subnet mask, and default gateway
        netsh interface ip set address name="$interface" static $IPAddress $SubnetMask $DefaultGateway
    } else {
        Write-Host "Invalid IP address, subnet mask, or default gateway."
    }
}

# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBskWNlbubtcO1C
# nSYEz/3LEWiVR6AEn1lf6Ob+tlL/nKCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEINu5kuo/
# TV9MdJjcMSv8jF6BGo6Zs2hTj3mi1J6B2xRqMA0GCSqGSIb3DQEBAQUABIIBACop
# gWi/5UZy6M6DSYsqE6IyJYgpgCZYNgXLTkWtIPeas9BVYCtJ15vBwTEKsUxGqGAB
# yqRytMHb0uoh6bXQmF3al23gD17m46YwmE19W/4hX2Hi3IQ0vhEnnFBATLxwU57T
# 6TKxH3RwA52btfvbIAGMpxtoRl2Qt6EDttOvaoIdKXhgUdmtIqsq3uK8h7FzfQVX
# Xqub1F00eX10Ge1sciihxcNtwWfUc21jye1iUVuILwcIWPd9P3Y7cr3ez8n3qjQU
# puHCCmNIEmd1FEeCaYDm5zt1ONgGSY1QP3lux1/cb4+9v/Xlvhn57xbMl1X0W9m7
# kuBPrTn8Yo37Zr6eTQI=
# SIG # End signature block
