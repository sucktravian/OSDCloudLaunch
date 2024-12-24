function Get-Java {
    # Check Java AutoUpdate status from Registry in "HLKM:\"
    $CheckJavaUpdate = Test-Path -Path "HKLM:\SOFTWARE\WOW6432NODE\JavaSoft\Java Update\Policy"

    # Check if Java is installed or not
    $javaExecutable = Get-Command -Name "java" -ErrorAction SilentlyContinue

    if ($javaExecutable) {
        # Java is installed
        $output = "Javaがインストールされています。 自動更新 = {0}" -f $CheckJavaUpdate
    }
    else {
        # Java is not installed
        $output = "Javaはインストールされていません。"
    }

    return $output
}