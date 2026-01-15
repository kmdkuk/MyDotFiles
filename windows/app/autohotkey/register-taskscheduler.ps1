$ErrorActionPreference = "Stop"

Write-Output "Registering kmdkuk.ahk to Task Scheduler..."

$AhkScript = Join-Path $PSScriptRoot "kmdkuk.ahk"

if (Test-Path $AhkScript) {
    # Find AutoHotkey.exe
    $AhkExe = $null
    
    # Check Registry
    try {
        $AhkExe = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\AutoHotkey.exe" -ErrorAction Stop | Select-Object -ExpandProperty '(default)'
    }
    catch {}

    # Check default paths if registry failed
    if ([string]::IsNullOrEmpty($AhkExe) -or !(Test-Path $AhkExe)) {
        $CandidatePaths = @(
            "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey.exe",
            "$env:LOCALAPPDATA\Programs\AutoHotkey\AutoHotkey.exe",
            "C:\Program Files\AutoHotkey\v2\AutoHotkey.exe",
            "C:\Program Files\AutoHotkey\AutoHotkey.exe"
        )
        foreach ($path in $CandidatePaths) {
            if (Test-Path $path) {
                $AhkExe = $path
                break
            }
        }
    }
    
    # Check Command
    if ([string]::IsNullOrEmpty($AhkExe)) {
        $Command = Get-Command "AutoHotkey" -ErrorAction SilentlyContinue
        if ($Command) {
            $AhkExe = $Command.Source
        }
    }

    if (![string]::IsNullOrEmpty($AhkExe) -and (Test-Path $AhkExe)) {
        $TaskName = "kmdkuk_autohotkey"
        
        # Unregister existing task if exists
        $ExistingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
        if ($ExistingTask) {
            Write-Output "Removing existing task: $TaskName"
            Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
        }

        # Register new task
        Write-Output "Creating new task: $TaskName"
        $Action = New-ScheduledTaskAction -Execute $AhkExe -Argument $AhkScript
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
        Write-Warning "AutoHotkey.exe not found. Skipping task registration."
    }
}
else {
    Write-Warning "kmdkuk.ahk not found at $AhkScript"
}
