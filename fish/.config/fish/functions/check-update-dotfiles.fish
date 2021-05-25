function check-update-dotfiles
    set dotfiles_home "$HOME/MyDotFiles"
    # 文字列空だったら１，０なら文字があった
    git -C $dotfiles_home status --porcelain | string length >/dev/null
    set s $status
    git -C $dotfiles_home diff --exit-code --stat --cached origin/master | string length >/dev/null
    set d $status
    if test "$s" = "0"; or test "$d" = "0"
        echo -e "\e[36m=== DOTFILES IS DIRTY ===\e[m"
        echo -e "\e[33mThe dotfiles have been changed.\e[m"
        echo -e "\e[33mPlease update them with the following command.\e[m"
        echo "  cd $dotfiles_home"
        echo "  git add -A"
        echo "  git commit"
        echo "  git push origin master"
        echo -e "\e[36m=========================\e[m"
    end
end
