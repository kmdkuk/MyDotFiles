$OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
$OutputEncoding = [Text.Encoding]::Default
$Env:HOME = $HOME

$ENV:Path = "${HOME}\bin;" + $ENV:Path

function ghq-cd {
  cd $(ghq list  --full-path | peco)
}

function ghq-get() {
  $name = "kmdkuk"
  if($1 -eq ""){
    name=$1
  }
  $url = "$(gh repo list $name -L 1000 --json url --jq '.[].url' | sort | peco)"
  if("$url" -ne ""){
    ghq get $url
  }
}

function ghq-update-all() {
  ghq list | ghq get --update --parallel
}

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
