#Reset Network Settings
function Reset-NetAdapter {
    param (
        [Parameter(Mandatory)]
        [ValidateSet("IPv4", "IPv6")]
        $IPType
    )
    # Get the network adapter
    $adapter = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' })

    $interface = $adapter | Get-NetIPInterface -AddressFamily $IPType
    If ($interface.Dhcp -eq "Disabled") {
        # Remove existing gateway
        If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) {
            $interface | Remove-NetRoute -Confirm:$false
        }
        # Enable DHCP
        $interface | Set-NetIPInterface -DHCP Enabled
        # Configure the DNS Servers automatically
        $interface | Set-DnsClientServerAddress -ResetServerAddresses
        # Restart the network adapter
        Restart-NetAdapter -InterfaceAlias $adapter.Name
    }

}


# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCB2uxsd+CGGh13P
# KvGgFfFAQvY/K3Kl3Ie4vRSnl0TxhqCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIHTcl+PW
# NPpCB7VtyBXL4a6n31KWjLYtNNJO8Ng6hKw9MA0GCSqGSIb3DQEBAQUABIIBADl+
# Cc7K5hBgUVUPSmG7jhI3OC42jjlT/lijt5IFuejuKMGZwlnoF97VyVgSY7U3jo8n
# GgNns8GWSu7ub9IE+66gtkg1A/ZQEXQ2DlbdeTAUXSQSRSzK+JiWMyaNTgomhN58
# +qjTa6ONNDaWP0Qg6SY+loAYkuUebctQZqpSTpoxNjGTCzTEIcjaTLXGkRZGWx6+
# s8fdMRWagDmLyIHWT8R4W+VQ+e3jHg56TY9aZOpWt42bz0f4DT2qFO7Ju7iJ3oFH
# xK66jLfoI2TxOdsSysLL7Jb4MxtEZz5Qc3k1MamE20I8MLO1CTNbVDXpMfTdQoCK
# F42/T1NBvrOOGJTC/nw=
# SIG # End signature block
