$OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')
$Env:HOME = $HOME
Invoke-Expression (&starship init powershell)
