Function New-User {
    <#
    $password = ConvertTo-SecureString -String "MyPassword" -AsPlainText -Force
    New-User -username "JohnDoe" -password $password -userGroup "Administrators"
    #>
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$username,

        [Parameter(Mandatory = $true)]
        [securestring]$password,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$userGroup
    )
    try {
        New-LocalUser $username -Password $password -PasswordNeverExpires -ErrorAction Stop
        # Add new user to administrator group
        Add-LocalGroupMember -Group $userGroup -Member $username -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to create user '$username': $_"
    }
}
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBlr0U/9ly3ha0Q
# iFJvJFVFYhoF6j17HDclTM7xrk3isaCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIBSmqBEw
# kHOeFRP/NXjKcFawSZmUk1hZ3aRG/39klyZxMA0GCSqGSIb3DQEBAQUABIIBAH6Y
# XEGr6WjBEQWBGQiA2e0UacAwUFCZTLaoB+dnBpUCL3jPnwX3mLpNBjXBsQM6TGff
# cs6fEOIJWsVsonNGoA16y7K2B/fqGGDwL28hacFc9o9J+X50xhlB+cD2PirVdyJB
# EnQzMdBps0IZZ7vpq01DSMiOdQpfCk83WPUdqV5JVNY6OQ4DeVbOI3Jerc+q7oG/
# 4XdneCO8Y4nrtfz7jfFgOtZSuwCQjxlrKXxGkkuMOtPfxJ/nZDjc/dq9WXdDvjph
# hOxlhsy24PeHPd6CE+YVu9rlEw63mIgO+fMojWWEGGfY1zj1+OcHqHfz66Uu6TG+
# fk3px9oeK1/lCIYi8ls=
# SIG # End signature block
