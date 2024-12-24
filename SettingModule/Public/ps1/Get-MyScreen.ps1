function Get-Myscreen {
   param (
       $File
   )
   begin {
    $directory = Split-Path -Path $File -Parent
    if (!(Test-Path -Path $directory)) {
       New-Item -ItemType Directory -Path $directory | Out-Null
    }
       Add-Type -assembly System.Windows.Forms
       Add-Type -AssemblyName System.Drawing
       $jpegCodec = [Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
       Where-Object { $_.FormatDescription -eq "JPEG" }
   }
   process {
       Start-Sleep -Milliseconds 250
       [Windows.Forms.Sendkeys]::SendWait("^{PrtSc}")
       Start-Sleep -Milliseconds 250
       $bitmap = [Windows.Forms.Clipboard]::GetImage()
       $ep = New-Object Drawing.Imaging.EncoderParameters
       $ep.Param[0] = New-Object Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]100)
       $bitmap.Save("$File.jpg", $jpegCodec, $ep)
   }
}
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBJLNb6g2IckGx1
# Soz8ScZrE8ryHJftq0XzvvE+KaB8/KCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIHHR1xDo
# hM/k0iSAzqvGB0mvL2+E34gwk2vlKvPOubYkMA0GCSqGSIb3DQEBAQUABIIBAGlq
# 8muTspmOeE6rK0i3JmB4fVeF8tDwJrc5sBbqIWHSSxVOy52gmJiz7a+R4yJgSwKS
# 7PKL24a3hoi4RtloXOaYxrAB1M/KHRNi0W86ObHXXlyP6G4mjbWmOWjp4Y0zzhVV
# YNLPybKXdW/g91++xkdORgnhKtDyQ7AFJd4sZwtO27uKFOWct11Lz0faBlzEOhRG
# 7VwAAgNQqv0fA2kAAfsPDblcurf9acz3mV8nHAhwRExFCkdy6ogZzwTeX9ly0eLS
# bpIa3TQc6TSkiYhzX92yyb3YroOYuBrkGicBBz+1O5XgStTaFiwmG46eS6LD5el/
# r8p9MMKny6Zb292xgQo=
# SIG # End signature block
