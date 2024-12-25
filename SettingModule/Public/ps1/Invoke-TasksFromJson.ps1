function Invoke-TasksFromJson {
    param (
        [string]$JsonPath
    )
    $tasks = (Get-Content -Path $JsonPath | ConvertFrom-Json).Tasks

    # Get the base path of the JSON file
    $jsonBasePath = Split-Path -Parent $JsonPath
    $scriptsBasePath = Join-Path -Path $jsonBasePath -ChildPath "SettingModule\Public\ps1"

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

        # Resolve the full path of the script
        $scriptPath = Join-Path -Path $scriptsBasePath -ChildPath $task.Command

        # Execute the command
        try {
            if (Test-Path $scriptPath) {
                Write-Host "Executing script: $scriptPath" -ForegroundColor Cyan

                # Check if Parameters exist
                if ($task.Parameters) {
                    # Build the parameter string dynamically
                    $paramArgs = @()
                    foreach ($key in $task.Parameters.Keys) {
                        $paramArgs += "-$key"
                        $paramArgs += $task.Parameters[$key]
                    }
                    # Execute the script with parameters
                    & $scriptPath @paramArgs
                } else {
                    . $scriptPath
                }
            } else {
                Write-Host "Script not found: $scriptPath" -ForegroundColor Red
                throw "Script not found: $scriptPath"
            }
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
