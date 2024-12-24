function Get-TaskState {
    if (Test-Path $global:TaskStateFile) {
        return (Get-Content -Path $global:TaskStateFile | ConvertFrom-Json).LastCompletedTask
    }
    return $null
}