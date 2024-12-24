function Get-StaticNetwork {
    # Combine registry paths into a single array
    $Path1 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards\*"
    $NetCard = Get-ItemPropertyValue -Path $Path1 -Name ServiceName
    foreach ($interfaceItem in $NetCard) {
        $Paths = @(
            "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\$interfaceItem",
            "HKLM:\SYSTEM\ControlSet001\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\$interfaceItem\Connection"
        )
        # Initialize the output object
        $output = [PSCustomObject]@{
            Interface      = $null
            IpAddress      = $null
            SubnetMask     = $null
            DefaultGateway = $null
            DNS1           = $null
            DNS2           = $null
        }

        # Use splatting to pass parameters to Get-ItemProperty
        $NetSetting = Get-ItemProperty $Paths[0]

        # Update the properties of the output object
        $output.Interface = Get-ItemProperty -Path $Paths[1] | Select-Object -ExpandProperty Name
        $output.IpAddress = Get-PropertyValue $NetSetting 'IPAddress'
        $output.SubnetMask = Get-PropertyValue $NetSetting 'SubnetMask'
        $output.DefaultGateway = Get-PropertyValue $NetSetting 'DefaultGateway'
        $output.DNS1 = (Get-PropertyValue $NetSetting 'NameServer').Split(",")[0]
        $output.DNS2 = (Get-PropertyValue $NetSetting 'NameServer').Split(",")[-1]

        # Output the final object
        $output
    }
}
function Get-PropertyValue($object, $property) {
    if (-not [System.String]::IsNullOrWhiteSpace($object.$property)) {
        $object.$property
    }
    else {
        "DHCP"
    }
}
# Helper function to get property value or return "DHCP"
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBgqfn8RqUtQKvl
# 4Q1nRzYdvrSqNKR9Wox74qsC7YZ58KCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIPDAnEuy
# G9YxG5fwXF6VeXLgH5uYU28B7Rhc1v0EeQ7vMA0GCSqGSIb3DQEBAQUABIIBAKI2
# cclx2b54oAdsBaEEptWfRRoGqJC5I95SiMckga51IY4dB7Sw2+oq/XK8MpNYlOa9
# bDmnAcE0weVs5U+Rhe7OuljhdjlJtHe9sMT/4JlixtnhiS05HqbUDl6HC5309icW
# wv24r5/eEb327yU5utyQfwQpI7bTUbz6EFuPaPDjiHfkZ0l5jVCGG/mHYQCKJ1gN
# vb0P51jVDqSlJO11fuBsgxTEHjztpumrP98DZHCMTHJpZIJJU+OTflFAmQtn3Qmx
# PyV+2uO3pqvqALxiq78HebUQKASzDGKtuYNATrQwChe+Sv7Xsm4gYhiLNEzgQufj
# JOWNDad4MSh6XDpKZzQ=
# SIG # End signature block
