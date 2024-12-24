function New-Menu {
    <#
    .SYNOPSIS
    Build CLI looks like menu
    
    .DESCRIPTION
    Use directional arrow up and down to navigate inside
    
    .PARAMETER MenuTitle
    Menu title
    
    .PARAMETER MenuOptions
    [array] options to choose
    
    .EXAMPLE
    $Options = "Format c:","Send spam to boss","Truncate database *","Randomize user password","Download dilbert","Hack local AD"
    $Choice = New-Menu -MenuTitle "Setting" -MenuOptions $Options
    Write-Host "YOU SELECTED : $Choice ... DONE!`n"
    
    .NOTES
    Script modified from Federico
    #>
        Param(
            [Parameter(Mandatory = $True)][String]$MenuTitle,
            [Parameter(Mandatory = $True)][array]$MenuOptions
        )
        $vkeycode = 0
        $pos = 0
    
        function DrawMenu {
            param ($MenuOptions, $menuPosition, $MenuTitle)
            $fcolor = "Cyan"
            $bcolor = "Black"
            $l = $MenuOptions.length + 1
            Clear-Host
            $menuwidth = $MenuTitle.length + 4
            Write-Host "`t" -NoNewLine
            Write-Host ("**" * $menuwidth) -fore $fcolor
            Write-Host "`t" -NoNewLine
            Write-Host "*   $MenuTitle   *" -fore $fcolor
            Write-Host "`t" -NoNewLine
            Write-Host ("**" * $menuwidth) -fore $fcolor
            Write-Host ""
            Write-debug "L: $l MenuItems: $MenuOptions MenuPosition: $menuposition"
            for ($i = 0; $i -le $l;$i++) {
                Write-Host "`t" -NoNewLine
                if ($i -eq $menuPosition) {
                    Write-Host "$($MenuOptions[$i])" -fore $bcolor -back $fcolor
                } else {
                    Write-Host "$($MenuOptions[$i])" -fore $fcolor -back $bcolor
                }
            }
        }
    
        DrawMenu $MenuOptions $pos $MenuTitle
        While ($vkeycode -ne 13) {
            $press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
            $vkeycode = $press.virtualkeycode
            Write-host "$($press.character)" -NoNewLine
            If ($vkeycode -eq 38) {$pos--}
            If ($vkeycode -eq 40) {$pos++}
            if ($pos -lt 0) {$pos = $MenuOptions.length -1}
            if ($pos -ge $MenuOptions.length) {$pos = 0}
            DrawMenu $MenuOptions $pos $MenuTitle
        }
        Write-Output $($MenuOptions[$pos])
    }
# SIG # Begin signature block
# MIIFqgYJKoZIhvcNAQcCoIIFmzCCBZcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA/RVgWSPYS082g
# Htc/a5MsE8ZMzRqkqeur2FbCSfbGUaCCAxgwggMUMIIB/KADAgECAhBO/339yhdn
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIH9ANJOT
# 2FVLJFgQGYOybCGAXqO+95sPm28CDdVFwFlVMA0GCSqGSIb3DQEBAQUABIIBAARV
# DBXglSzP+VS6/28Tke7jwWLPtWTnDsCusQD7NKnhN7khcAuK6qDdhjHMgyJIoiZU
# sb57NyZgzZn6zSsQMP2nf47xDA5lyrbWGfhcHX1qohVDU1cds8Gaae9Z6X7LmY/V
# OoFkZGp5ajkooXIjh4IZUIj5VXmhwRHSQ9s5DjvpFvjHR7z8XqXCuI0pQvwC6FhE
# qTIRvKmIlfSToitEyufDdXKsH/2nnnHv/xDD0tAg1HzTHxeD3EYVXK8oDD4uhG/g
# 6P92hjTXiqwsBhTijsnJszmt1Ejdn1sxyR8Tivh3HRFp+ui5RDtLk2JY+ruafNCP
# tJQR6qDJdpYSxe4aPW0=
# SIG # End signature block
