$OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
$OutputEncoding = [Text.Encoding]::Default
$Env:HOME = $HOME

$ENV:Path = "${HOME}\bin;" + $ENV:Path

Set-Alias git hub

function Enter-GhqRepo {
  Set-Location $(ghq list  --full-path | peco)
}
Set-Alias ghq-cd Enter-GhqRepo

function Invoke-GhqGet() {
  $name = "kmdkuk"
  if ($1 -eq "") {
    name=$1
  }
  $url = "$(gh repo list $name -L 1000 --json url --jq '.[].url' | Sort-Object | peco)"
  if ("$url" -ne "") {
    ghq get $url
  }
}
Set-Alias ghq-get Invoke-GhqGet

function Update-AllGhqRepos() {
  ghq list | ghq get --update --parallel
}
Set-Alias ghq-update-all Update-AllGhqRepos

function Show-PecoHistory {
  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  $history = [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems() | Sort-Object -Descending Id | Select-Object -Unique CommandLine
  $selected = $history.CommandLine | peco --query "$line"

  if ($selected) {
    [Microsoft.PowerShell.PSConsoleReadLine]::ReplaceInput($selected)
  }
}

Set-PSReadLineKeyHandler -Key Ctrl+r -ScriptBlock { Show-PecoHistory }

Invoke-Expression (&starship init powershell)

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
