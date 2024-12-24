Function Test-InternetConnection {
    <#
    .SYNOPSIS
        Use this function to test your internet connection and monitor while it is down.
    .DESCRIPTION
        Use this function to test your internet connection and monitor while it is down. When the connection is back up, a text notification will show up.
    .PARAMETER Site
        Name of the site to use for connection test.
    .PARAMETER Wait
        Time to wait before retrying Test-Connection (seconds)

    #>
    [cmdletbinding(
    )]
    param(
        [Parameter(
            Mandatory = $True,
            ParameterSetName = '',
            ValueFromPipeline = $True)]
        [string]$Site,
        [Parameter(
            Mandatory = $True,
            ParameterSetName = '',
            ValueFromPipeline = $False)]
        [Int]$Wait,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Active", "Disable")]
        $Mode
    )
    #Clear the screen
    Clear-Host

    if ($Mode -eq "Active") {
        #Start testing the connection and continue until the connection is good.
        While (!(Test-Connection -computer $site -count 1 -quiet)) {
            Write-Host -ForegroundColor Red -NoNewline "LANケーブルを接続してください。..."
            Start-Sleep -Seconds $wait
            Clear-Host
        }
        #Connection is good
        Write-Host -ForegroundColor Green "$(Get-Date): ネットワークに接続完了しました。"
    }
    elseif ($Mode -eq "Disable") {
        #Start testing the connection and continue until the connection is disabled.
        While (Test-Connection -computer $site -count 1 -quiet) {
            Write-Host -ForegroundColor Red -NoNewline "LANケーブルを外してください..."
            Start-Sleep -Seconds $wait
            Clear-Host
        }
    }

}
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAJIWOa1gENS9o6
# azq0oNumlzWh9p3IKHs7C9Zv1hYzLKCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIBK5E/Rp
# eqLPIrGjsr3ZjQNzHhUTrLnn+xB7kKwUG8t1MA0GCSqGSIb3DQEBAQUABIIBAGhN
# OePxiz0zmXYqXYLq9pTSrBff3lvCkijsDkcsxu0KagXcMqDPNPTE1NnH3x5vhxhQ
# Y5VAvJ1Z/uaSgYkmFPcY6nupmrfwaU5Pz5haYbOybli50/CvtvkpkBnM2HZiUKFN
# hBMPiw+EElPFmXIpddL04EXuZEfEbSy3dkRf9Cbe59QZCIxF7E7QSX3AbF8FF4yq
# j6Dwy8jp46Rf419FhAn56IItqkoKAq5R+sKAXQb0QsRt+7jy7NzHCcsnjYTxthMb
# mAmxQWHJiM1JnVXllBXCuWWpf2c+rNbY9Y2pSmhXOYpM47V3U+Bcb3X9bIe3MmL4
# KzpxqME7vMuF80xJ4qs=
# SIG # End signature block
