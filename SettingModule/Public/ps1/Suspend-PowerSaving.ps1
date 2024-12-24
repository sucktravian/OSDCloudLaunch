function Suspend-PowerSaving {
    $code = @'
    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern void SetThreadExecutionState(uint esFlags);
'@

    $ES_CONTINUOUS = [uint32]"0x80000000"
    $ES_DISPLAY_REQUIRED = [uint32]"0x00000002"
    $ste = Add-Type -MemberDefinition $code -Name System -Namespace Win32 -PassThru
    $result = $ste::SetThreadExecutionState($ES_CONTINUOUS -bor $ES_DISPLAY_REQUIRED)

    if ($result -eq 0) {
        Write-Warning "Failed to set execution state."
    }
    else {
        Write-Output "Power-saving suspension is active."
    }
}