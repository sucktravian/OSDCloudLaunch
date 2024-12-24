function Save-TaskState {
    param ([string]$TaskName)
    $state = @{ LastCompletedTask = $TaskName }
    $state | ConvertTo-Json | Set-Content -Path $global:TaskStateFile
}