function al() {
    local option="$1"

    if [[ $option == 'help' ]] || [[ $option == '' ]]; then
        printf """usage: al [help]\n"
        printf "          <command> [<args>]\n"
        printf "\n"
        printf "These are common commands used in various situations:\n"
        printf "\n"
        printf "   open [name]    Open an alias group\n"
        printf "   save                Save change\n"
        printf "   <name>         Print an alias group\n"
        printf "\n"
        printf "Alias:\n"
        ls -1 $HOME/.dotfiles/alias | sed 's/.zsh//g' | awk '{ print "   "$0 }'
    elif [[ $option == 'open' ]]; then
        vim $HOME/.dotfiles/alias.zsh
    elif [[ $option == 'save' ]]; then
        exec $SHELL
    elif [ -f "$HOME/.dotfiles/alias/$option.zsh" ]; then
        vim "$HOME/.dotfiles/alias/$option.zsh"
    else
        printf "Not have $option, please choose the options:\n"
        ls -1 $HOME/.dotfiles/alias | sed 's/.zsh//g' | awk '{ print "   "$0 }'
    fi
}


for f in $HOME/.dotfiles/alias/*; do source $f; done
