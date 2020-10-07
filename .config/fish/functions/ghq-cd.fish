function ghq-cd
    set DIR (ghq list -p | peco)
    cd {$DIR}
end
