function hp() {
    local option="$1"

    if [[ $option == 'help' ]] || [[ $option == '' ]]; then
        printf """usage: hp [help]\n"
        printf "          <command> [<args>]\n"
        printf "\n"
        printf "These are common commands used in various situations:\n"
        printf "\n"
        printf "   open [Name]     Open an note\n"
        printf "\n"
        printf "Notes:\n"
        ls -1 $HOME/.dotfiles/notes | awk '{ print "   "$0 }'
    elif [[ $option == 'open' ]]; then
        local notesName="$2"
        if [[ $notesName != '' ]]; then
            vi "$HOME/.dotfiles/notes/$notesName"
        fi
    elif [ -f "$HOME/.dotfiles/notes/$option" ]; then
        printf "\n"
        printf "Notes:\n"
        cat "$HOME/.dotfiles/notes/$option" | awk '{ print "   "$0 }'
    else
        printf "Not have $option, please choose the options:\n"
        ls -1 $HOME/.dotfiles/notes | awk '{ print "   "$0 }'
    fi
}
