function Get-DifferenceDP {
    #Check if Data folder exist if not create
    $testPath = Test-Path -Path $PSScriptRoot\Data
    if (-not $testPath) { New-Item -ItemType Directory -Path $PSScriptRoot\Data }

    #.csv path (using $PSScriptRoot + "\Path\") 

    $filePath = $PSScriptRoot + "\Data\"

    #Csv name

    Write-Host "Drivers and Programs installed"
    Write-Host "Type device : "
    $choice = Read-Host "oem or base"
    $fileName = $choice
    Write-Host "Exporting csv "
    #Export Installed Applications and Drivers
    Get-App $choice | Export-Csv -Path $filePath"Programs_"$fileName.csv -NoTypeInformation -Encoding UTF8
    Get-CimInstance -ClassName Win32_PNPEntity | Select-Object -Property Caption | Export-Csv -Path $filePath"Drivers_"$fileName.csv -NoTypeInformation -Encoding UTF8
    Write-Host "Export complete "
    Write-Host "Do you want to compare the 2 .csv files? "
    $choice1 = Read-Host "yes or no"

    if ($choice1 -ne "yes") {
        Write-Host "Executing exit command"
        Exit
        Write-Host "Script " end
    }
    #Importing Csv
    $DoemCsv = Import-Csv -Path $PSScriptRoot\Data\Drivers_oem.csv
    $DbaseCsv = Import-Csv -Path $PSScriptRoot\Data\Drivers_base.csv
    $PoemCsv = Import-Csv -Path $PSScriptRoot\Data\Programs_oem.csv
    $PbaseCsv = Import-Csv -Path $PSScriptRoot\Data\Programs_base.csv
    $cD = Compare-Object -ReferenceObject $DoemCsv -DifferenceObject $DbaseCsv -Property Caption | ForEach-Object {
        if ($_.SideIndicator -eq '=>') {
            $_.SideIndicator = "BASEonly"
        }
        elseif ($_.SideIndicator -eq '<=') {
            $_.SideIndicator = "OEMonly"
        }
        $_
    }
    $cD | Export-Csv -Path $filePath"Drivers_Diff.csv" -Encoding UTF8 -NoTypeInformation

    $cP = Compare-Object  -ReferenceObject $PoemCsv -DifferenceObject $PbaseCsv -Property DisplayName, DisplayVersion | ForEach-Object {
        if ($_.SideIndicator -eq '=>') {
            $_.SideIndicator = "BASEonly"
        }
        elseif ($_.SideIndicator -eq '<=') {
            $_.SideIndicator = "OEMonly"
        }
        $_
    }
    $cP | Export-Csv -Path $filePath"Programs_Diff.csv" -Encoding UTF8 -NoTypeInformation
}
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBYBuSuK3FFelrq
# RNGyVcO1qnPpZ4qy3UG45PRS9ti9gKCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIOTxop0j
# vGaVbfEHDTHU+j67sL6IQvJJpX+5nhMNxCE2MA0GCSqGSIb3DQEBAQUABIIBAFIv
# AvbXdD5/aUsWS1S1p7PO7hRxtzlnvrFfDGGhorTNhw1Zeb4ihwrePoTIrr3J8njw
# JlUpyRp7NFSOmzgAn7TCfZxCVhJ6ffNjrnsXwPljKyqn5IJJ+OBanIJLyl9m/AbN
# 9QOcILzHc284qinMrfTdIS5krwv2yuRfYqgHlxoaaaDBWxmQtvqjnGaatRrHjggs
# vnREsQr1nPHt2SxKIwxRhk4JWAmZLOrioYOMlC0K/5Cnh0S1gusRoezBqy5YhlFO
# gco8IVTifSG+nEiZOQ8DQ9wjbfFvXt9M+IUucjorToJ4FjuPIyQ4v7u7bVdR4JYs
# AAF89EBbgGyjon6i+pE=
# SIG # End signature block
