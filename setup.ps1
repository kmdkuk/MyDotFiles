$ErrorActionPreference = "Stop"

if(!(where.exe choco)){
    Write-Output "install choco"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

if(!(where.exe git)) {
    Write-Output "install git"
    choco install git
}

${DOTFILES_HOME}="$HOME\MyDotFiles"
if(!(Test-Path -Path ${DOTFILES_HOME} )) {
    git clone https://github.com/kmdkuk/MyDotFiles.git ${DOTFILES_HOME}
}

Write-Output "prepare symlink"
# starship
Write-Output "starship"
New-Item -Force -Type SymbolicLink $HOME\.config\starship.toml -Value ${DOTFILES_HOME}\config\starship.toml

# vim
Write-Output "vim"
New-Item -Force -Type SymbolicLink $HOME\.vimrc -Value ${DOTFILES_HOME}\config\vim\.vimrc

# git
Write-Output "git"
if(!(Test-Path -Path $HOME\.config\git)){
    mkdir -p $HOME\.config\git
}
New-Item -Force -Type SymbolicLink $HOME\.config\git\config -Value ${DOTFILES_HOME}\config\git\.config\git\config
New-Item -Force -Type SymbolicLink C:\ProgramData\Git\config -Value ${DOTFILES_HOME}\config\git\.config\git\config
New-Item -Force -Type SymbolicLink $HOME\.config\git\template -Value ${DOTFILES_HOME}\config\git\.config\git\template
New-Item -Force -Type SymbolicLink $HOME\.config\git\ignore -Value ${DOTFILES_HOME}\config\git\.config\git\ignore
New-Item -Force -Type SymbolicLink $HOME\.config\git\local.config -Value ${DOTFILES_HOME}\config\git\.config\git\win.config
New-Item -Force -Type SymbolicLink $HOME\.config\git\work.config -Value ${DOTFILES_HOME}\config\git\.config\git\work.config

# zsh/bash
Write-Output "zsh/bash"
New-Item -Force -Type SymbolicLink $HOME\.bashrc -Value ${DOTFILES_HOME}\.bashrc
New-Item -Force -Type SymbolicLink $HOME\.zshrc -Value ${DOTFILES_HOME}\.zshrc

# Powershell profile
Write-Output "Powershell profile"
New-Item -Force -Type SymbolicLink $HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1 -Value ${DOTFILES_HOME}\windows\Microsoft.PowerShell_profile.ps1
New-Item -Force -Type SymbolicLink $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -Value ${DOTFILES_HOME}\windows\Microsoft.PowerShell_profile.ps1
New-Item -Force -Type SymbolicLink $HOME\Documents\WindowsPowerShell\Microsoft.Powershell_profile.ps1 -Value ${DOTFILES_HOME}\windows\Microsoft.PowerShell_profile.ps1

Write-Output "install tools"
if($env:NO_INSTALL -eq 1){
    Write-Output "Skip install tools"
    exit 0
}
choco install -y "${DOTFILES_HOME}\packages.config"
