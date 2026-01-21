$ErrorActionPreference = "Stop"

Write-Output "Registering kmdkuk.ahk to Task Scheduler..."

$AhkScript = Join-Path $PSScriptRoot "kmdkuk.ahk"

if (Test-Path $AhkScript) {
    $TaskName = "kmdkuk_autohotkey"
        
    # Unregister existing task if exists
    $ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($ExistingTask) {
        Write-Output "Removing existing task: $TaskName"
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    }

    # Register new task
    Write-Output "Creating new task: $TaskName"
    $Action = New-ScheduledTaskAction -Execute $AhkScript
    $Trigger = New-ScheduledTaskTrigger -AtLogon
        
    # Use current user for Principal
    $Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest
        
    try {
        Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -ErrorAction Stop
        Write-Output "Task $TaskName registered successfully."
    }
    catch {
        Write-Error "Failed to register task. Please run as Administrator. Details: $_"
    }
}
else {
    Write-Warning "kmdkuk.ahk not found at $AhkScript"
}
