# starship
Write-Output "starship"
New-Item -Type SymbolicLink $HOME\.config\starship.toml -Value $HOME\MyDotFiles\starship.toml

# vim
Write-Output "vim"
New-Item -Type SymbolicLink $HOME\.vimrc -Value $HOME\MyDotFiles\vim\.vimrc

# git
Write-Output "git"
mkdir -p $HOME\.config\git
New-Item -Type SymbolicLink $HOME\.config\git\config -Value $HOME\MyDotFiles\git\.config\git\config
New-Item -Type SymbolicLink C:\ProgramData\Git\config -Value $HOME\MyDotFiles\git\.config\git\config
New-Item -Type SymbolicLink $HOME\.config\git\template -Value $HOME\MyDotFiles\git\.config\git\template
New-Item -Type SymbolicLink $HOME\.config\git\ignore -Value $HOME\MyDotFiles\git\.config\git\ignore
New-Item -Type SymbolicLink $HOME\.config\git\local.config -Value $HOME\MyDotFiles\git\.config\git\win.config
New-Item -Type SymbolicLink $HOME\.config\git\work.config -Value $HOME\MyDotFiles\git\.config\git\work.config

# zsh/bash
Write-Output "zsh/bash"
New-Item -Type SymbolicLink $HOME\.bashrc -Value $HOME\MyDotFiles\.bashrc
New-Item -Type SymbolicLink $HOME\.zshrc -Value $HOME\MyDotFiles\.zshrc

# Powershell profile
Write-Output "Powershell profile"
New-Item -Type SymbolicLink $HOME\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1 -Value $HOME\MyDotFiles\windows\Microsoft.PowerShell_profile.ps1
New-Item -Type SymbolicLink $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -Value $HOME\MyDotFiles\windows\Microsoft.PowerShell_profile.ps1
New-Item -Type SymbolicLink $HOME\Documents\WindowsPowerShell\Microsoft.Powershell_profile.ps1 -Value $HOME\MyDotFiles\windows\Microsoft.PowerShell_profile.ps1

Write-Output "install tools(TODO)"
if(where.exe choco){
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

choco install .\choco.config
