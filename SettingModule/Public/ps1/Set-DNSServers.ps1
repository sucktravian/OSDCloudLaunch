function Set-DNSServers {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DNSServer1,
        [string]$DNSServer2
    )

    # Regular expression pattern for IP address
    $pattern = '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

    # Check if the DNS servers are valid
    if ($DNSServer1 -match $pattern -and ($DNSServer2 -match $pattern -or $DNSServer2 -eq $null)) {
        # Get the name of the network adapter
        $interface = (Get-NetAdapter | Where-Object {$_.Status -eq 'Up'}).Name

        # Set the primary DNS server
        netsh interface ip set dns name="$interface" static $DNSServer1 primary

        # Set the secondary DNS server, if provided
        if ($DNSServer2 -ne $null) {
            netsh interface ip add dns name="$interface" $DNSServer2 index=2
        }
    } else {
        Write-Host "Invalid DNS server."
    }
}

# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDWEiRt+o3HTL3C
# LH6bverbklZ0YqkIa9W1mtxlsX5tkqCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIPSNvBI2
# Ovp4A6KoBJQ5RvXOVSvBweqjO6XsfN63tIRcMA0GCSqGSIb3DQEBAQUABIIBAHpr
# u7r2etK803E+tCI3pZPS901aUbglgNuURdpEeQZxVxn9RUFevpDpWvsbqGKeVlnu
# 30eP+7ojQK0xbtiaQh3TXcoAhUBjPsqU7V+DR374ylf6sZ5V0AUAyw2E3KzhD9L2
# 19NcWpZsVsLfr2tcK19Im155EufZC34PztZnlM4glrRhwrDvf6biE7YdX/CGciru
# BkLu5QSYD1aO6ohHBm04kYxRbuAW/REgWktd8aa9ao7Jx9Vl9FCp6ZuNhq/OOUDm
# JbgDeeorbb8199hGq6Cz/3pkLG+zpF9HFW2Z3OzXf1cF2oqgrG/nLkGbIsQfvmNT
# WeX/9A8GkPMsHHV5tCs=
# SIG # End signature block
