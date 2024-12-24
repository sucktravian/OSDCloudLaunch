function Get-MyExcel {


    $O365Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\O365BusinessRetail - ja-jp'
    $ExcPath = "C:\Program Files*\Microsoft Office\Office1*\ospp.vbs"
    if (Test-Path -Path $O365Path) {
        function PrintLicensesInformation {

            $licensePath1 = "${env:LOCALAPPDATA}\Microsoft\Office\Licenses"
            $licensePath2 = "${env:PROGRAMDATA}\Microsoft\Office\Licenses"
    
            $licenseFiles = $null
            If (Test-Path $licensePath1, $licensePath2) {
                $licenseFiles = Get-ChildItem -Path $licensePath1, $licensePath2 -Recurse -File -ErrorAction Ignore
            }
    
            If ($licenseFiles.length -Eq 0) {
                Write-Host "No licenses found."
                Return
            }
    
            $licenseFiles | ForEach-Object `
            {
                $license = (Get-Content -Encoding Unicode $_.FullName | ConvertFrom-Json).License
                $decodedLicense = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($license)) | ConvertFrom-Json
    
                $licenseState = $null
                If ((Get-Date) -Gt (Get-Date $decodedLicense.MetaData.NotAfter)) {
                    $licenseState = "RFM"
                }
                ElseIf (($null -Eq $decodedLicense.ExpiresOn) -Or
                ((Get-Date) -Lt (Get-Date $decodedLicense.ExpiresOn))) {
                    $licenseState = "Licensed"
                }
                Else {
                    $licenseState = "Grace"
                }
    
    
                $O365output = [PSCustomObject] `
                @{
                    ExcelVersion = $decodedLicense.ProductReleaseId
                    ExcelStatus  = $licenseState
                    ExcelKey     = $null
                }
    
                $O365output | Format-List
            }
    
        }
        PrintLicensesInformation
    }
    elseif (Test-Path -Path $ExcPath) {
        # Show files and folders in the path
        $RealPath = Resolve-Path -Path $ExcPath | Select-Object -ExpandProperty Path | Split-Path -Parent
        $vbsOutput = (& C:\Windows\System32\cscript.exe "$RealPath\ospp.vbs" /dstatus) | Select-String "LICENSE STATUS:", "LICENSE NAME:", "LAST"
        #excelKey
        $excelKey = $vbsOuput -split ":"
    
        #excelStatus
        $excStatus = $vbsOutput | Where-Object Line -Match "LICENSE STATUS"
        $excStatusNew = ($excStatus -split ":").Trim()
    
        #excelVersion
        $excVers = $vbsOutput | Where-Object Line -Match "LICENSE NAME"
        $excVersNew = ($excVers -split ":").Trim()
    

        $ExcOutput = [PSCustomObject]@{
            ExcelVersion = ($excVersNew[-1]).Trim("-") 
            ExcelStatus  = ($excStatusNew[-1]).Trim("-")
            ExcelKey     = $excelKey[-1].trim()
        }
        $ExcOutput | Format-List
    } 
    else {
        "エクセル見つかりませんでした"
    }  
} 
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAG0Xz0NGlkgL+2
# rhtxhRAnPrBv82+dRUdm8lcSQQZ8gaCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIPRAgwC4
# hoIrPtklJnQxK+qXxWNi5EFjp849G5INvrNNMA0GCSqGSIb3DQEBAQUABIIBABqc
# q3Oe4wy/IbTfpA5hXGi1UCnyOSiRwdasBOsuK/SJXEu/4vQcAhTO1Hqh8naPyWMO
# mlI3MhAcvkXjTxENLHQPuDWdeT9HbWZ/rGLijENwNdSmlQ9CEDxYGIkGcP/g4Y+u
# 5g3XbHk4iIK8fh5TgG4SR+85YXOl+ITVNxUT83b0lqarL8rJ5d6/69DaSAmshxME
# ZpUTyEFwadjBQCspj2ESyNE8aZDl+tzZNb91Sw5UFgT8Jk0tYHOfRuz+QSEVCfnf
# jAZmah0kK7ifVRrmij+WpR21bxOacZErdkV3392v8akGE/o/0cfRDx4bqEpnDwWA
# 76sbmPe3ZcH0KkJO3L8=
# SIG # End signature block
