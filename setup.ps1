$ErrorActionPreference = "Stop"

${DOTFILES_HOME}="$HOME\MyDotFiles"
if(!(Test-Path -Path ${DOTFILES_HOME} )) {
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
if(!(Test-Path -Path $HOME\.config\git)){
    mkdir -p $HOME\.config\git
}
New-Item -Force -Type SymbolicLink $HOME\.config\git\config -Value ${DOTFILES_HOME}\.config\git\config
New-Item -Force -Type SymbolicLink C:\ProgramData\Git\config -Value ${DOTFILES_HOME}\.config\git\config
New-Item -Force -Type SymbolicLink $HOME\.config\git\template -Value ${DOTFILES_HOME}\.config\git\template
New-Item -Force -Type SymbolicLink $HOME\.config\git\ignore -Value ${DOTFILES_HOME}\.config\git\ignore
New-Item -Force -Type SymbolicLink $HOME\.config\git\local.config -Value ${DOTFILES_HOME}\.config\git\win.config
# New-Item -Force -Type SymbolicLink $HOME\.config\git\work.config -Value ${DOTFILES_HOME}\config\git\.config\git\work.config

# zsh/bash
Write-Output "zsh/bash"
New-Item -Force -Type SymbolicLink $HOME\.bashrc -Value ${DOTFILES_HOME}\home\.bashrc
New-Item -Force -Type SymbolicLink $HOME\.zshrc -Value ${DOTFILES_HOME}\home\.zshrc

# Powershell profile
Write-Output "Powershell profile"
New-Item -Force -Type SymbolicLink $HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1 -Value ${DOTFILES_HOME}\windows\Microsoft.PowerShell_profile.ps1
New-Item -Force -Type SymbolicLink $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -Value ${DOTFILES_HOME}\windows\Microsoft.PowerShell_profile.ps1
New-Item -Force -Type SymbolicLink $HOME\Documents\WindowsPowerShell\Microsoft.Powershell_profile.ps1 -Value ${DOTFILES_HOME}\windows\Microsoft.PowerShell_profile.ps1
