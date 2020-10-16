New-Item -Type SymbolicLink ~\.vimrc -Value "$pwd\.vimrc"
New-Item -Type SymbolicLink ~\.gitconfig -Value "$pwd\.gitconfig"
New-Item -Type SymbolicLink ~\.gitignore_global -Value "$pwd\.gitignore_global"
New-Item -Type SymbolicLink ~\.commit_template -Value "$pwd\.commit_template"
