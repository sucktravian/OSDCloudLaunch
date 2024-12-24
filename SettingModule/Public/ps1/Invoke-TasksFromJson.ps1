function Invoke-TasksFromJson {
    param (
        [string]$JsonPath
    )
    $tasks = (Get-Content -Path $JsonPath | ConvertFrom-Json).Tasks

    # Load the last completed task
    $lastCompletedTask = Get-TaskState

    foreach ($task in $tasks) {
        # Skip tasks completed before the last completed task
        if ($lastCompletedTask -and $task.Name -eq $lastCompletedTask) {
            Write-Host "Resuming from task: $($task.Name)" -ForegroundColor Green
            $lastCompletedTask = $null # Reset so subsequent tasks are not skipped
            continue
        }
        Write-Host "Starting task: $($task.Name)" -ForegroundColor Green
    
        # Execute the command
        try {
            . $task.Command
        }
        catch {
            Write-Host "Task $($task.Name) failed: $_" -ForegroundColor Red
            throw $_
        }
    
        # Save the task state after completion
        Save-TaskState -TaskName $task.Name
    
        # Reboot if the task requires it
        if ($task.Name -eq "CheckDrivers" -or $task.Name -eq "InstallWindowsUpdates") {
            Write-Host "Reboot required after task: $($task.Name)" -ForegroundColor Yellow
            Restart-Computer -Force
            break
        }
    }
    Write-Host "All tasks have been completed!" -ForegroundColor Green
}