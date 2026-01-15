$ErrorActionPreference = "Stop"

${DOTFILES_HOME} = "$HOME\MyDotFiles"
if (!(Test-Path -Path ${DOTFILES_HOME} )) {
    git clone https://github.com/kmdkuk/MyDotFiles.git ${DOTFILES_HOME}
}

Write-Output "prepare symlink"
# starship
Write-Output "starship"
New-Item -Force -Type SymbolicLink $HOME\.config\starship.toml -Value ${DOTFILES_HOME}\.config\starship.toml

# vim
Write-Output "vim"
New-Item -Force -Type SymbolicLink $HOME\.vimrc -Value ${DOTFILES_HOME}\home\.vimrc

# git
Write-Output "git"
if (!(Test-Path -Path $HOME\.config\git)) {
    mkdir -p $HOME\.config\git
}
New-Item -Force -Type SymbolicLink $HOME\.config\git\config -Value ${DOTFILES_HOME}\.config\git\config
New-Item -Force -Type SymbolicLink C:\ProgramData\Git\config -Value ${DOTFILES_HOME}\.config\git\config
New-Item -Force -Type SymbolicLink $HOME\.config\git\template -Value ${DOTFILES_HOME}\.config\git\template
New-Item -Force -Type SymbolicLink $HOME\.config\git\ignore -Value ${DOTFILES_HOME}\.config\git\ignore
New-Item -Force -Type SymbolicLink $HOME\.config\git\local.config -Value ${DOTFILES_HOME}\.config\git\win.config

# Powershell profile
Write-Output "Powershell profile"
New-Item -Force -Type SymbolicLink $HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1 -Value ${DOTFILES_HOME}\windows\Microsoft.PowerShell_profile.ps1
New-Item -Force -Type SymbolicLink $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -Value ${DOTFILES_HOME}\windows\Microsoft.PowerShell_profile.ps1
New-Item -Force -Type SymbolicLink $HOME\Documents\WindowsPowerShell\Microsoft.Powershell_profile.ps1 -Value ${DOTFILES_HOME}\windows\Microsoft.PowerShell_profile.ps1

# Install tools
$NO_INSTALL = $env:NO_INSTALL
if ([string]::IsNullOrEmpty($NO_INSTALL)) {
    $NO_INSTALL = "0"
}

if ($NO_INSTALL -eq "0") {
    Write-Output "Installing tools..."
    
    # Chocolatey
    # https://chocolatey.org/install
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Output "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    # Scoop
    # https://scoop.sh/
    if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Output "Installing Scoop..."
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    }

    # Import packages
    $ImportScript = Join-Path ${DOTFILES_HOME} "scripts\import-packages.ps1"
    if (Test-Path $ImportScript) {
        Write-Output "Running import-packages.ps1..."
        & $ImportScript
    }
    else {
        Write-Warning "import-packages.ps1 not found at $ImportScript"
    }
}
else {
    Write-Output "Skipping tool installation (NO_INSTALL=$NO_INSTALL)"
}
