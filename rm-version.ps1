$file = "choco.config"
$xmldoc = [xml](Get-Content .\$file)
for($i = 0; $i -lt $xmldoc.packages.package.Count; $i++) {
    $xmldoc.packages.package[$i].RemoveAttribute("version")
}
$xmldoc.Save(".\$file")
