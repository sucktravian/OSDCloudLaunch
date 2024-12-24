function Start-OSActivation {
    #OS activation
    cscript C:\Windows\System32\slmgr.vbs /ato | Out-Null

    #OS activation status
    $OSActStatus = cscript C:\Windows\System32\slmgr.vbs /xpr

    #if error
    if ($($OSActStatus.Split()[-2]) -notmatch "コンピューターのライセンス認証は完了しました" ) {
        do {
            Start-Sleep -Seconds 15
            cscript C:\Windows\System32\slmgr.vbs /ato | Out-Null
            $OSActStatus | Out-Null
        
        } until (
        ($OSActStatus.Split()[-2]) -match "コンピューターのライセンス認証は完了しました")
        Write-Host ($OSActStatus.Split()[-2]) -ForegroundColor Green
    }       
    else {
        Write-Host ($OSActStatus.Split()[-2]) -ForegroundColor Green
    }
}
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDySv5jUXmkLtM5
# jAsZFpkch+wGjFyU44+7QBNLCxwLpKCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIAHQmD8J
# iD3/W0MHB0Sh5dSRZ9P1mXvA5r0rc8ka6hl3MA0GCSqGSIb3DQEBAQUABIIBAAZX
# MrMg+VplDT/TcJmaTshZa/+wfaXMuy8HlQ6UMsRxymFdOtgeyI04q196463AT3Hs
# NGp0s8hrqnDdwPKHRXQFf3MY/chQlQnIcSmWIK3CK/VHtiGqcJT5zVatk5jqG2hf
# f0qv0WADgvBsnSxIbpfTO/an6U7cn0J4I068Bl77KIon2TdF7LRArfTF8vPpPQ/6
# yz+inVYIkgJSRh6ksYCnMixx6oDFBbIwc5PppCnSqRBa9ER+HGWRF5GPCpQL36L2
# k1sA0l9G/WaAovofthy2tbSpZ5LnWc3ggiMvuvmtT2G7vzeke3lvoUqKOBZ+zPIt
# WFRqZsG1W63H/jLO+Ks=
# SIG # End signature block
