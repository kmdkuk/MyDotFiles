$ErrorActionPreference = "Stop"

Write-Output "Starting verification..."

# 1. Check Symlinks
Write-Output "Checking symlinks..."
$Links = @(
    "$HOME\.vimrc",
    "$HOME\.config\starship.toml",
    "$HOME\.config\git\config",
    "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
)

foreach ($link in $Links) {
    if (Test-Path -Path $link) {
        # Check if it is a reparse point (symlink)
        $item = Get-Item -Path $link -Force
        if ($item.LinkType -eq "SymbolicLink") {
             Write-Output "OK: $link is a symlink"
        } else {
             Write-Output "ERROR: $link is NOT a symlink (Type: $($item.LinkType))"
             exit 1
        }
    } else {
        Write-Output "ERROR: $link does not exist"
        exit 1
    }
}

# 2. Check Profile Loading
Write-Output "Checking profile loading..."
try {
    # Start a new pwsh process to load the profile and check for errors
    # We check if a function defined in the profile exists
    $result = pwsh -NoProfile -Command "
        if (Test-Path `$PROFILE) { . `$PROFILE } else { Write-Error 'Profile not found' }
        if (Get-Command ghq-cd -ErrorAction SilentlyContinue) { 'OK' } else { 'ERROR' }
    "
    if ($result -match "OK") {
        Write-Output "OK: Profile loaded successfully"
    } else {
        Write-Output "ERROR: Profile failed to load or ghq-cd missing"
        exit 1
    }
} catch {
    Write-Output "ERROR: Failed to test profile loading: $_"
    exit 1
}

# 3. Check Functions (Double check if logic above wasn't enough)
# The above check already verified ghq-cd, effectively verifying the function.

Write-Output "Verification passed!"
