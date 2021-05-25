function check-update-dotfiles
    set dotfiles_home "~/MyDotFiles"

    if test -n "(git -C $dotfiles_home status --porcelain)"; or \
            ! git -C $dotfiles_home diff --exit-code --stat --cached origin/main >/dev/null
        echo -e "\e[36m=== DOTFILES IS DIRTY ===\e[m"
        echo -e "\e[33mThe dotfiles have been changed.\e[m"
        echo -e "\e[33mPlease update them with the following command.\e[m"
        echo "  cd $dotfiles_home"
        echo "  git add -A"
        echo "  git commit"
        echo "  git push origin master"
        echo -e "\e[33mor\e[m"
        echo "  git push origin master"
        echo -e "\e[36m=========================\e[m"
    end
end
