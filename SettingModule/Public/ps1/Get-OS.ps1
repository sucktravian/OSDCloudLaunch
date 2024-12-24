function Get-OS {
    enum BuildNumber{
        Windows11_23H2 = 22631
        Windows11_22H2 = 22621
        Windows11_21H2 = 22000
        Windows10_22H2 = 19045
        Windows10_21H2 = 19044
        Windows10_21H1 = 19043
        Windows10_20H2 = 19042
        Windows10_2004 = 19041
    }
    $ver = Get-CimInstance -Class win32_operatingsystem | Select-Object @{N = 'BuildNumber'; E = { [BuildNumber]$_.BuildNumber } } | Select-Object -ExpandProperty BuildNumber
    $Ver1 = $ver -split "_"
    $OS = (Get-CimInstance Win32_OperatingSystem).Caption
    

    $ShowWindowsKey = cscript C:\Windows\System32\slmgr.vbs /dli | Where-Object { $_ -match "一部" }
    $key = $ShowWindowsKey -split ":"
    $key1 = $key.TrimStart()
    
    $OSActStatus = cscript c:\windows\system32\slmgr.vbs /xpr
    [PSCustomObject]@{
        OS         = $OS + " " + $Ver1[1]
        WindowsKey = $key1[1]
        Status     = $OSActStatus.Split()[-2]
    }
}
(Get-OS).OS
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDD+9DuijC3hhpN
# oD9+2IwQk6PF0ilZgfAwu7+sroRQUaCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIMDJtFMc
# OF1GrDzASmeYVK3DmJeMW5RZ3C4upp+7qz+6MA0GCSqGSIb3DQEBAQUABIIBAKRU
# PR9PG++5uGVZNo8gKBUwqDTDwkzWYsHSYqvmWs6X5HlAJp8vwL6VxgXoHTi3V4rw
# oefELA0pNTMMMRD3hJvP4zqD8wV3x3ghWpGnmYqLQBgzn4TAW84f6DMk9uJgTPXY
# iGvfmGJ+XKgv7sW+VU9YpS+uQqTb+TMosX+IeGTidU8KeW6O07tnWWW1f289MEyd
# B3zMDPrcRfGBbrVSsWTEo9EXbaLhtKz95peFkn3PFN6XZfoOmvy6H4gs2bJfA5Ji
# nwNdoNH2BbdkIb8Th9a/8X5XKAeNb+qsRTr4lh8wOouBJuC6FoZoPKQsOmRLJPQG
# OKGCbBJ240Q2S/Xulbg=
# SIG # End signature block
